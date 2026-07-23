# FreeP Avalonia radar lower-label registration - 2026-07-23

## Scope

The imported five-category radar chart in `18-chart-types.pptx`, slide 3,
already had a WPF-local lower-label registration correction. Raw dark-ink
component masks showed that Avalonia still used the uncorrected shared label
boxes:

| Label | PowerPoint | WPF current | Avalonia current |
| --- | --- | --- | --- |
| Agility | `(761,592)-(821,611)` | `(760,592)-(819,611)` | `(726,592)-(783,610)` |
| Stamina | `(354,592)-(437,607)` | `(354,592)-(430,607)` | `(406,592)-(480,606)` |

Avalonia now applies the same measured `+35 DIP` Agility and `-51 DIP`
Stamina horizontal registrations plus the existing `-2 DIP` lower-label
vertical correction, but only for the exact imported nine-ring,
five-category, two-series radar signature. Shared chart geometry is unchanged.

## Result

Fresh same-main candidate/control captures used the current 1280x720
PowerPoint raster and the previously accepted radar series-stroke correction:

| Host | Current main | Candidate | Improvement |
| --- | ---: | ---: | ---: |
| WPF slide 3 | 1.0212% | 1.0212% | byte-stable |
| Avalonia slide 3 | 1.0212% | 0.9960% | -0.0252 pp |

Slides 1, 2, and 4 were byte-identical between candidate and current main on
both hosts. WPF's existing label registration remained unchanged.

## Verification

- Radar contracts: `9/9` compiled and passed.
- Full `ChartBaselineCorpusTests`: `27/27` no-build.
- Consuming `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Candidate and controls used matching renderer provenance and 1280x720
  dimensions.

## Process rule

When host text rasterizers need different registration, keep the correction in
the host renderer and guard it by the imported chart signature. Do not move
host offsets into shared chart math or generalize them to authored radar data.
