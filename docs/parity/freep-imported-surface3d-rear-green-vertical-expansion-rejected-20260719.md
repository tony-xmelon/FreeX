# FreeP imported Surface3D rear-green vertical expansion rejected

Date: 2026-07-19
Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`

## Probe

The imported rear-green `#8BAB74` boundary face was tested with an owner-local
vertical expansion: its upper-middle normalized point moved from `y=42` to
`y=41`, and its right point from `y=33` to `y=34`. Shared Surface3D mesh
points, the yellow and fold faces, and all other chart paths were unchanged.

## Evidence

The current Release `FreeP.RenderCompare` artifact was rebuilt before scoring
against the persistent 1280x720 PowerPoint reference:

| Backend | Accepted | Candidate |
| --- | ---: | ---: |
| WPF whole slide | `2.6082%` | `2.6091%` |
| Avalonia whole slide | `2.3183%` | `2.3194%` |

The focused presentation contract passed `200/200`. The candidate was
rejected because both hosts regressed at whole-slide scope despite the
change being isolated to the underfilled target face.

## Rule

The remaining rear-green mask gap is not safely corrected by independent
polygon expansion. Require a raster/ownership explanation that improves the
target ROI and both-host whole-slide gates before changing this boundary
face again.
