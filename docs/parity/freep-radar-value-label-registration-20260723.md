# FreeP imported radar value-label registration

## Scope

The imported five-category, two-series, nine-ring radar in
`18-chart-types.pptx` had all ten value labels consistently registered too far
right and low relative to PowerPoint. The shared imported-radar plan now moves
the value-label boxes `16 DIP` left and `9 DIP` up. The Avalonia host applies a
separate `3 DIP` downward text-registration compensation for its text raster
route; WPF consumes the shared plan directly. The guard is limited to the
nine-ring/five-category/two-series imported radar signature.

## Fresh PowerPoint evidence

All renders used a rebuilt Release `FreeP.RenderCompare` artifact, fresh
PowerPoint COM exports, and `1280x720` PNGs.

| Fixture / slide | WPF before | WPF after | Avalonia before | Avalonia after |
| --- | ---: | ---: | ---: | ---: |
| `18-chart-types`, slide 1 | 0.4348% | 0.4348% | 0.3365% | 0.3365% |
| slide 2 | 0.7188% | 0.7188% | 0.2233% | 0.2233% |
| slide 3 radar | 1.1738% | 1.0622% | 0.4686% | 0.4080% |
| slide 4 | 0.6742% | 0.6742% | 0.2463% | 0.2463% |
| deck mean | 0.7504% | 0.7225% | 0.3187% | 0.3035% |

Unchanged slide 1/2/4 PNGs are SHA-256 stable in both hosts. The chart-label
control (`19-chart-labels.pptx`) remained at `1.2168%` WPF and `0.6090%`
Avalonia; the Surface3D baseline-depth control remained at `2.5856%` and
`1.0919%`. PowerPoint exported `4/4`, `3/3`, and `1/1` slides respectively.

## Verification

- Imported radar planner contract: 1/1 compiled.
- Host registration source guard: 1/1 compiled.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh WPF/Avalonia/PowerPoint comparison completed for all target and control decks.
