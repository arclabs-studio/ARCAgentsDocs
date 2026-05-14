---
name: arc-notes-system
description: |
  Operational notes system backed by an Obsidian vault, mounted into each
  ARC project as a gitignored `notes/` symlink. Standardizes how features,
  decisions, plans, troubleshooting sessions, and weekly reviews are
  captured outside of the committed `memory/` tree. Complements
  `/arc-memory` (committed evergreen docs). Use when "setting up notes",
  "configuring Obsidian vault for project", "second brain", "notes symlink",
  "sync plans to Obsidian", "feature notes folder", "troubleshooting notes",
  "decision records", "weekly review note", or "where should I write this
  note".
license: MIT
metadata:
  author: ARC Labs Studio
  version: "1.0.0"
---

# ARC Labs Studio - Notes System (Obsidian-Backed)

## Overview

The `arc-notes-system` defines how each ARC project mounts an Obsidian vault as
a gitignored `notes/` symlink for operational, ephemeral, and per-feature notes.
It complements `/arc-memory`, which covers the committed `memory/` tree of
evergreen documentation.

### Memory vs Notes — The Four-Layer Model

| Layer | Location | Committed? | Lifetime | Purpose |
|-------|----------|-----------|----------|---------|
| **Project memory** | `memory/` (in repo) | ✅ Yes | Long (evergreen) | Architecture, decisions, patterns, dependencies — read by every contributor |
| **Operational notes** | `notes/` (symlink) | ❌ Gitignored | Per-feature / per-session | Working notes, troubleshooting, drafts — owned by the individual |
| **Auto-memory** | `~/.claude/projects/.../memory/` | ❌ Local | Cross-session per machine | Claude's own scratch context (`MEMORY.md`) |
| **Plans (auto-synced)** | `~/.claude/plans/` → `notes/plans/` | ❌ Gitignored | Snapshot at session end | Claude Code plans archived into vault by Stop hook |

The split keeps the repo lean, lets each developer keep personal scratch
without polluting git history, and still surfaces cross-cutting decisions in
the committed `memory/` tree.

## Vault Folder Structure

The Obsidian vault is the source of truth. Each project owns one folder under
`01 - Projects/`:

```
$HOME/Documents/ObsidianVault/
└── 01 - Projects/
    └── <ProjectName>/         # e.g. FavRes, PizzeriaLaFamiglia
        ├── features/          # Active per-feature notes (FVRS-XXX, PIZ-XXX, etc.)
        ├── archive/           # Archived feature notes (post-merge)
        ├── decisions/         # Cross-cutting decision records (mirrors memory/DECISIONS.md scope)
        ├── plans/             # Auto-synced Claude Code plans (Stop hook target)
        └── troubleshooting/   # Debugging session notes written during active work
```

Each project's repo gets a `notes/` symlink pointing at its vault folder:

```bash
ln -s "$HOME/Documents/ObsidianVault/01 - Projects/<ProjectName>" notes
```

## Setup Steps (New ARC Repo)

Apply this checklist to any ARC project (app, package, or web) that needs the
notes integration. Templates live in this skill's `templates/` directory.

1. **Create the vault folder.** In Obsidian, create
   `01 - Projects/<ProjectName>/` with the five subfolders above. Skip
   subfolders the project doesn't need (see Applicability).

2. **Add the SessionStart hook.** Copy
   `templates/setup-notes.sh.template` to `.claude/hooks/setup-notes.sh`,
   replace `<PROJECT_NAME>` with the project's vault folder name, and
   `chmod +x` it. The hook:
   - Is idempotent (re-running is a no-op).
   - Uses `$HOME` — works across machines and worktrees.
   - Skips silently if the vault is absent (cross-machine safe).

3. **Add the Stop hook for plan auto-sync.** Copy
   `templates/sync-plans.sh.template` to `.claude/hooks/sync-plans.sh` and
   `chmod +x` it. No placeholders to replace. The hook:
   - Finds plans from `~/.claude/plans/` modified in the last 8 hours.
   - Copies to `notes/plans/YYYY-MM-DD-<branch-slug>-<plan-stem>.md`.
   - Strips branch type prefix: `feature/FVRS-222-foo` → `FVRS-222-foo`.
   - Skips silently when `notes/plans/` is absent.

4. **Gitignore the symlink.** Add `notes` (no trailing slash — it's a symlink,
   not a directory) to `.gitignore`. Never commit the symlink or its contents.

5. **Wire the hooks into `.claude/settings.local.json`.** Merge the contents
   of `templates/settings.local.json.fragment` into the project's
   `settings.local.json`. Both `hooks.SessionStart` and `hooks.Stop` must be
   registered, and `Write(./notes/**)` must be in `permissions.allow` so
   Claude can write troubleshooting and feature notes without prompting.

6. **Document it in the project's `CLAUDE.md`.** Append the contents of
   `templates/CLAUDE-md-section.md` (with `<ProjectName>` replaced) to the
   bottom of the project's `CLAUDE.md` so every Claude session knows the
   convention.

7. **Bootstrap the symlink locally.** Trigger the SessionStart hook once
   (start a Claude session, or run `.claude/hooks/setup-notes.sh` manually) to
   create the `notes` symlink in the working tree.

## Cross-Machine Support

- **No hardcoded user paths.** Every script and template uses `$HOME`. Never
  hardcode `/Users/<name>/...` — it breaks on other machines, on CI, and on
  worktrees mounted under different paths.
- **Vault path convention:** `$HOME/Documents/ObsidianVault/01 - Projects/<ProjectName>`.
- **Fallback when the vault is absent.** If the vault directory does not
  exist on a given machine (CI, fresh clone, contributor without Obsidian),
  `setup-notes.sh` exits 0 silently — `notes/` is simply not created and the
  Stop hook becomes a no-op. The project remains fully usable; the notes
  integration is opt-in per machine.
