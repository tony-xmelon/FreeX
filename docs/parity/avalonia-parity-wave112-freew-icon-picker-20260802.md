# Avalonia Parity Wave112: FreeW Icon Picker

Date: 2026-08-02

## Delivered

- Avalonia icon-picker thumbnails now apply the WPF authority's explicit 32px SVG viewport to 38px thumbnail scale while preserving the shared SVG catalog, 54px tile hit target, selection highlight, search focus, keyboard Escape behavior, and validation dialog.
- The focused visual test now locks the initial fixture to all 61 bundled icons, verifies the shared drawing source and viewport scale, and retains selection/no-match validation coverage.
- No classification was weakened or hidden. The initial state remains explicitly `genuine-visual-mismatch` while populated and validation remain passes.

## Fresh Evidence

- WPF: 3/3 icon-picker states captured; Avalonia: 3/3 captured. Full manifests are under `artifacts/wave112-icon-picker-final-wpf/` and `artifacts/wave112-icon-picker-final2-avalonia/`.
- `icon-picker.initial`: `12.1012%` changed pixels, `15.3551` mean channel delta, pHash distance `5`, genuine visual mismatch. This improves the prior `13.5420% / 19.6837` baseline without changing semantics.
- `icon-picker.populated`: `1.1188% / 1.1026`, pass, no semantic difference.
- `icon-picker.validation-error`: `1.2021% / 1.2194`, pass, no semantic difference.

The remaining initial mismatch is the visible Avalonia SVG parser/rasterizer stroke and antialiasing difference across the full 61-icon catalog. It is retained as a genuine mismatch rather than being masked by fixture changes or classification thresholds.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~IconPickerDialogVisualParityTests`
- Result: 2 passed, 0 failed.
- Fresh WPF and Avalonia harness captures passed full/target pixel-content gates for all three icon-picker states; paired comparison produced no semantic differences.
