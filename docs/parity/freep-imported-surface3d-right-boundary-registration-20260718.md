# FreeP imported Surface3D right boundary registration

Date: 2026-07-18

## Fixture

`tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`, slide 1,
matched 1280x720 PowerPoint COM and FreeP WPF/Avalonia renders.

## Change

After the accepted near-left boundary correction, the imported right-side
dark-orange boundary face still registered two pixels too far right and three
pixels too high at its extremes. Its three normalized vertices moved from
`(247,101),(320,119),(312,134)` to `(245,99),(319,119),(312,137)`.
No surface point, triangulation, color, camera, left-boundary, or painter-order
logic changed.

## ROI evidence

The candidate and accepted baseline used the same PowerPoint PNG
(SHA-256 `162D9EB507140C2E9A593E84B1E0DD0C856208CB7968E8717284DC55671170E4`).
The comparison is relative to the accepted left-boundary slice.

| Metric | WPF before | WPF after | Avalonia before | Avalonia after |
|---|---:|---:|---:|---:|
| Whole page | 2.6334% | 2.6302% | 2.3397% | 2.3364% |
| Boundary `(590,170)-(920,270)` | 7.1055% | 7.0137% | 7.0636% | 6.9724% |
| Surface `(560,90)-(1030,310)` | 5.3282% | 5.2989% | 5.2758% | 5.2467% |
| Tight mesh `(590,105)-(980,300)` | 6.5638% | 6.5240% | 6.5555% | 6.5160% |

The exact `#D5702C` mask bbox is now `(601,176)-(913,240)` in both candidate
renderers, matching PowerPoint. Stock, scatter, and 100%-stacked control
regions remained pixel-identical.

## Verification

- Focused compiling `ChartBaselineCorpusTests|ChartRenderPlannerTests`: 197/197.
- RenderCompare Release build: 0 warnings, 0 errors.
- Fresh WPF and Avalonia renders completed with healthy pixel diversity.
- No PowerPoint repair prompt; COM baseline provenance matched the candidate.
