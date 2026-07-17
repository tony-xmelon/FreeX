# FreeP stock fallback value-axis labels

Date: 2026-07-17
Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`

## Finding

After the stock-fallback title alignment, the remaining left-axis residual was
the value-label column. WPF placed the labels about 10 pixels too far left and
6 pixels too high across the imported `18..0` scale. PowerPoint keeps the same
label spacing but uses a wider left gutter.

## Change

The WPF renderer translates value-axis labels only for stock charts without
high/low lines. Shared axis geometry, tick strokes, the title path, Avalonia,
and all other chart families remain unchanged.

## Measurement

At 1280x720 against a fresh PowerPoint COM export:

| Metric | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Value-label ROI (45,90)-(78,312) | 6.3091% | 3.7121% | -2.5970 pp |
| Stock left-axis ROI (50,95)-(115,310) | 7.1001% | 5.8772% | -1.2229 pp |
| Stock chart ROI (40,40)-(530,330) | 5.1081% | 4.9742% | -0.1339 pp |
| Stock plot ROI (55,95)-(520,310) | 5.1361% | 5.0129% | -0.1232 pp |
| WPF whole page | 2.6763% | 2.6557% | -0.0206 pp |

The title, tick-strip, and Surface3D ROIs were byte-stable. PowerPoint exported
`1/1` slide without repair.

## Verification

- `FreeP.App.Rendering.Wpf` Release build: 0 warnings, 0 errors.
- `FreeP.RenderCompare --compare` completed with a fresh COM export.
