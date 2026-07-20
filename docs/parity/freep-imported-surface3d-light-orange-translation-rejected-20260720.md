# FreeP imported Surface3D light-orange translation probe rejected

Date: 2026-07-20  
Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`

## Probe

The accepted imported 3-by-3 Surface3D path moves only the low-left vertex of
the light-orange render triangle by `-36` normalized plot units in X. A fresh
Release probe changed that owner-local offset to `-60`, leaving the logical
mesh, the shared camera, all other facets, and unrelated chart families
unchanged.

## Matched current-artifact evidence

The candidate was compiled into the consuming `FreeP.RenderCompare` Release
artifact before rendering and compared with the persistent 1280x720
PowerPoint reference:

| Backend | Accepted | Candidate |
| --- | ---: | ---: |
| WPF whole slide | `2.6046%` | `2.6115%` |
| Avalonia vs PowerPoint whole slide | `2.3146%` | `2.3216%` |

The candidate was rejected and the accepted `-36` offset restored. The
negative result shows that the remaining light-orange envelope difference is
not explained by translating one shared edge toward the value axis. Further
work needs a generated-facet ownership or raster primitive explanation rather
than another scalar edge offset.

## Process guard

For imported generated charts, exact-color mask geometry can identify a
candidate owner, but both hosts and the whole slide remain the acceptance
gate. The shared mesh and unrelated chart controls must remain untouched
while probing one render-only facet.
