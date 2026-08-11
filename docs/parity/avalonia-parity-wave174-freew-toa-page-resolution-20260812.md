# Avalonia parity wave 174: shared FreeW Table-of-Authorities page resolution

Date: 2026-08-12

## Outcome

WPF and Avalonia now delegate Table-of-Authorities page-reference policy to `TableOfAuthoritiesPageResolverPlanner` in Presentation. Renderers provide only observed block-start and character-offset physical-page geometry.

Shared code now owns citation-run validation and offset calculation, table spillover pages, computed page-count bounds, explicit-boundary safety, block-page fallback, and section-aware visible page labels. This closes an Avalonia gap where a temporarily unavailable character placement returned no page even when the containing block's page was known; it now follows WPF's block-page fallback.

## Verification policy

No UI tests or visual capture hosts were run on this machine. Verification for this wave is limited to portable Presentation tests and compile-only builds.

Completed checks:

- Focused `TableOfAuthoritiesPageResolverPlannerTests`: 5 passed.
- Full `FreeW.App.Presentation.Tests`: 1,393 passed.
- `FreeW.App.Host.Tests` and `FreeW.App.Avalonia.Tests` Release compile-only builds, including both renderer apps: succeeded with 0 warnings and 0 errors.
- `git diff --check`: passed (line-ending conversion notices only).

The repository-wide preflight and solution build were not repeated because both exceeded the local five-minute command bound in wave 170. No UI or visual test fallback was used.
