# FreeP Cross Pattern Tile Parity - 2026-07-16

## Scope

Align the `cross` preset in `12-fills.pptx` with the PowerPoint raster baseline.
PowerPoint repeats the cross hatch every 8 pixels at the 1280x720 comparison
size. FreeP was using a 12-pixel tile in both renderers, producing visibly
sparser cyan and blue grid lines.

## Change

The WPF and Avalonia `cross` pattern brushes now use an 8-pixel tile with a
1-pixel stroke. Other pattern presets retain their existing tile geometry.

## Evidence

`tools/FreeP.RenderCompare/corpus/12-fills.pptx`, slide 1, compared with the
checked-in PowerPoint export at 1280x720:

| Backend | Before | After |
| --- | ---: | ---: |
| WPF | `1.6362%` | `1.2487%` |
| Avalonia | not remeasured | `1.0807%` |

## Verification

- `dotnet build tools\\FreeP.RenderCompare\\FreeP.RenderCompare.csproj --configuration Release --no-restore` - passed, 0 warnings, 0 errors.
- WPF and Avalonia renders completed successfully at 1280x720.
- PowerPoint reference comparison completed with the metrics above.
