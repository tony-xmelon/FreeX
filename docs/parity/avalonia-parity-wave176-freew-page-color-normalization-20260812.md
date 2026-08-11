# Avalonia parity wave 176: shared FreeW page-color normalization

Date: 2026-08-12

## Outcome

WPF and Avalonia now delegate Design > Page Color model-token normalization to `PageColorDialogPlanner.NormalizeForModel`. Blank values clear the page color; nonblank values are trimmed and receive the canonical leading hash. The exact duplicated renderer helpers were removed.

## Verification policy

No UI tests or visual capture hosts were run on this machine. Verification for this wave is limited to portable Presentation tests and compile-only builds.

Completed checks:

- Focused page-color planner tests: 7 passed.
- Full `FreeW.App.Presentation.Tests`: 1,398 passed.
- `FreeW.App.Host.Tests` and `FreeW.App.Avalonia.Tests` Release compile-only builds, including both renderer apps: succeeded with 0 warnings and 0 errors.
- `git diff --check`: passed (line-ending conversion notices only).

The repository-wide preflight and solution build were not repeated because both exceeded the local five-minute command bound in wave 170. No UI or visual test fallback was used.
