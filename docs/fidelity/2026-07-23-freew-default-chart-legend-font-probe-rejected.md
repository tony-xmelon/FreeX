# Default Chart Legend Font Probe Rejected

## Scope

The imported `drawing-objects-complex` default column chart already has
Word-matched category swatch positions and a separately accepted floating-frame
registration. Raw masks show that its WPF `Q1` through `Q4` legend glyphs are
narrower and lower than Word's raster, while the plot, title, and adjacent
SmartArt each have independent owners.

## Probe

For that exact WPF chart-scene signature only, the legend labels were moved one
DIP right and two DIPs up and increased from 9 to 12 DIPs. The shared planner
and Avalonia renderer were unchanged. Focused WPF chart/floating-object tests
passed 35/35 and the Release `FreeW.FidelityRender` consumer was rebuilt.

## Result

Against the matching 816 x 1056 Word PNG, the legend ROI `(440,470)-(620,505)`
regressed from `4.9173%` to `5.8503%`; whole page regressed from `6.4490%` to
`6.4559%`. Plot, title, and SmartArt ROIs were byte-stable. The change was
reverted.

## Rule

Raw glyph bounds can establish a legend text owner, but a font-size/offset
substitution does not reproduce Word's chart text raster. Keep the accepted
swatch and frame geometry, and require a target-ROI plus whole-page gain before
accepting a renderer-local text calibration.
