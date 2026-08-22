# FreeW Avalonia parity Wave173: semantic route evidence refresh

## Scope

This slice exhausted the remaining FreeW canonical `semantic-mismatch` rows:

- `chart-axis-titles.initial`
- `chart-axis-titles.populated`
- `chart-axis-titles.validation-error`
- `chart-size.initial`
- `chart-size.populated`
- `chart-size.validation-error`
- `chart-title.initial`
- `chart-title.populated`
- `chart-title.validation-error`
- `manual-hyphenation.initial`
- `manual-hyphenation.populated`
- `manual-hyphenation.validation-error`

WPF remains the authority. No semantic comparator, visual threshold, or classification rule was
weakened.

## Diagnosis

Fresh route-local WPF and Avalonia captures were produced for all four routes. Their semantic
payloads matched for every state:

- Chart Axis Titles: category-axis text box focused; `OK`, `Cancel` actions in order.
- Chart Size: width text box focused; `OK`, `Cancel` actions in order.
- Chart Title: title text box focused; `OK`, `Cancel` actions in order.
- Manual Hyphenation: choices combo focused; `Accept hyphenation`, `Skip hyphenation`, `Cancel`
  actions in order, with Accept as default and Cancel as cancel.

The mismatch was stale aggregate evidence. The product dialogs already applied the shared
planner contracts; the old canonical rows predated the current route-local captures and continued
to report the old generic-harness focus/action state.

## Regression coverage

Added `ChartDialogVisualHarnessSemanticParityTests`, which realizes each chart dialog through its
private production constructor and asserts the WPF-authority focus and action contract after the
window is shown. `ManualHyphenationDialogParityTests.Realized_action_semantics_match_the_Wpf_authority`
continues to cover the realized Manual Hyphenation action names, default/cancel flags, and focus.

## Evidence refresh

The four route-local manifests were compared through the existing merger using `--baseline` and
`--refresh-route`, with the existing semantic and visual checks unchanged. Before Wave173 the
canonical totals were:

| Genuine visual mismatch | Pass | Semantic mismatch | Avalonia extension |
| ---: | ---: | ---: | ---: |
| 142 | 67 | 12 | 70 |

After refreshing all four routes, the canonical totals are:

| Genuine visual mismatch | Pass | Semantic mismatch | Avalonia extension |
| ---: | ---: | ---: | ---: |
| 142 | 79 | 0 | 70 |

All twelve listed scenarios are now `pass`. Their visual deltas remain governed by the existing
thresholds; this slice changes the evidence freshness and semantic classification only.

## Verification

- Fresh WPF route captures: 12/12 captured.
- Fresh Avalonia route captures: 12/12 captured and passed content gates.
- Fresh route comparisons: all twelve semantic differences empty.
- Canonical freshness sidecar regenerated with the new inventory and capture manifest hashes.
- Focused test: `ChartDialogVisualHarnessSemanticParityTests`.

The FreeW report still has 142 genuine visual mismatches and 70 Avalonia-only extension rows.
Those are outside this semantic-only slice and remain intentionally visible in the canonical
report.
