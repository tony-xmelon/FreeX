# FreeW AutoCorrect Tab Parity - Wave133

Date: 2026-08-03

## Scope

Fresh paired WPF/Avalonia captures reproduced `options.tab-auto-correct` as a genuine product-owned mismatch. The WPF authority capture was 560 x 600 at 144 DPI and had no semantic difference from Avalonia.

## Reproduction and result

| Metric | Before | After |
| --- | ---: | ---: |
| Changed ratio | 0.1189 | 0.1029 |
| Mean channel delta | 10.062 | 8.577 |
| P95 channel delta | 80.667 | 69.000 |
| Perceptual hash distance | 1 | 8 |
| Semantic difference | none | none |
| Painted content bounds | WPF 517 x 387; Avalonia 516 x 383 | WPF 517 x 387; Avalonia 518 x 387 |

The post-change comparison remains classified as `genuine-visual-mismatch`; thresholds and classifications were not changed.

## Product-owned changes

- Applied the established Avalonia tab-pane template compensation used by sibling tabbed dialogs.
- Matched WPF AutoCorrect checkbox geometry at 16 px with 20 px row cadence.
- Matched the WPF DataGrid's realized 20 px columns, retained a responsive filler surface, and aligned replacement rows, table spacing, and gridline palette.
- Preserved the shared planner, replacement parsing, dynamic add-row behavior, validation, focus/select lifecycle, OK/Cancel semantics, and persisted option result construction.
- Added focused assertions for the replacement grid geometry.

## Validation

- `dotnet test freew\\FreeW.App.Avalonia.Tests\\FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~OptionsDialogVisualParityTests -m:1 -p:NodeReuse=false /nr:false`
  - Passed: 6, failed: 0.
- Release WPF and Avalonia dialog harness builds passed with `-m:1 -p:NodeReuse=false /nr:false`.
- Fresh WPF and Avalonia captures passed pixel-content validation; semantic diff was null.

The repro captures and comparison output were disposable ignored artifacts under `freew/artifacts/wave133-autocorrect-repro`; no stale evidence was committed.

## Residuals

Perceptual hash distance increased from 1 to 8 despite materially lower pixel and channel deltas. The remaining difference is limited to native/template rasterization and the WPF DataGrid's unusual realized-column behavior; no honest product-owned semantic or layout fix was identified beyond this slice.
