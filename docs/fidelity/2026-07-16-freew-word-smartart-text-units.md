# FreeW Word SmartArt Text Units - 2026-07-16

## Finding

The live Word SmartArt drawing parts store node text sizes in points. The
hierarchy probe uses `sz="1100"` (11 pt), while the native four-level pyramid
uses `sz="1848"` (18.48 pt). FreeW's WPF renderer treated both values as raw
device-independent pixels and rendered every node at 11 DIPs, making Word's
SmartArt labels visibly larger than FreeW's.

## Fix

`SmartArtNodeVisualPlan` now carries the Word-derived text size in DIPs. The
default 11 pt size is converted at 96/72, and the native pyramid style applies
its measured 18.48 pt size. WPF and Avalonia both consume the shared plan value;
the Avalonia path also stops forcing SmartArt labels bold or truncating them.

## Verification

- `ChartSmartArtVisualPlannerTests`: 37/37
- `SmartArtRenderingTests`: 16/16
- `dotnet build freew/FreeW.App.Avalonia/FreeW.App.Avalonia.csproj --configuration Release --no-restore`: passed with 0 warnings and 0 errors
- Fresh `chart-smartart-complex.docx` FreeW render: 2 pages at `816x1056`; hierarchy and pyramid geometry unchanged, with Word-scale labels visible.

The remaining chart gap is structural styling and plot-area fidelity, not a
SmartArt text-unit mismatch.
