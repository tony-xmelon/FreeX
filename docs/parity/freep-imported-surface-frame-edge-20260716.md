# FreeP imported Surface3D frame edge - 2026-07-16

## Scope

The imported `Surface3D` chart in `22-chart-baseline-depth.pptx` uses a
projected front frame edge that is distinct from the flat chart plot gutter.
FreeP's shared frame started too far left, leaving the visible depth edge
consistently left of the PowerPoint reference.

## Change

The shared `ChartRenderPlanner` now uses measured imported-frame endpoints for
the front projected edge while preserving the authored Surface3D frame path.
The surface mesh, facet colors, wireframe, and contour policy are unchanged.

## COM evidence

At `1280x720`, sampled front-edge positions moved from approximately
`15/12/8/4` pixels left of PowerPoint at rows `260/270/280/290` to within
`0/0/1/2` pixels. Fresh WPF mean channel diff improved from `3.3449%` to
`3.3075%` for deck 22.

## Verification

- `ChartBaselineCorpusTests` asserts the imported frame endpoints.
- Fresh PowerPoint COM export completed successfully.
- The shared planner remains consumed by both WPF and Avalonia renderers.
