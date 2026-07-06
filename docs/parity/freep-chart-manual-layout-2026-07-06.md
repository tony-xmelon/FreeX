# FreeP Chart Manual Layout Evidence - 2026-07-06

## Scope

This slice adds bounded PowerPoint chart manual-layout parity for FreeP:

- Model metadata for OOXML `c:layout/c:manualLayout` on chart plot areas and legends.
- Model metadata for `c:legend/c:overlay`.
- PPTX read/write retention for factor-mode `x`, `y`, `w`, and `h` values.
- Shared `ChartRenderPlanner` behavior so WPF and Avalonia consume the same plot and legend geometry.

Unsupported manual-layout coordinate modes are retained as metadata when known (`edge`) or ignored for rendering when they are not the complete factor rectangle that this v1 planner supports.

## Implementation

- `ChartShape` now carries `PlotAreaManualLayout`, `LegendManualLayout`, and nullable `LegendOverlay`.
- `PptxChartReader` reads `c:plotArea/c:layout/c:manualLayout`, `c:legend/c:layout/c:manualLayout`, and `c:legend/c:overlay`.
- `PptxChartWriter` writes the modeled manual-layout and legend overlay elements back into chart XML.
- `ChartRenderPlanner.BuildFramePlan` applies complete factor-mode plot layouts as bounded rectangles.
- `ChartRenderPlanner.BuildFramePlan` does not reserve plot space when `LegendOverlay == true`.
- `ChartRenderPlanner.BuildLegendItemPlans` uses manual legend bounds when present.

## Evidence

Focused shared planner coverage:

- Manual plot layout changes the plot rectangle deterministically.
- Legend overlay keeps the plot area unreserved.
- Manual legend bounds control legend item placement.

No-COM package coverage:

- A synthetic PowerPoint-shaped chart XML fixture reads plot manual layout, legend manual layout, and legend overlay into the model.
- Save/reopen preserves the metadata.
- Saved chart XML contains the expected `c:manualLayout` and `c:overlay` elements.

Validation commands for this slice are the focused `ChartRenderPlannerTests` lane, the focused package/chart lane, generated dashboard check when docs are touched, `git diff --check`, and `dotnet build-server shutdown`.
