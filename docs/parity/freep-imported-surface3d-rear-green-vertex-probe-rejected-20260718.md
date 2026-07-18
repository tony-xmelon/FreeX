# FreeP imported Surface3D rear-green vertex probe rejection

Date: 2026-07-18

## Fixture and provenance

`tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`, slide 1,
was rendered at 1280x720 with a fresh matching PowerPoint COM export. The
candidate and accepted baseline used the same PowerPoint PNG and the
`composite/wpf-composite-renderer` path.

## Probe

The imported rear-green `#8BAB74` boundary facet's upper-middle normalized
vertex moved from `(232,42)` to `(220,42)`. The change was limited to the
imported 3-by-3 Surface3D boundary-facet path; the shared mesh projection,
other boundary faces, and authored charts were unchanged.

The exact-color mask improved locally:

- PowerPoint: `1,161` pixels, bbox `(797,139)-(896,174)`
- Accepted FreeP: `853` pixels, bbox `(801,139)-(896,174)`
- Candidate FreeP: `1,086` pixels, bbox `(799,139)-(896,175)`

The local mask gain was rejected by the complete gates:

| Metric | Accepted | Candidate |
| --- | ---: | ---: |
| WPF whole page | `2.6185%` | `2.6201%` |
| Avalonia whole page | `2.3288%` | `2.3307%` |

The stock, scatter, and 100%-stacked chart controls were not changed by the
probe. The source test passed `198/198`, and the rebuilt RenderCompare
artifact completed without warnings or errors.

## Rule

An exact-color facet-mask improvement is insufficient when its polygon
changes the shared raster boundary enough to worsen the whole page. Keep the
accepted vertex registration and require target ROI, whole page, both-host,
and unaffected-chart controls before any further Surface3D boundary probe.
