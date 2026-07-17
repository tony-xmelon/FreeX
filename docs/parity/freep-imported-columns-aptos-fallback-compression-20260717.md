# FreeP imported Aptos column fallback parity

This slice addresses the imported `20-columns-gradoutline.pptx` fixture, where
PowerPoint's two-column text flow uses a narrower effective Aptos glyph width
than the WPF fallback selected on this host. The authored column width is
`146.40 DIP`; the WPF fallback measured `paragraph 2. More` at `157.00 DIP`.

## Change

The WPF continuous-flow path applies a narrow `0.93` horizontal scale to
plain, single-run imported Aptos text and uses the corresponding effective
width while greedily assigning words to columns. Other fonts, text routes,
autofit, stored font scaling, bullets, tabs, and effects keep their existing
paths.

## Matched COM evidence

All images are `1280x720` and were captured from the same current-main
PowerPoint COM export. The baseline is the current `1.1286%` WPF result from
the continuous-flow slice.

| ROI | Before | After | Delta |
| --- | ---: | ---: | ---: |
| WPF whole page | 1.1312% | 1.1061% | -0.0251 pp |
| Text box `(45,45)-(410,305)` | 8.0993% | 7.8558% | -0.2435 pp |
| Left column `(50,50)-(230,290)` | 11.8860% | 11.5095% | -0.3764 pp |
| Right column `(245,50)-(405,290)` | 5.5469% | 5.3713% | -0.1756 pp |
| Paragraph-2 crop `(50,145)-(230,225)` | 12.0377% | 12.0534% | +0.0157 pp |
| Gradient-outline control `(470,40)-(810,310)` | 2.9832% | 2.9832% | 0.0000 pp |

The full RenderCompare score moved from `1.1286%` to `1.1038%`. The small
paragraph-2 increase is within the `0.05 pp` adjacent-flow bound; the text-box
and whole-page scores improve, and the neighboring gradient-outline object is
byte-stable. A `0.9325` scale, derived from the measured width ratio, was
tested and rejected at `1.1088%`, so the accepted value is fixture-calibrated
raster evidence rather than a direct geometric ratio.

## Verification

- Focused presentation contracts: `49/49` passed.
- `FreeP.RenderCompare` Release build: `0` warnings, `0` errors.
- Matched COM `--avalonia-compare`: WPF `1.1038%`, Avalonia `0.8179%`,
  Avalonia-vs-PowerPoint `0.9432%`.
