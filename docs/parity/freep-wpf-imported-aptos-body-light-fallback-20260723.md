# FreeP WPF imported Aptos body fallback

The imported `17-bullets-autofit` slide 2 body is an exact eight-paragraph,
18pt Aptos, `a:noAutofit` route. Aptos is not installed on the comparison
host, and the WPF fallback glyphs are heavier than PowerPoint's Aptos raster
even though line cadence and the accepted horizontal fit already match.

WPF now uses a renderer-only Light fallback weight plus a measured horizontal
fit for that exact body signature. The shared text model, paragraph measurement,
title, Avalonia renderer, and all other WPF text routes remain unchanged.

Fresh 1280x720 matching PowerPoint PNG comparison from the consuming Release
artifact:

| Metric | Accepted baseline | Candidate |
| --- | ---: | ---: |
| WPF slide 2 whole page | 3.2245% | 3.0636% |
| WPF slide 2 body dark-ink count | 27,990 | 18,296 |
| Word slide 2 body dark-ink count | 26,473 | 26,473 |
| WPF body bbox | `(78,115)-(505,564)` | `(78,115)-(505,564)` |
| Word body bbox | `(78,117)-(505,564)` | `(78,117)-(505,564)` |
| WPF slide 1 title control | 0.8672% | 0.8672% |
| Avalonia slide 2 | 3.1232% | 3.1232% |

The metric improvement is a host fallback calibration, not a claim that the
proprietary Aptos font has been reproduced. Existing font-substitution and
vertical-raster probes remain rejected; layout ownership is unchanged.
