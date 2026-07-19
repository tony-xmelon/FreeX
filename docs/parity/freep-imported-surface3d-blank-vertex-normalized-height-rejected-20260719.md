# FreeP imported Surface3D blank-vertex height probe rejected

Date: 2026-07-19
Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`

## Probe

The exact-color low/front blue mask in the current FreeP render begins around
`y=211`, while the matching PowerPoint mask begins around `y=227`. The
imported blank-cell fallback vertex was therefore tested with its render-only
normalized height changed from `0.24` to `0.14`. The chart model, authored
blank value, shared projection, and all non-Surface3D chart paths were left
unchanged.

## Evidence

The current Release `FreeP.RenderCompare` artifact was rebuilt before scoring
against the persistent 1280x720 PowerPoint reference:

| Backend | Accepted | Candidate |
| --- | ---: | ---: |
| WPF whole slide | `2.6082%` | `2.6701%` |
| Avalonia whole slide | `2.3183%` | `2.3782%` |

The local blue-mask displacement was not accepted because both complete
whole-slide gates regressed. The candidate focused presentation contract
passed `200/200`, and both fresh renders were non-empty and fully opaque.

## Rule

For the imported blank Surface3D cell, the apparent blue/orange boundary is
owned by shared projected rasterization. Do not lower the fallback vertex from
an exact-color mask alone; require target ROI, both-host whole-slide gates,
and stable neighboring chart controls before changing the shared facet
boundary.
