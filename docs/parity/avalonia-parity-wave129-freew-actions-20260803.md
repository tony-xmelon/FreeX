# FreeW Wave129 Action Semantics

Date: 2026-08-03

## Scope

This slice closes the four canonical `action-button-order` semantic residuals:
`backstage-info.open`, `insert-chart.initial`, `insert-chart.populated`, and
`insert-chart.validation-error`.

## Contract

The WPF authority exposes the following current-source contract:

- Backstage Info action order is Edit document properties, Mark as Final,
  Restrict Editing, Inspect Document, and Check Accessibility. Its actions are
  modeless links with no default or cancel role.
- Insert Chart action order is OK then Cancel. OK is the default action; Cancel
  is the cancel and Escape action. WPF focuses and selects the chart title field
  on construction. WPF keeps localized button text and Alt+O / Alt+C access-key
  metadata through `DialogButtonRowFactory`.

`InsertChartDialogPlanner.ActionButtons` now owns the Insert Chart labels,
ordering, and roles. WPF consumes those labels through the existing localized
and access-key-aware shell factory; Avalonia consumes the same plan for its
native default/cancel buttons and shell-localized labels. Backstage continues
to consume the shared `BackstageInfoSafetyPanePlanner` action plan in both
hosts.

## Fresh Evidence

Fresh current-source capture roots:

- `artifacts/wave129-freew-actions-20260803-wpf`: 190/190 WPF captures.
- `artifacts/wave129-freew-actions-20260803-avalonia`: 288/288 Avalonia captures.
- `artifacts/wave129-freew-actions-20260803-comparison`: full comparison output.

The canonical inventory, comparison, and dashboard were regenerated from
these captures. The four target rows are all `captured/captured`, all have
`semanticDifference: null`, and all retain `genuine-visual-mismatch`:

| Scenario | Changed pixels | Changed ratio | Mean channel delta |
| --- | ---: | ---: | ---: |
| `backstage-info.open` | 23,430 / 336,000 | 6.9732% | 4.3795 |
| `insert-chart.initial` | 20,861 / 336,000 | 6.2086% | 4.5796 |
| `insert-chart.populated` | 20,861 / 336,000 | 6.2086% | 4.5796 |
| `insert-chart.validation-error` | 20,792 / 336,000 | 6.1881% | 4.5451 |

No visual mismatch was relabeled as semantic parity. The remaining visual
deltas are WPF versus Avalonia control-template and text-rasterization
differences.

## Verification

- `ChartMediaDialogPlannerTests` and `DialogActionButtonPlanTests`: 8/8.
- `SharedPresentationBoundarySourceGuardTests` and
  `DialogButtonRowFactoryLocalizationTests`: 7/7.
- Fresh WPF/Avalonia harness builds: zero warnings, zero errors.
- Fresh WPF/Avalonia captures: all content gates passed.
- Inventory generation: 163 routes, 478 scenarios.
- Canonical comparison: 190 WPF captures, 288 Avalonia captures; 158 genuine
  visual mismatches, 25 passes, 105 Avalonia extensions, and 7
  state-not-applicable rows.

## Residuals

The four semantic residuals are closed. The four target rows remain visual
mismatches by measured raster evidence; this slice does not claim pixel parity.
