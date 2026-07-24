# Watermark Backing TextBox Bottom Edge

## Scope

The manually saved Word PDF for `wordart-watermark-stress.docx` is the reference for the exact
imported pale-green backing TextBox: 170 x 58 pt, `#E2F0D9` fill, `#70AD47` outline, square wrap,
margin/paragraph anchoring, and text `watermark backing layer`.

## Change

The existing WPF-only source guard already widened and heightened the visual by three DIPs to
match Word's visible material footprint. Its raw fill mask still ended one row early. The guarded
height adjustment is now four DIPs; the width, placement, text, shadow/effect behavior, and all
other drawing signatures remain unchanged.

## Evidence

The target is the user-saved Word PDF raster at 816x1056. Fresh Release `FreeW.FidelityRender`
WPF composite output was compared against that unchanged target.

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 6.6312% | 6.6272% | -0.0040 pp |
| Backing TextBox `(160,260)-(420,370)` | 9.0641% | 8.9434% | -0.1208 pp |
| Backing body `(170,270)-(410,360)` | 6.9893% | 6.8293% | -0.1599 pp |
| Primary Wave1 panel | 13.9661% | 13.9661% | byte-stable |
| Review Copy | 4.3754% | 4.3754% | byte-stable |

The exact `#E2F0D9` fill mask now reaches Word's bottom row `y=351`; only the TextBox lower
edge changed (`x=176..405`, `y=346..353`).

## Guard

The calibration is limited to the serialized imported TextBox signature. A `SnapsToDevicePixels`
probe changed 2,016 pixels but worsened the target ROI by 0.1737 pp and was rejected. The remaining
outline/shadow raster difference is not a generic WPF pixel-snapping problem.
