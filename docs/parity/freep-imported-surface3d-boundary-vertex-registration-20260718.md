# FreeP imported Surface3D boundary vertex registration

Date: 2026-07-18

## Fixture

`tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`, slide 1,
matched 1280x720 PowerPoint COM and FreeP WPF/Avalonia renders.

## Change

The imported near-left dark-orange boundary face uses one shared lower-left
vertex in two projected triangles. Its normalized registration moved from
`(5,122)` to `(1,125)`, matching the observed PowerPoint mask edge while
leaving surface-point projection, triangulation, colors, camera scaling, right
boundary geometry, and painter order unchanged.

## ROI evidence

The candidate and accepted baseline used the same PowerPoint PNG
(SHA-256 `162D9EB507140C2E9A593E84B1E0DD0C856208CB7968E8717284DC55671170E4`).

| Metric | WPF before | WPF after | Avalonia before | Avalonia after |
|---|---:|---:|---:|---:|
| Whole page | 2.6388% | 2.6334% | 2.3451% | 2.3397% |
| Boundary `(590,170)-(920,270)` | 7.2556% | 7.1055% | 7.2155% | 7.0636% |
| Surface `(560,90)-(1030,310)` | 5.3761% | 5.3282% | 5.3243% | 5.2758% |
| Tight mesh `(590,105)-(980,300)` | 6.6289% | 6.5638% | 6.6215% | 6.5555% |

The exact `#D5702C` mask left edge moved from WPF `x=605` to `x=601`, matching
PowerPoint's `x=601`. Stock, scatter, and 100%-stacked control regions were
pixel-identical in both renderers.

## Verification

- Focused compiling `ChartBaselineCorpusTests|ChartRenderPlannerTests`: 197/197.
- RenderCompare Release build: 0 warnings, 0 errors.
- Fresh WPF and Avalonia renders completed with healthy pixel diversity.
- No PowerPoint repair prompt; COM baseline provenance matched the candidate.
