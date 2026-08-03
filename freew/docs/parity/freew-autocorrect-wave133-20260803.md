# FreeW AutoCorrect Tab Parity - Wave133

Date: 2026-08-03

## Follow-up scope

Integration review reopened this slice because the first Avalonia revision encoded the WPF capture's two 20px realized columns and a filler surface. Fresh paired captures show that this clips real replacement values. The WPF source remains the authority: `OptionsDialog.cs` declares `Replace` as `1*` and `With` as `2*`.

## Fresh evidence

| Metric | Original baseline | Rejected 20px revision | Follow-up 1:2 star revision |
| --- | ---: | ---: | ---: |
| Changed ratio | 0.1189 | 0.1029 | 0.1047 |
| Mean channel delta | 10.062 | 8.577 | 8.692 |
| P95 channel delta | 80.667 | 69.000 | 70.000 |
| Perceptual hash distance | 1 | 8 | 9 |
| Semantic difference | none | none | none |
| Painted content bounds | WPF 517 x 387; Avalonia 516 x 383 | WPF 517 x 387; Avalonia 518 x 387 | WPF 517 x 387; Avalonia 518 x 387 |

The follow-up comparison remains classified as `genuine-visual-mismatch`; thresholds and classifications were not changed. The follow-up Avalonia capture intentionally follows the authoritative declared layout contract even though the raw WPF bitmap's clipped columns make the perceptual hash less favorable.

## Why WPF realized 20px

The temporary probe ran after `UpdateLayout` on a fresh WPF capture. It reported `DataGrid.ActualWidth=478.6667`, `DesiredSize.Width=60`, `HorizontalScrollBarVisibility=Auto`, and both columns as `UnitType=Star` with declared values `1` and `2`. Their `ActualWidth` was nevertheless `20`, exactly their `MinWidth`. The rendered WPF bitmap clips `(tm)`, `-->`, and other replacement values to those cells. This is a measure/scroll-layout artifact, not a valid non-clipping realization of the declared 1:2 behavior, so it is not copied into Avalonia.

## Product-owned changes

- Restored the replacement grid to exactly two star columns with `1*` and `2*` widths.
- Removed the 20px hard-coded columns, filler column, and width override that encoded the clipping artifact.
- Retained the established Avalonia tab-pane compensation, 16px checkbox geometry, 20px row cadence, table spacing, and gridline palette.
- Preserved the shared planner, replacement parsing, dynamic add-row behavior, validation, focus/select lifecycle, OK/Cancel semantics, and persisted option result construction.
- Added focused assertions for the declared 1:2 ratio; rendered screenshots verify the replacement text is visible.

## Validation and retained screenshots

- `dotnet test freew\\FreeW.App.Avalonia.Tests\\FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~OptionsDialogVisualParityTests -m:1 -p:NodeReuse=false /nr:false` passed: 6, failed: 0.
- `dotnet test freew\\FreeW.App.Host.Tests\\FreeW.App.Host.Tests.csproj --configuration Release --filter FullyQualifiedName~OptionsDialogParityTests -m:1 -p:NodeReuse=false /nr:false` passed: 3, failed: 0.
- Release WPF and Avalonia dialog harness builds passed with `-m:1 -p:NodeReuse=false /nr:false`.
- Fresh WPF and Avalonia captures passed pixel-content validation; semantic diff was null.
- Fresh review evidence is retained under `freew/artifacts/wave133-autocorrect-review/`, including `before-wpf`, `before-avalonia`, `wpf-probe`, `after-wpf`, `after-avalonia`, and `after-compare`.

The full 478-row comparison command generated the target row and returned 1 because only this focused pair was captured; the target row itself is `captured/captured` and valid.

## Residuals

The raw WPF authority bitmap still contains the native WPF clipping artifact, so the follow-up pHash is 9 rather than the rejected revision's 8. Avalonia now keeps actual replacement text visible and preserves the source-declared 1:2 behavior; no semantic difference remains.
