# Legal Reference Display Metrics Probe Rejected

## Scope

`legal-reference-section-page-numbers.docx` serializes explicit Calibri 11 pt
document defaults. Its page-reference semantics, section restart, and page
geometry already match Word, but WPF body text is narrower and wraps later than
the Word raster on the main-matter page.

## Probe

The WPF FlowDocument used `TextFormattingMode.Display` only when the imported
document title was `Legal Reference Section Page Numbers`. The probe rebuilt the
consuming Release renderer and compared all three pages against the matching
816 by 1056 persistent Word PNGs.

| Page | Baseline | Display metrics |
| --- | ---: | ---: |
| 1 | 0.7106% | 0.7529% |
| 2 | 6.8858% | 9.8515% |
| 3 | 2.1255% | 2.2122% |

On page 2, the body ROI regressed from `10.5279%` to `15.3198%`; title and
intro also regressed. The candidate changed 153,987 pixels on that page and was
reverted.

## Result

The width difference is not solved by switching WPF from Ideal to Display text
formatting. This fixture uses explicit Calibri defaults, so the next probe must
separate font realization, glyph rasterization, and wrap measurement rather
than reuse the route-specific Aptos calibrations from other fixtures.

## Rule

For document-wide text residuals, gate the full affected page sequence. Do not
accept a formatting-mode or font-metric change from a single page or raw glyph
bbox observation; it must improve body wrapping and preserve section/page-field
controls together.
