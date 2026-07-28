# WPF Chart Text Fallback Fidelity

## Scope

The `chart-smartart-complex.docx` page-one Word baseline has aligned chart geometry but
WPF rendered scene text with its default Segoe UI fallback. The residual is visible in
the chart title, axes, labels, and legend; page two has no chart scene and is the control.

## Change

WPF `DocumentView.AddSceneText` now assigns Calibri explicitly to planned chart scene
text. The shared chart scene remains authoritative for positions, font sizes, and
semantics; this is only the WPF glyph-raster fallback.

## Matched Word Evidence

Reference: the persistent `chart-smartart-complex` Word PDF raster at 816x1056 in
`C:\Users\ali\AppData\Local\Temp\FreeW-WordCom-20260728-cache`.

| Region | Segoe UI baseline | Calibri | Change |
| --- | ---: | ---: | ---: |
| Page 1 whole | 1.7408% | 1.7232% | -0.0176 pp |
| Column title | 9.9922% | 9.3478% | -0.6444 pp |
| Column chart | 3.9728% | 3.9163% | -0.0565 pp |
| Scatter chart | 5.5743% | 5.4445% | -0.1298 pp |
| Page 1 body-text control | 7.6318% | 7.6318% | byte-stable |

`Aptos` was rejected: it improved only the title (`9.6553%`) but regressed the column
chart (`4.0277%`). Page two stayed byte-identical for all candidates.

## Verification

- Focused WPF chart renderer tests cover the explicit Calibri fallback.
- The consuming `FreeW.FidelityRender` Release artifact was rebuilt before the matched
  one-fixture render and the candidate output was retained beside the Word reference.

## Guard

Keep chart layout in `ChartSmartArtVisualPlanner`. Apply WPF typeface calibration only
to chart-scene text, require a matching Word baseline plus target and whole-page gains,
and retain an unaffected-page control.