- **Worktrees.** The SessionStart hook re-runs in each worktree, so each
  worktree gets its own `notes/` symlink pointing at the same vault folder.

## Naming Conventions

| Type | Path | Example |
|------|------|---------|
| Active feature | `notes/features/<TICKET>-<short-description>.md` | `notes/features/FVRS-138-expenses-graph.md` |
| Archived feature | `notes/archive/<TICKET>-<short-description>-YYYYMMDD.md` | `notes/archive/FVRS-138-expenses-graph-20260515.md` |
| Decision | `notes/decisions/YYYY-MM-DD-<decision-title>.md` | `notes/decisions/2026-05-15-tabrouter-isolation.md` |
| Troubleshooting | `notes/troubleshooting/YYYY-MM-DD-<TICKET>-<short>.md` | `notes/troubleshooting/2026-05-14-FVRS-150-spm-checksum.md` |
| Plan (auto) | `notes/plans/YYYY-MM-DD-<branch-slug>-<plan-stem>.md` | `notes/plans/2026-05-15-FVRS-222-onboarding-implementation.md` |

Tickets use the project's Linear team key (`FVRS`, `PIZ`, etc.). Branch slug
strips the type prefix (`feature/FVRS-222-foo` → `FVRS-222-foo`).

## When to Write Where

| Content | Goes in | Rationale |
|---------|---------|-----------|
| Architecture overview, layer rules | `memory/ARCHITECTURE.md` (committed) | Every contributor must read |
| Cross-cutting decision with long-term impact | `memory/DECISIONS.md` (committed) | Auditable record for the team |
| Project-wide pattern or gotcha | `memory/PATTERNS.md` (committed) | Prevents repeated mistakes |
| Active feature progress, scratch, TODOs | `notes/features/<TICKET>-...md` | Personal/working — not for the team |
| Debug session, root-cause walkthrough | `notes/troubleshooting/...` | Useful later, not part of the codebase |
| Local decision before promoting to ADR | `notes/decisions/...` | Draft; promote to `memory/DECISIONS.md` if it sticks |
| Claude Code plans | `notes/plans/...` (auto via Stop hook) | Snapshots, not authored by hand |
| Cross-session Claude scratch | `~/.claude/projects/.../memory/MEMORY.md` (auto-memory) | Claude-managed, not human-edited |

**Rule of thumb:** if the entire team needs it, commit it under `memory/`. If
only you (or the next debugging session) needs it, write it under `notes/`.

## Applicability

| Project type | Convention | Notes |
|--------------|-----------|-------|
| **Apps** (FavRes-iOS, etc.) | Full convention | `features/`, `archive/`, `decisions/`, `plans/`, `troubleshooting/` |
| **Packages** (ARCNavigation, ARCDesignSystem, etc.) | Reduced — `memory/` + `notes/decisions/` only | Packages don't have per-feature tickets the way apps do; no `features/` or `archive/`. Keep `plans/` and `troubleshooting/` if useful |
| **Web** (ARCKnowledge-Web, etc.) | Full convention adapted | Same five folders; ticket prefix follows the project's tracker |

## Bootstrap Script (ARCDevTools)

A one-shot bootstrap script lives in ARCDevTools at
`scripts/arc-setup-notes-system.sh`. It performs all six setup steps
(creates the hook scripts from these templates, wires the JSON, appends the
CLAUDE.md section, and adds `notes` to `.gitignore`) for any ARC repo. Use it
when onboarding a new project; use this skill's templates when bootstrapping
manually or when scripting a custom variant.

## Examples

### Setting up a new app

User says: "Set up the notes system for the new ChessTrainer app."

1. Create `$HOME/Documents/ObsidianVault/01 - Projects/ChessTrainer/` with
   the five subfolders.
2. Copy `templates/setup-notes.sh.template` → `.claude/hooks/setup-notes.sh`,
   replace `<PROJECT_NAME>` with `ChessTrainer`, `chmod +x`.
3. Copy `templates/sync-plans.sh.template` → `.claude/hooks/sync-plans.sh`,
   `chmod +x`.
4. Add `notes` to `.gitignore`.
5. Merge `templates/settings.local.json.fragment` into
   `.claude/settings.local.json`.
6. Append `templates/CLAUDE-md-section.md` (with `ChessTrainer` substituted)
   to `CLAUDE.md`.
7. Run `.claude/hooks/setup-notes.sh` once — the symlink is created.

### Capturing a debug session mid-flow

User says: "We just spent two hours debugging the SwiftData migration —
write it up."

1. Resolve current ticket (e.g. `FVRS-205`) and today's date.
2. Create
   `notes/troubleshooting/2026-05-15-FVRS-205-swiftdata-version-mismatch.md`.
3. Capture symptoms, root cause, fix, and links to the relevant commit/PR.
4. No commit — `notes/` is gitignored. Obsidian sync handles distribution.

### Promoting a draft decision to an ADR

User says: "We've been using TabRouter isolation for two weeks and it's
sticking — promote it."

1. Read `notes/decisions/2026-05-01-tabrouter-isolation.md`.
2. Append a new ADR entry to committed `memory/DECISIONS.md` with the
   final rationale.
3. Optionally archive the draft by moving it under `notes/archive/`.
4. Commit only the `memory/DECISIONS.md` change.

## Related Skills

| If you need... | Use |
|----------------|-----|
| Committed evergreen docs | `/arc-memory` |
| Worktrees setup (re-runs SessionStart per worktree) | `/arc-worktrees-workflow` |
| Git workflow (branch slug origin) | `/arc-workflow` |
| New project bootstrap | `/arc-project-setup` |
