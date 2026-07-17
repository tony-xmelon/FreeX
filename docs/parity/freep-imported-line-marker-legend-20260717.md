# FreeP imported line-marker legend parity

Date: 2026-07-17

## Scope

The imported `06-charts.pptx` line-with-markers chart used a filled square
swatch for each legend entry. PowerPoint renders each entry as the series
stroke plus its series marker: diamond for `2023` and square for `2024`.

## Change

- The shared chart legend planner now recognizes imported `LineMarkers` charts.
- It emits a 29 x 12 DIP line swatch with the imported marker palette and a
  29 DIP label inset.
- WPF and Avalonia consume the same legend plan by drawing the stroke first,
  then the marker; existing pie, scatter, combo, and radar paths remain
  separate.
- The corpus contract asserts the line flag, marker symbols, swatch width,
  and label inset.

## ROI evidence

All values are mean RGB channel difference against a fresh PowerPoint COM PNG
at 1280 x 720. The targeted legend ROI is `(1100,340)-(1280,430)` on slide 2.

| Renderer | Target ROI before | Target ROI after | Delta | Whole slide before | Whole slide after | Delta |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| WPF | 5.8596% | 5.7587% | -0.1009 pp | 1.8956% | 1.8938% | -0.0018 pp |
| Avalonia | 5.8275% | 5.7003% | -0.1272 pp | 1.7531% | 1.7508% | -0.0022 pp |

The wider legend ROI `(1080,330)-(1280,450)` improved by `0.0681 pp` in WPF
and `0.0859 pp` in Avalonia. The other three slides were unchanged.

## Verification

- Focused compiling planner/corpus tests: `196 passed, 0 failed`.
- Focused `--no-build` planner/corpus tests: `196 passed, 0 failed`.
- Focused Avalonia renderer tests: `68 passed, 0 failed`.
- WPF renderer build: passed with 0 warnings and 0 errors.
- RenderCompare build: passed with 0 warnings and 0 errors.
- Fresh `--avalonia-compare` COM export: 4/4 PowerPoint slides exported.

The whole-page change is material only in the targeted legend pixels; the
overall slide metric moves slightly because the legend occupies a small area.
