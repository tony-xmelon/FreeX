# FreeP stock fallback title raster

Date: 2026-07-17
Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`

## Finding

The imported stock chart has no high/low lines, so PowerPoint renders its four
series through the line-series fallback. The WPF fallback title was rasterized
about five pixels too far left and two pixels too high. Avalonia already matched
the PowerPoint title origin, so this correction stays in the WPF renderer.

## Change

The WPF renderer applies a small translated title rectangle only when rendering
a stock chart without high/low lines. The shared chart plan and all other chart
title paths remain unchanged.

## Measurement

At 1280x720 against a fresh PowerPoint COM export:

| Metric | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Stock title ROI (80,45)-(500,95) | 9.3450% | 8.4123% | -0.9327 pp |
| Stock chart ROI (40,40)-(530,330) | 5.2459% | 5.1081% | -0.1378 pp |
| Stock plot ROI (55,95)-(520,310) | 5.1361% | 5.1361% | 0.0000 pp |
| WPF whole page | 2.6976% | 2.6763% | -0.0213 pp |

PowerPoint exported `1/1` slide without repair. The targeted plot and axis
regions were byte-stable, confirming that the change is isolated to the title
raster.

## Verification

- `FreeP.App.Rendering.Wpf` Release build: 0 warnings, 0 errors.
- `FreeP.RenderCompare --compare` completed with a fresh COM export.
