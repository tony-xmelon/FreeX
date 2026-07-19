# FreeP surface display-blanks zero semantics

Date: 2026-07-19
Branch: `codex/freep-parity-surface3d-shading-next-20260716`

## Change

Surface and Surface3D planning now consumes authored `c:dispBlanksAs="zero"`
through the shared blank-value policy. A missing value is materialized as a
zero-height cell at its existing category/series slot. The default/omitted
`gap` behavior still omits the cell, and the imported baseline Surface3D path
with its omitted blank policy remains unchanged.

This is a model-to-planner function fix. It does not fabricate a mesh or alter
the renderer's generated default Surface3D projection.

## Verification

- `ChartBaselineCorpusTests|ChartRenderPlannerTests`: compile-first **201/201**
- Same focused tests with `--no-build`: **201/201**
- `FreeP.RenderCompare` Release build: **0 warnings, 0 errors**
- Current WPF render of `22-chart-baseline-depth.pptx` remained SHA-256
  identical to the prior accepted WPF artifact:
  `C7D54417B772E030521BB9DB112F57879388EB1281B9EED6DC3A30D140D23607`

The bounded PowerPoint COM export did not complete while the desktop
PowerPoint instance was occupied, so no fresh visual Surface3D score is
claimed for this semantic slice. The existing generated-default Surface3D
mesh remains the next visual parity item.
