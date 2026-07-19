# FreeP imported Surface3D generic vary-colors

Date: 2026-07-19
Branch: `codex/freep-parity-surface3d-shading-next-20260716`

## Change

The measured canonical 3×3 `Surface3D` palette remains scoped to the imported
baseline signature (`varyColors`, imported text metrics, three categories, and
three series). Other imported Surface3D dimensions now use the shared
PowerPoint-style elevation bands and imported lighting instead of receiving the
canonical chart's blue fallback for every facet.

This is a source/data-dimension rule, not a fixture-local coordinate patch. It
leaves authored Surface3D and the accepted 3×3 COM path unchanged.

## Verification

- `ChartBaselineCorpusTests|ChartRenderPlannerTests`: compile-first **203/203**
- Same focused tests with `--no-build`: **203/203**
- The 1280×720 WPF render of `22-chart-baseline-depth.pptx` stayed byte-stable
  against the prior accepted artifact; no fresh PowerPoint export was claimed
  while the existing automation instance remained occupied.
