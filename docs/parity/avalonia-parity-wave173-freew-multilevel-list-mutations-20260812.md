# Avalonia parity wave 173: shared FreeW multilevel-list mutations

Date: 2026-08-12

## Outcome

WPF and Avalonia now delegate Define New Multilevel List mutations to `MultilevelListMutationCoordinator` in Presentation. Shared code owns selected-block validation, duplicate suppression, level clamping, start overrides, linked heading styles, number-format catalog changes, atomic undo, and rollback. Renderers retain only native selection and WPF restriction/edit synchronization concerns.

The shared path removes Avalonia's unchecked paragraph cast and replaces both renderers' failure-only `AbortUndoGroup` behavior with actual rollback of already-applied commands.

## Verification policy

No UI tests or visual capture hosts were run on this machine. Verification for this wave is limited to portable Presentation tests and compile-only builds.

Completed checks:

- Focused `MultilevelListMutationCoordinatorTests`: 2 passed.
- Full `FreeW.App.Presentation.Tests`: 1,388 passed.
- `FreeW.App.Host.Tests` and `FreeW.App.Avalonia.Tests` Release compile-only builds, including both renderer apps: succeeded with 0 warnings and 0 errors.
- `git diff --check`: passed (line-ending conversion notices only).

The repository-wide preflight and solution build were not repeated because both exceeded the local five-minute command bound in wave 170. No UI or visual test fallback was used.
