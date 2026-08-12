# Avalonia parity wave 171: shared FreeW style-catalog mutations

Date: 2026-08-12

## Outcome

WPF and Avalonia now delegate paragraph-style creation/application, modification, deletion, target validation, and undo grouping to `StyleCatalogMutationCoordinator` in Presentation. The renderers retain only native-editor synchronization and edit-lock checks.

The shared creation path also rolls back its undo group on failure. This replaces the previous renderer-local `AbortUndoGroup` behavior, which closed history without reverting commands that had already applied.

## Verification policy

No UI tests or visual capture hosts were run on this machine. Verification for this wave is limited to portable Presentation tests and compile-only builds.

Completed checks:

- Focused `StyleCatalogMutationCoordinatorTests`: 6 passed.
- Full `FreeW.App.Presentation.Tests`: 1,381 passed.
- `FreeW.App.Host` and `FreeW.App.Avalonia` Release builds: succeeded with 0 warnings and 0 errors.
- `FreeW.App.Host.Tests` and `FreeW.App.Avalonia.Tests` Release compile-only builds: succeeded with 0 warnings and 0 errors.
- `git diff --check`: passed (line-ending conversion notices only).

The repository-wide preflight and solution build were not repeated because both had already exceeded the local five-minute command bound in wave 170. No UI or visual test fallback was used.
