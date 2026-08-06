# FreeP ChartEx area formatting parity

## Scope

This slice closes a functional ChartEx edit boundary for chart-area and plot-area
fill/outline ownership. It does not claim a raster-fidelity improvement.

## PowerPoint evidence

PowerPoint COM created and saved a native ChartEx waterfall chart with independent
area fills. The saved `ppt/charts/chartEx1.xml` contained:

- `cx:chartSpace/cx:spPr/a:solidFill/a:srgbClr[@val='FFF2E6']` for the chart area.
- `cx:chart/cx:plotArea/cx:plotAreaRegion/cx:plotSurface/cx:spPr/a:solidFill/a:srgbClr[@val='CCF2FF']` for the plot surface.

The probe package was temporary and removed after inspection. No COM process or
generated package remains. The exact XML owner paths are the source authority;
generic `cx:spPr` descendants are not treated as interchangeable.

## Implementation

ChartEx import now materializes both fills and outlines into the existing
`ChartShape.ChartArea*` and `PlotArea*` model properties. `SetChartAreaOptionsCommand`
marks only the requested ChartEx owner as edited, and undo restores those markers.
ChartEx save-back updates only that owner, preserving unrelated native children and
leaving untouched native formatting byte-for-byte at the XML-owner level.

## Verification

- `dotnet build freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release`: 0 warnings, 0 errors.
- Focused Chart Area/ChartEx tests: 98/98.
- The test covers native ChartEx read, owner-specific write, and preservation of the plot-surface path.
