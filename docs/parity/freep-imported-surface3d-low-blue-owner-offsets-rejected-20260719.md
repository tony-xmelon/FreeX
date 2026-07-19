# FreeP imported Surface3D low-blue owner offsets rejected

Date: 2026-07-19
Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`

## Probes

The exact `#4474C7` low/front mask was smaller and higher than PowerPoint.
Two render-only owner probes kept the logical mesh unchanged:

1. Move only the blank-point edge of the blue `(series=0, category=0)` facet
   down `16` DIPs, leaving the orange neighbor on the shared point.
2. Restore that edge and move only the blue facet's middle-North point down
   `16` DIPs, leaving all other facets on the shared point.

## Evidence

Each candidate used a freshly rebuilt Release `FreeP.RenderCompare` artifact
and the persistent 1280x720 PowerPoint reference:

| Backend | Accepted | Blue blank-edge candidate | Blue middle-North candidate |
| --- | ---: | ---: | ---: |
| WPF whole slide | `2.6082%` | `2.6200%` | `2.6314%` |
| Avalonia whole slide | `2.3183%` | `2.3295%` | `2.3413%` |

The focused presentation contract passed `200/200` for each active candidate.
Both probes were rejected; neither local mask hypothesis explains the full
PowerPoint painter result.

## Rule

The low/front color boundary is not safely corrected by moving either visible
edge independently. The next investigation must model the generated facet
triangle/painter ownership itself, rather than add another render-local offset.
