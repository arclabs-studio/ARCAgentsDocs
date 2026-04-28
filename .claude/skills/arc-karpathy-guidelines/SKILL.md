---
name: arc-karpathy-guidelines
description: |
  Behavioral baseline reducing common LLM coding mistakes derived from
  Andrej Karpathy's observations. Surface assumptions before coding,
  deliver minimum viable code, make surgical changes, loop until verifiable
  goals are met. Use when "writing code", "reviewing code", "refactoring",
  "before implementing a feature", "architecture decision", or any task
  that risks overcomplication / unfounded assumptions.
user-invocable: true
metadata:
  author: ARC Labs Studio (derived from forrestchang/andrej-karpathy-skills, MIT)
  version: "1.0.0"
---

# Karpathy Guidelines — ARC Labs Edition

Behavioral principles to reduce common LLM coding mistakes, adapted to Swift/iOS and the ARC Labs Studio development workflow. Derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial one-liners, use judgment.

---

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing anything:

- **State your assumptions explicitly.** If uncertain, ask rather than guess.
- **Present multiple interpretations.** Don't silently pick one when ambiguity exists.
- **Push back when a simpler approach exists.** Advocate for it; don't implement the complex path unchallenged.
- **Stop when confused.** Name what's unclear and ask.

**Swift/iOS example:**

User says: "Add a search feature."

❌ Don't silently build a debounced `SearchUseCase` with ranking, an `@Observable` `SearchViewModel`, and a `SearchRepository` persisting history.

✅ Do ask first:
```
Before implementing, I need to clarify:
1. **Scope** — search within already-fetched restaurants or server-side query?
2. **Ranking** — exact-match only, or fuzzy (e.g. "sushi" → Japanese)?
3. **Persistence** — store recent searches? (adds a Use Case + DTO)
Simplest approach: filter the existing in-memory list via SearchRestaurantsUseCase.
Would that be enough, or do you need more?
```

---

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- No premature protocol extraction — if only one concrete type exists, skip the protocol.
- If you write 200 lines and 50 would do, rewrite it.

Ask yourself: *Would a senior engineer say this is overcomplicated? If yes, simplify.*

**Swift/iOS example:**

User says: "Make the toggle button async."

❌ Don't add a `ToggleCoordinator` actor, a `TogglePolicy` protocol, and a `@discardableResult` wrapper for retry logic.

✅ Do add `async` to the existing button action in the ViewModel:
```swift
func onTappedToggleFavorite(_ id: UUID) async {
    try? await toggleFavoriteUseCase.execute(id: id)
}
```

---

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, **mention it — don't delete it.**
- Don't add `arcWithAnimation()` to views you didn't touch.
- Don't reorganize `MARK` sections you weren't asked to change.

When your changes create orphans:
- Remove imports/variables/functions that **your** changes made unused.
- Don't remove pre-existing dead code unless asked.

**The test:** Every changed line should trace directly to the user's request.

---

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform imperative tasks into verifiable goals before starting:

| Instead of... | Transform to... |
|--------------|-----------------|
| "Add validation" | "Write `@Test` for invalid inputs, then make them pass" |
| "Fix the bug" | "Write a failing `@Test` that reproduces it, then make it pass" |
| "Refactor X" | "All existing tests pass before and after; no new failures" |
| "Speed up the list" | "Instruments Time Profiler shows < 2ms per scroll frame on iPhone 17 Pro" |

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

**ARC Labs TDD mapping:** Goal-driven execution aligns directly with the ARC TDD Red-Green-Refactor cycle. Always write the `@Test` first; the test *is* the success criterion.

---

## Relationship to Existing ARC Standards

| Principle | ARC Labs rule it reinforces | New emphasis it adds |
|-----------|---------------------------|---------------------|
| Think Before Coding | Plan Mode for complex tasks | Explicit assumption-surfacing; push back on over-specified requests |
| Simplicity First | No abstractions for single-use code; no force-unwrap hacks | Apply even to architecture choices (skip protocol if one concrete type) |
| Surgical Changes | Private methods in private extension; match existing style | Applies across layers — don't "improve" Domain while fixing Presentation |
| Goal-Driven Execution | TDD with Swift Testing (`arc-tdd-patterns`) | Frame ALL tasks as verifiable criteria, not just test tasks |

---

## When to Invoke This Skill

Load `/arc-karpathy-guidelines` when:

- You're about to start implementing and haven't explicitly stated your assumptions.
- The task feels underspecified — resist the urge to fill gaps silently.
- A diff is getting large; question whether every changed line maps to the request.
- You're writing a plan and haven't defined what "done" looks like.
- After a review surfaces unnecessary complexity.

---

*Derived from [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) · MIT License*
*See `references/karpathy-examples.md` for extended Swift/iOS examples.*
