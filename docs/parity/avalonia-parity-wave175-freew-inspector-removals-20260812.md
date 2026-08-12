# Avalonia parity wave 175: shared FreeW Document Inspector removals

Date: 2026-08-12

## Outcome

WPF and Avalonia now execute Document Inspector cleanup through `DocumentInspector.RemoveSelected` in Core.Model. The shared selection contract owns which metadata categories are removed and returns before/after/removed inspection evidence; renderers retain only native model synchronization and redraw notification.

This eliminates the duplicated four-branch removal sequence and provides a single portable contract proving that unselected comments, revisions, properties, or bookmarks remain untouched.

## Verification policy

No UI tests or visual capture hosts were run on this machine. Verification for this wave is limited to portable model tests and compile-only builds.

Completed checks:

- Focused `DocumentInspectorTests`: 15 passed.
- Full `FreeW.Core.Model.Tests`: 2,023 passed.
- `FreeW.App.Host.Tests` and `FreeW.App.Avalonia.Tests` Release compile-only builds, including both renderer apps: succeeded with 0 warnings and 0 errors.
- `git diff --check`: passed (line-ending conversion notices only).

The repository-wide preflight and solution build were not repeated because both exceeded the local five-minute command bound in wave 170. No UI or visual test fallback was used.
