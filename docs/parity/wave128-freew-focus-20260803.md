# FreeW Wave128 Focus Parity

Wave128 closes the remaining canonical focus-semantic cluster in the FreeW dialog harness: 13 rows across compare-documents (4), properties (3), table-formula (3), and zoom (3).

## Shared Contract

`freew/FreeW.App.Presentation/Dialogs/FreeWDialogFocusPlanner.cs` now owns the route focus contract consumed by both hosts:

| Route | Initial and validation focus | Keyboard behavior |
| --- | --- | --- |
| compare-documents | `CompareDocumentsAuthorBox` | Focus and select all; OK is default; Cancel is Esc/cancel |
| properties | `DocumentPropertiesTitle` | Focus and select all; OK is default; Cancel is Esc/cancel |
| table-formula | `TableFormulaFormulaBox` | Focus and select all; validation returns focus there; OK is default; Cancel is Esc/cancel |
| zoom | `ZoomCustomPercentBox` | Focus and select all; validation returns focus there; OK is default; Cancel is Esc/cancel |

WPF now applies the route focus after `Loaded`, so the non-modal capture harness observes the same authority focus that a shown dialog receives. Avalonia consumes the same target IDs and selection policy through its native focus APIs. Existing WPF/Avalonia action-row factories continue to own the platform-specific default and cancel wiring.

## Evidence

Fresh resources use the exact Wave128 roots:

- `artifacts/wave128-freew-focus-20260803-wpf`: 190/190 WPF captures.
- `artifacts/wave128-freew-focus-20260803-avalonia`: 288/288 Avalonia captures.
- `artifacts/wave128-freew-focus-20260803-comparison`: 478 inventory scenarios and 295 comparison rows.

All 13 targeted rows now have `semanticDifference: null`. Their visual classifications remain honest: all 13 remain `genuine-visual-mismatch` because the measured raster deltas still exceed the visual classifier threshold.

| Route | Rows | Changed-ratio range | Mean channel-delta range |
| --- | ---: | ---: | ---: |
| compare-documents | 4 | 4.61% to 6.98% | 3.80 to 6.97 |
| properties | 3 | 6.65% to 6.78% | 4.42 to 4.60 |
| table-formula | 3 | 4.46% to 5.76% | 3.30 to 3.98 |
| zoom | 3 | 4.27% to 4.31% | 3.31 to 3.37 |

Canonical inventory coverage remains 478 scenarios; the comparison contains 295 rows: 155 genuine visual mismatches, 28 passes, 105 Avalonia extensions, and 7 state-not-applicable rows. The remaining 155 mismatches are visual evidence requiring separate renderer review; Wave128 does not claim pixel parity.

## Verification

- `FreeWDialogFocusPlannerTests`: 1/1 passed.
- `FreeWDialogFocusParityTests`: 1/1 passed.
- `SharedPresentationBoundarySourceGuardTests`: 5/5 passed.
- Inventory generation and `--check`: passed, 163 routes and 478 scenarios.
- Cross-app dashboard generation and `Test-CrossAppParityDashboard.ps1`: passed.
- Route-specific comparison freshness checks for all four routes: passed.

The generated inventory, comparison JSON/Markdown/HTML/freshness evidence, and cross-app dashboard were regenerated from the fresh captures. The local WPF/Avalonia probe directories used during investigation were removed; the three exact Wave128 evidence roots above were retained for review.
