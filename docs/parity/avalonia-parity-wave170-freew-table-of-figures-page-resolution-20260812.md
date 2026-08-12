# Avalonia parity wave 170: shared FreeW Table-of-Figures page resolution

Date: 2026-08-12

## Outcome

WPF and Avalonia now delegate Table-of-Figures/Table-of-Tables page-label policy to the same Presentation planner. The shared code owns table pagination spillover, fallback physical-page selection, and section-aware visible page-number formatting. Each renderer supplies only its observed block-to-page mapping; Avalonia additionally supplies its current known page count.

This removes a high-similarity policy block from both large `DocumentView` renderers and prevents the two hosts from drifting on captions inside tables that cross physical pages.

## Verification policy

No UI tests or visual capture hosts were run on this machine. Verification for this wave is limited to portable Presentation tests and compile-only builds.

Completed checks:

- Focused `TableOfFiguresPageTextResolverPlannerTests`: 3 passed.
- Full `FreeW.App.Presentation.Tests`: 1,375 passed.
- `FreeW.App.Host` Release build: succeeded with 0 warnings and 0 errors.
- `FreeW.App.Avalonia` Release build: succeeded with 0 warnings and 0 errors.
- `git diff --check`: passed (line-ending conversion notices only).

The repository preflight and repository-wide Release build were each attempted in isolation, but the local command runner terminated them at the five-minute bound without returning results. Neither left a build or test process behind. The directly affected projects and portable suite completed successfully as listed above.
