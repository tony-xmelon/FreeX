# Avalonia parity wave 172: shared FreeW index-mark mutations

Date: 2026-08-12

## Outcome

WPF and Avalonia now delegate single index-entry marking and Mark All to `IndexMarkMutationCoordinator` in Presentation. Shared code owns mark normalization, duplicate prevention, body/table target mutation, run insertion, undo grouping, and rollback. Renderers retain only caret, focus, and visual invalidation work.

This also closes a functional divergence: Avalonia previously used a renderer-local run splitter that could split a ruby-annotated run when an index mark landed inside its base text. Both renderers now use `RevisionEditPlanner.InsertRunAtOffset`, which preserves ruby as one semantic run and places the hidden XE mark after it.

## Verification policy

No UI tests or visual capture hosts were run on this machine. Verification for this wave is limited to portable Presentation tests and compile-only builds.

Completed checks:

- Focused `IndexMarkMutationCoordinatorTests`: 5 passed.
- Full `FreeW.App.Presentation.Tests`: 1,386 passed.
- `FreeW.App.Host.Tests` and `FreeW.App.Avalonia.Tests` Release compile-only builds, including both renderer apps: succeeded with 0 warnings and 0 errors.
- `git diff --check`: passed (line-ending conversion notices only).

The repository-wide preflight and solution build were not repeated because both exceeded the local five-minute command bound in wave 170. No UI or visual test fallback was used.
