# FreeW Avalonia Parity Wave 132

Date: 2026-08-03
Base: `78506b595f` (`Document Wave131 parity integration`)

## Scope And Fresh Finding

Fresh equal-size 560x600 current-source captures reproduced the Wave117
`backstage-export.open` canonical exactly: changed ratio `0.136408`, mean
channel delta `10.852949`, and pHash distance `12`. The WPF and Avalonia panes
have matching 546x563 painted bounds and matching action semantics, leaving no
honest product-owned Export mismatch beyond toolkit text rasterization and
native scrollbar-template differences.

Per the Wave132 fallback, the slice moved to the stronger product-owned
`icon-picker.initial` mismatch. Fresh captures reproduced its canonical
`12.1131%` changed ratio, `15.3291` mean delta, and pHash distance `5`.
Inspection showed that WPF expands each SVG's painted bounds into its 38x38
thumbnail bitmap, while Avalonia retained transparent 32x32 viewBox margins.
Narrow glyphs therefore appeared materially narrower even though both hosts
used the same 61 source SVGs and catalog order.

## Implementation

- Added an opt-in painted-bounds load path to the shared Avalonia SVG parser
  and rasterizer. Existing ribbon and general SVG callers keep viewBox bounds.
- FreeW Avalonia Icon Picker thumbnails now use that painted-bounds drawing with
  `Stretch.Fill`, matching the WPF thumbnail raster contract without changing
  the 54x54 tile hit target, source artwork, selection, or insertion behavior.
- Focused shared coverage proves the default rasterizer retains its transparent
  full-viewBox backing while the painted-bounds path omits it. Dialog headless
  coverage locks the fill mode, absence of the old control scale transform,
  and the first narrow glyph's painted-bounds aspect.

## Fresh Evidence

Ignored run artifacts are under `artifacts/wave132-icon-picker-fresh` and
`artifacts/wave132-icon-picker-after`. All captures passed full and target
pixel-content gates and had no semantic difference.

| Scenario | Before changed | After changed | Before mean | After mean | pHash | Result |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| `icon-picker.initial` | 12.1131% | 9.6783% | 15.3291 | 9.3391 | 5 | improved; residual mismatch |
| `icon-picker.populated` | 1.1307% | 1.1307% | 1.0765 | 1.0765 | 0 | pass; unchanged |
| `icon-picker.validation-error` | 1.2140% | 1.2140% | 1.1933 | 1.1933 | 0 | pass; unchanged |

The tracked canonical comparison and freshness were route-merged only for
`icon-picker.initial`; the cross-app dashboard was not edited.

## Verification And Residuals

- `dotnet test tests/Free.Shared.Ribbon.Tests/Free.Shared.Ribbon.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~SvgIconRasterizerTests --logger "console;verbosity=minimal" -m:1` - 1 passed.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~IconPickerDialogVisualParityTests --logger "console;verbosity=minimal" -m:1` - 2 passed.
- `dotnet test freew/FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj --configuration Release --filter FullyQualifiedName~IconPicker --logger "console;verbosity=minimal" -m:1` - 1 passed.
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --filter FullyQualifiedName~MediaDialogParitySourceTests --logger "console;verbosity=minimal" -m:1` - 13 passed.
- Fresh WPF/Avalonia `icon-picker.initial`, `icon-picker.populated`, and
  `icon-picker.validation-error` captures completed 1/1 per host and state.
- Focused comparisons preserved both non-initial passes and reduced the initial
  changed-pixel count from 40,700 to 32,519 of 336,000.

`icon-picker.initial` remains a genuine visual mismatch. The residual is mainly
SharpVectors/WPF versus Avalonia geometry stroking and antialiasing, plus native
ComboBox, TextBox, focus, and button chrome. No threshold, classification,
semantic evidence, WPF behavior, or source SVG was changed to improve the score.
