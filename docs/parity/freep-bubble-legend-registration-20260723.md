# FreeP imported bubble legend registration - 2026-07-23

## Scope

`18-chart-types.pptx`, slide 4, contains a PowerPoint-authored Bubble chart
with one `Series1` series, X values `1,2,3,4,5`, Y values `10,30,15,40,25`,
and no `c:bubbleSize` payload. The correct functional behavior is therefore
an empty plot with axes, gridlines, and a single circle legend marker.

Raw matching 1280x720 captures showed a legend registration mismatch:

| Raster | Exact `#156082` legend-marker bbox |
| --- | --- |
| PowerPoint | `(1118,398)-(1129,409)` |
| WPF current main | `(1117,377)-(1127,387)` |
| Avalonia current main | `(1117,377)-(1127,387)` |

The imported signature now has a renderer-neutral legend plan adjustment:
the marker moves down 21 DIP, its right gap is 32 DIP, and its label inset is
20 DIP. Generic bubble charts and the missing-size behavior are unchanged.

## Result

Fresh candidate and same-main control were both built from current `origin/main`
artifacts and rendered at 1280x720 against the persistent PowerPoint capture:

| Host | Current main | Candidate | Improvement |
| --- | ---: | ---: | ---: |
| WPF | 0.6742% | 0.6506% | -0.0236 pp |
| Avalonia | 0.7026% | 0.6725% | -0.0301 pp |

Candidate-vs-control changed only slide 4. Slides 1-3 were SHA-identical on
both hosts. The candidate marker bbox was `(1119,398)-(1129,408)` on both
hosts, matching the PowerPoint vertical registration and reducing the
horizontal residual to one pixel.

## Verification

- `ChartTypesCorpus_BubbleWithoutSizesKeepsAxesButDoesNotInventBubbles`: 1/1
  compiled and passed; the test also locks the exact legend plan signature.
- Full `ChartBaselineCorpusTests` focused class: 27/27.
- Consuming `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Same-main control worktree and candidate worktree used matching source,
  dimensions, and renderer provenance.

## Process rule

Treat missing bubble-size data as an intentional PowerPoint-visible state,
then calibrate only the independently owned legend geometry. Do not invent
plot bubbles or generalize a legend offset across bubble charts.
