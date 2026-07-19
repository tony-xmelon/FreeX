# FreeP WPF imported Aptos title raster fit

Date: 2026-07-18

## Finding

On `17-bullets-autofit.pptx`, PowerPoint's 28pt `Autofit Shrink Demo` title is
authored through the theme's major Aptos Display route, but FreeP resolves the
run to the minor Aptos fallback. The existing 0.95 horizontal fallback scale
helped width while leaving the title glyphs too tall.

## Change

WPF applies a 0.86 vertical raster scale around the formatted title baseline
only when the imported title signature is exactly Aptos, 28pt, and
`Autofit Shrink Demo`. Layout measurement, line breaks, body text, Avalonia,
and other Aptos runs are unchanged.

## Matched COM evidence

Fresh 1280x720 PowerPoint COM export and current Release WPF composite:

| ROI | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Slide 2 whole page | 3.3067% | 3.2897% | -0.0170 pp |
| Slide 2 text `(60,95)-(560,590)` | 11.2349% | 11.2349% | 0.0000 pp |
| Slide 2 title `(400,10)-(880,75)` | 8.5514% | 8.0503% | -0.5011 pp |

Slide 1 is SHA-256 byte-identical to the pre-probe WPF render. The raw title
ink box moved from `(470,24)-(809,51)` toward Word's `(470,28)-(808,51)`;
the candidate is `(470,29)-(809,52)`. Avalonia output is unchanged.

## Verification

- Focused `BulletsAutofitTests|TextLayoutPlannerTests`: 83/83.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh two-slide COM comparison completed successfully.
