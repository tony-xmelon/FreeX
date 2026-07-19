# FreeP imported Surface3D boundary probes rejected - 2026-07-19

## Scope

Two render-only probes targeted exact underfilled color masks in the imported
3-by-3 `Surface3D` fixture `22-chart-baseline-depth.pptx`:

1. Move the rear-green boundary facet upper-middle vertex from normalized
   `x=232` to `x=230`.
2. Widen the already isolated dark-orange near-face left-edge correction from
   `-13` to `-18` DIP.

Shared logical points, authored charts, chart-family dispatch, and unrelated
chart regions were unchanged.

## Matched current-artifact evidence

The actual Release `FreeP.RenderCompare` artifact was rebuilt before each
render. The PowerPoint reference was the matching 1280x720 PNG.

| Gate | Accepted | Green `x=230` | Orange `-18` |
| --- | ---: | ---: | ---: |
| WPF whole page | `2.6082%` | `2.6123%` | `2.6120%` |
| WPF Surface ROI | `5.0274%` | `5.0273%` | `5.0251%` |
| WPF green/orange ROI | `4.3252%` green | `4.3252%` green | `3.2288%` orange |
| Avalonia whole page | `2.3302%` baseline | `2.3184%` | `2.3180%` |
| Exact target mask | green `853` px | green `891` px | orange `4,271` px |

The green candidate moved closer to the PowerPoint green mask (`1,161` px)
and the orange candidate expanded its mask toward PowerPoint (`4,962` px),
but both traded those local gains for a WPF whole-page regression. Neither
candidate was retained.

The accepted source values remain green `x=232` and dark-orange left offset
`-13` DIP. Stock, scatter, and 100%-stacked chart regions were unchanged by
the probes.

## Verification

- `FreeP.RenderCompare` Release build: `0` warnings, `0` errors for each probe.
- Fresh WPF and Avalonia renders completed for the target.
- Product source was restored to the accepted geometry after scoring.

## Process rule

For imported 3-D charts, exact-color mask gains are only candidate evidence.
A boundary-facet correction is acceptable only when the target ROI, both-host
whole-page gates, and neighboring ownership all improve or remain stable.
