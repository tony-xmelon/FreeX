# FreeW Avalonia Options Dialog Parity - Wave 154

Date: 2026-08-04

## Scope

This slice aligns `freew/FreeW.App.Avalonia/OptionsDialog.cs` with the WPF authority in
`freew/FreeW.App.Host/OptionsDialog.cs` for the six applicable states: initial, populated,
validation-error, General, AutoCorrect, and AutoFormat As You Type. WPF's apparent `Replace`
and `With` states are inventory metadata artifacts: the authority exposes those as the two
columns of the AutoCorrect replacement table, not as tabs. No alternate workflow was added.

## Production changes

- Restored the General value column as one left-aligned WPF-equivalent column for the recent-files,
  format, and language controls, including after shared Avalonia chrome normalization.
- Matched the WPF replacement-table vertical geometry at 96 DPI: 7px top spacing and a 26px header
  row, with black WPF-equivalent cell separators and the existing 1:2 Replace/With layout.
- Kept secondary-tab focus on the tab strip and matched the WPF neutral gray default action border
  without changing OK/Cancel, default-button, or cancel-button semantics.

## Paired evidence

Fresh WPF authority and Avalonia captures were taken with the temporary six-pair inventory at
`560x600`, `96 DPI`. The aggregate tracked comparison bundle was not regenerated.

| State | Before changed ratio | After changed ratio | Before mean channel delta | After mean channel delta |
| --- | ---: | ---: | ---: | ---: |
| `options.initial` | 6.3542% | 5.5327% | 4.377 | 4.114 |
| `options.populated` | 6.3827% | 5.5595% | 4.414 | 4.147 |
| `options.validation-error` | 6.4756% | 5.6470% | 4.547 | 4.266 |
| `options.tab-general` | 6.3542% | 5.5327% | 4.377 | 4.114 |
| `options.tab-auto-correct` | 10.3411% | 8.0116% | 8.567 | 5.646 |
| `options.tab-auto-format-as-you-type` | 6.7074% | 6.7068% | 6.616 | 6.559 |

Average changed ratio improved from **7.102530%** to **6.165079%**. Average mean channel
delta improved from **5.4830** to **4.8078**. All 12 captures passed the harness content gate;
the remaining rows are still classified as genuine visual mismatches because native WPF and
Avalonia control templates and text rasterization are not identical.

## Verification

- Avalonia focused tests: `OptionsDialogVisualParityTests`, **10 passed, 0 failed**.
- Release Avalonia dialog harness build with disabled build servers and single-node settings:
  **0 warnings, 0 errors**.
- WPF authority Release dialog harness build with disabled build servers and single-node settings:
  **0 warnings, 0 errors**.
- WPF capture: **6/6** captured; Avalonia capture: **6/6** captured.
- Comparison generated valid per-state metrics and intentionally returned the nonzero
  genuine-mismatch classification status.
