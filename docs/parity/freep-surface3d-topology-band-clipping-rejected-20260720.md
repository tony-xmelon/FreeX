# FreeP Surface3D topology band-clipping probe rejected

Date: 2026-07-20
Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`
Reference: `tools/FreeP.RenderCompare/corpus/pptx-ref/22-chart-baseline-depth/slide-01.png`

## Authority

The checked-in 1280x720 PowerPoint COM reference has SHA-256
`162D9EB507140C2E9A593E84B1E0DD0C856208CB7968E8717284DC55671170E4`.
PowerPoint COM is unavailable on this host, so the hash-verified reference was
used without replacement or threshold changes.

## Probe

The shared `ChartRenderPlanner` temporarily clipped each projected imported
`Surface3D` triangle at the existing blue, orange, green, and yellow elevation
thresholds. Edge positions and values were linearly interpolated in projected
space, and each resulting polygon retained the parent triangle's shared
lighting and painter ownership. The probe was renderer-neutral, scaled from
the source mesh, and excluded authored and non-varying surface charts.

The hypothesis was that PowerPoint's visible color boundaries represented
continuous elevation bands crossing the projected triangles. Visual evidence
instead showed incorrect narrow color islands around the center fold. The
planner produced 21 render facets instead of the accepted 15 and worsened
both host comparisons, so the implementation was removed.

## Evidence

| Backend / region | Accepted | Band clipping | Delta |
| --- | ---: | ---: | ---: |
| WPF whole slide | 2.5546% | 2.6613% | +0.1067 pp |
| Avalonia whole slide | 2.2959% | 2.4029% | +0.1070 pp |
| WPF Surface ROI `(560,90)-(1030,310)` | 4.915178% | 5.866152% | +0.950974 pp |
| Avalonia Surface ROI | 4.885348% | 5.839772% | +0.954424 pp |
| WPF tight mesh `(590,105)-(980,300)` | 6.016537% | 7.309512% | +1.292975 pp |
| Avalonia tight mesh | 6.023926% | 7.321592% | +1.297665 pp |

Fresh probe renders were nonblank 1280x720 images. Stock, scatter, and 100%
stacked control ROIs were pixel-identical before and after in both hosts.
Focused tests compiled and ran 215 cases: 213 passed, while the two expected
canonical topology assertions detected the temporary facet-count and facet-
identity changes. After rejection, the accepted implementation and all locked
expectations were restored.

## Remaining residual

The remaining Surface3D residual stays at 2.5546% WPF and 2.2959% Avalonia
whole-slide error, with tight-mesh errors of 6.016537% and 6.023926%.
Continuous scalar band clipping is therefore not the missing Office topology.
Future work should derive default Office facet ownership and camera projection
from additional authoritative source meshes, rather than add local vertices,
change painter order, or retry per-triangle elevation clipping on this fixture.
