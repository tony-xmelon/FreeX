# FreeP cached SmartArt process neutral background

Date: 2026-07-16  
Corpus: `tools/FreeP.RenderCompare/corpus/14-smartart-live.pptx`  
Comparison: FreeP WPF renderer against a PowerPoint COM PNG export at 1280x720

## Finding

The first slide uses the cached `IncreasingCircleProcess` SmartArt drawing because
that layout is outside FreeP's live-layout whitelist. The dark chord faces already
matched PowerPoint, but the three secondary ellipse fills were rendered as the
accent1 tint `#A1BFCD`. PowerPoint renders the same SmartArt background role as
the neutral `#CCD2D8` Office gray.

## Change

The cached SmartArt composition path now recognizes the `IncreasingCircleProcess`
background ellipse role and applies the neutral Office color at the SmartArt cache
boundary. Ordinary DrawingML tint resolution is unchanged.

## Result

| Measure | Before | After |
| --- | ---: | ---: |
| Slide 1 mean pixel diff | 1.2292% | 1.1316% |
| Four-slide WPF mean diff | 1.0385% | 1.0141% |
| FreeP pixels at `#CCD2D8` on slide 1 | 0 | 9,263 |
| PowerPoint pixels at `#CCD2D8` on slide 1 | 9,168 | 9,168 |

PowerPoint exported all four slides successfully during the comparison.
