# FreeW Word SmartArt Text Units - 2026-07-16

## Finding

The live Word SmartArt drawing parts store nominal node text sizes in points, but
the native gallery drawing applies different visual scaling during layout. In the
same-size COM raster, the three-level hierarchy labels measure about 63x27 pixels
while the corresponding FreeW labels measure 31x14; the pyramid labels measure
about 35x20 in Word versus 47x27 in FreeW.

## Fix

`SmartArtNodeVisualPlan` now carries the renderer-neutral visual size in DIPs.
The native Word org-chart style uses a measured 22 pt visual label and the native
pyramid style uses 14 pt. WPF and Avalonia both consume the shared plan value; the
Avalonia path also stops forcing SmartArt labels bold or truncating them.
Native org-chart labels are single-line so the larger Word-scale text does not wrap
inside the fixed gallery boxes.

Fresh raster evidence:

- Word: `freew-fidelity-corpus/runs/smartart-hierarchy-next-20260716/word-png-production-final/chart-smartart-complex_p1.png` and `_p2.png`
- FreeW: `freew-fidelity-corpus/runs/smartart-hierarchy-next-20260716/freew-smartart-font-final/chart-smartart-complex_p1.png` and `_p2.png`

The final FreeW hierarchy label bounds are 63x26 (`Plan`) and 74x26 (`Build`),
versus Word's 63x27 and 73x27. Pyramid label bounds differ by at most 2 pixels
in width or height.

The native pyramid also carries a calibrated inline envelope in the WPF host
(`Margin = 2,4,0,6` DIPs). This aligns the full pyramid bands with Word at
`x=106..489, y=125..309` and preserves Word's gap before the following paragraph.
The fresh comparison render is in
`freew-fidelity-corpus/runs/smartart-hierarchy-next-20260716/freew-pyramid-margin-final/`.

## Verification

- `ChartSmartArtVisualPlannerTests`: 41/41
- `SmartArtRenderingTests`: 16/16, including native text sizing, no-wrap behavior, and pyramid inline envelope
- `dotnet build freew/FreeW.App.Avalonia/FreeW.App.Avalonia.csproj --configuration Release --no-restore`: passed with 0 warnings and 0 errors
- Fresh `chart-smartart-complex.docx` FreeW render: 2 pages at `816x1056`; hierarchy and pyramid geometry unchanged, with Word-scale labels visible.

The remaining chart gap is structural styling and plot-area fidelity, not a
SmartArt text-unit mismatch.
