# FreeP imported Surface3D source-semantics audit

## Fixture authority

The authoritative source is
`tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`, specifically
`ppt/charts/chart2.xml` and its embedded workbook. The chart contains:

- a `surface3DChart` element with `varyColors=1`;
- three category labels (`North`, `East`, `South`);
- three value series (`10, blank, 18`, `18, 22, 26`, and `28, 24, 35`);
- normal category/value axis declarations and workbook references.

The package does **not** contain `c:view3D`, `c:spPr`, `c:floor`,
`c:sideWall`, `c:backWall`, chart style, material, lighting, or an authored
surface mesh. The visible PowerPoint projection is therefore generated from
Office's default Surface3D chart algorithm, not recovered from serialized
vertex data.

## Consequence

FreeP's current imported 3-by-3 projection constants are a renderer-side
default-camera approximation. The recent first-cell diagonal, layered-face,
and painter-order probes all failed both-host whole-page gates; none was kept.
Further parity work must model the default Office surface primitive contract
from matched renders, while preserving the source values/blank-cell semantics
as the only package-authoritative geometry inputs.

This audit is intentionally documentation-only. It does not add a fabricated
mesh to the chart model or claim that a raster calibration is serialized
functionality.
