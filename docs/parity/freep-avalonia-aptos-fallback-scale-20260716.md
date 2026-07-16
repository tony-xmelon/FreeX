# FreeP Avalonia Aptos fallback scale

Date: 2026-07-16

## Scope

The imported `17-bullets-autofit.pptx` corpus uses Aptos for both the title and
body text. The Avalonia headless host does not provide Aptos, and its prior
Cambria fallback produced visibly different imported text metrics. The fallback
now uses installed Arial with a `0.95` font-size scale for Aptos runs only.
Paragraph leading remains on the existing PowerPoint-calibrated path, and
other font families keep their original size.

## COM comparison

At 1280x720 against a fresh PowerPoint export:

| Metric | Before | After |
| --- | ---: | ---: |
| Avalonia slide 1 | 1.0202% | 1.0449% |
| Avalonia slide 2 | 3.6383% | 3.1232% |
| Avalonia deck average | 2.3292% | 2.0841% |

The chart-types control remained healthy and improved slightly from the prior
baseline:

- `18-chart-types.pptx` average: `1.0343%`;
- slide values: `0.5970%`, `1.0005%`, `1.1969%`, `1.3426%`.

Fresh comparison artifacts are in:

- `artifacts/freep-bullets-17-arial095-com-20260716/`;
- `artifacts/freep-bullets-chart18-control-20260716/`.

## Verification

- `SlideCanvasLineSpacingTests` and `SlideCanvasMathBaselineTests`: 53 passed;
- `BulletsAutofitTests` and `TextLayoutPlannerTests`: 82 passed;
- the RenderCompare project build completed with 0 warnings and 0 errors;
- `git diff --check` passed.
