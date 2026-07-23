# FreeP imported radar series stroke parity - 2026-07-23

## Scope

`18-chart-types.pptx`, slide 3, is a two-series, five-category imported radar
chart. The PowerPoint raster's exact series-color cores contain approximately
3,508 `#156082` pixels and 3,729 `#E97132` pixels. Current WPF contained
approximately 2,310 and 2,366 respectively; Avalonia showed the same thinner
series treatment. The source-scoped imported radar series stroke was therefore
raised from 3.0 to 4.0 DIP. Generic and authored radar charts retain their
existing stroke constants.

## Result

Candidate and current-main control renders used the same 1280x720 artifacts
and persistent PowerPoint raster:

| Host | Current main | Candidate | Improvement |
| --- | ---: | ---: | ---: |
| WPF slide 3 | 1.0622% | 1.0212% | -0.0410 pp |
| Avalonia slide 3 | 1.0458% | 1.0082% | -0.0376 pp |

The candidate-vs-control delta was isolated to radar slide 3. Slides 1, 2,
and 4 were byte-identical on both hosts relative to the current main, which
includes the previously accepted imported bubble legend correction.

## Verification

- Imported radar contract: 1/1 compiled and passed.
- Full `ChartBaselineCorpusTests` focused class: 27/27 no-build.
- Consuming `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Both WPF and Avalonia candidate captures matched the PowerPoint raster
  dimensions and provenance.

## Process rule

Use exact series-color core coverage as an owner diagnostic, but accept a
stroke calibration only when the full target slide improves in both active
renderers and all other chart slides remain byte-stable. The earlier radar
grid-color probe remains rejected; this slice changes series stroke weight
only.
