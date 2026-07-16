# FreeW / Word chart text-unit parity

Date: 2026-07-16

## Scope

This pass compares the shared `chart-smartart-complex` fixture at the same 816x1056
page raster size in Word COM and FreeW WPF. It follows the earlier marker-only scatter
fix and covers the chart title, axis labels, data labels, legend, and axis-title placement.

## Finding and fix

`ChartSceneText` sizes are now an explicit point-unit contract. The shared planner uses
an 18-point chart title and the existing point sizes for axis/data/legend labels. WPF
converts those values to DIPs before assigning `TextBlock.FontSize`; Avalonia already
consumes the values as points. This preserves the Word-sized title while correcting the
smaller labels that had been rendered as raw DIPs.

The vertical value-axis title is also placed at scene X=32, matching Word's reserved
value-axis band. The previous X=12 position visibly put `USD` / `Weight` too far left.

## Evidence

- Word PNG: `freew-fidelity-corpus/runs/smartart-hierarchy-next-20260716/word-png-production-final/chart-smartart-complex_p1.png`
- FreeW PNG: `freew-fidelity-corpus/runs/smartart-hierarchy-next-20260716/freew-chart-text-final/chart-smartart-complex_p1.png`
- FreeW render command: `dotnet run --project freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore -- <fixture.docx> <outputDir> 3 --composite`

## Verification

- `ChartRenderingTests`: 19/19 passed.
- `ChartScene_WordAxisTitleLayoutReservesCompactPlotBand`: passed.
- Fresh FreeW WPF render: 2 pages at 816x1056.
