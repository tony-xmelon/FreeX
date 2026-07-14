# FreeP chart baseline depth corpus - 2026-07-14

## Scope

This slice strengthens FreeP chart visual baseline depth without requiring local
PowerPoint COM. It adds a deterministic FreeP-authored render-compare corpus
deck, `22-chart-baseline-depth.pptx`, covering four shared chart-planner
decisions that benefit both WPF and Avalonia:

- stock high-low stems with rising, falling, and unchanged open/close ticks
- 3-D surface fallback grid rendering with a blank cell that must not reflow
- smooth scatter paths with an explicit straight-series override
- 100% stacked column normalization and centered value/percent labels

## Evidence

- `tools/FreeP.GenerateFixtures` now generates the chart baseline deck through
  `PptxPackageWriter`, so the fixture is repeatable and does not launch
  PowerPoint.
- The committed corpus deck lives at
  `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`.
- `ChartBaselineCorpusTests` loads the committed deck, verifies the expected
  chart families, and exercises the same `ChartRenderPlanner` paths consumed by
  WPF and Avalonia slide canvases.
- Existing FreeP chart corpus tests now include the new deck for workbook-formula
  and chart `varyColors` import coverage.

## Limits

This is no-COM corpus and shared render-planner evidence. It does not claim a
PowerPoint-authoritative PNG visual baseline for the new chart deck. Local
PowerPoint baseline export remains unavailable unless `PowerPoint.Application`
COM is registered on the validation host.
