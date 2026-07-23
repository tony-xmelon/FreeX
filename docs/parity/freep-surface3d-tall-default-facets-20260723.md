# FreeP tall default Surface3D facets

The imported `26-chart-surface3d-default-tall-frame` fixture uses the same
source signature as the canonical imported Surface3D depth baseline: no
authored `c:view3D`, three categories, three series, and values
`{10,null,18}`, `{18,22,26}`, and `{28,24,35}`. The existing WPF-only facet
replacement was previously gated to the canonical `360x189` plot, so the
tall fixture bypassed it even though its source data matched. The planner now
reuses that measured replacement scaled to the active plot dimensions.

The correction remains WPF-local. Avalonia continues to consume the shared
`RenderFacets`, and authored-camera Surface3D charts retain their separate
path.

Fresh 1280x720 matching PowerPoint raster comparisons from the rebuilt
Release renderer:

| Fixture | WPF before | WPF after | Avalonia before | Avalonia after |
| --- | ---: | ---: | ---: | ---: |
| 26 tall default Surface3D | 2.5867% | 2.5606% | 2.3455% | 2.3455% |
| 22 default Surface3D control | 2.4862% | 2.4862% | 2.2959% | 2.2959% |
| 25 authored view3D control | 2.7943% | 2.7943% | 2.9275% | 2.9275% |

The WPF 22 and 25 control PNGs were SHA-256 byte-identical before and after
the probe. Focused planner/corpus tests passed `224/224` both when compiling
and with `--no-build`; the consuming `FreeP.RenderCompare` Release build had
zero warnings and errors.
