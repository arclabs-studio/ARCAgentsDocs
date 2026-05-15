## Notes & Obsidian

`notes/` is a **gitignored symlink** → `ObsidianVault/01 - Projects/<ProjectName>/`.
Never committed. Recreate after every clone or worktree add (the SessionStart
hook does this automatically; the command below is the manual fallback):

```bash
ln -s "$HOME/Documents/ObsidianVault/01 - Projects/<ProjectName>" notes
```

### Folder conventions

| Path | Purpose |
|------|---------|
| `notes/features/` | Active per-feature notes (mirrors Obsidian `features/`) |
| `notes/archive/` | Archived notes post-merge |
| `notes/decisions/` | Cross-cutting decision records (drafts; promote to `memory/DECISIONS.md` if they stick) |
| `notes/plans/` | Claude Code plans — auto-synced at session end via Stop hook |
| `notes/troubleshooting/` | Debugging session notes written during active work |

### Writing troubleshooting notes

```
notes/troubleshooting/YYYY-MM-DD-<TICKET>-short-description.md
```

### Plan auto-sync

Stop hook (`.claude/hooks/sync-plans.sh`) runs at session end:
- Finds plans from `~/.claude/plans/` modified in the last 8 hours
- Copies to `notes/plans/YYYY-MM-DD-<branch-slug>-<original-stem>.md`
- Idempotent; skips silently if `notes/plans/` doesn't exist (un-symlinked checkout)
- Branch slug strips type prefix: `feature/<TICKET>-foo` → `<TICKET>-foo`

### Cross-machine

`setup-notes.sh` uses `$HOME` and exits 0 silently when the vault is absent —
notes integration is opt-in per machine. CI and contributors without Obsidian
remain unaffected.

### Replicating to other projects

See `/arc-notes-system` skill in ARCKnowledge for the full standard, or run
`scripts/arc-setup-notes-system.sh` from ARCDevTools for a one-shot bootstrap.
