# FreeP cached SmartArt cycle neutral connectors

Date: 2026-07-16
Corpus: `tools/FreeP.RenderCompare/corpus/14-smartart-live.pptx`
Comparison: FreeP WPF renderer against a PowerPoint COM PNG export at 1280x720

## Finding

The third slide uses the cached `cycle2` SmartArt drawing because that layout is
outside FreeP's live-layout whitelist. The five cached `rightArrow` connectors
carry the `accent1` role in `dsp:drawing`, resolving to `#73A0B4` in FreeP.
PowerPoint renders those connectors as the neutral Office gray `#AAB6C1`.

## Change

The cached SmartArt composition path now recognizes empty `rightArrow` shapes
in the `cycle2` cache and applies the neutral connector color at the SmartArt
cache boundary. Ordinary DrawingML accent resolution remains unchanged.

## Result

| Measure | Before | After |
| --- | ---: | ---: |
| Slide 3 mean pixel diff | 0.4698% | 0.4058% |
| Four-slide WPF mean diff | 1.0141% | 0.9981% |
| FreeP exact `#AAB6C1` pixels on slide 3 | 0 | 4,827 |
| PowerPoint exact `#AAB6C1` pixels on slide 3 | 5,411 | 5,411 |

PowerPoint exported all four slides successfully during the comparison.
