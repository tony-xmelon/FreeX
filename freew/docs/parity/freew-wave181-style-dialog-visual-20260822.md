# FreeW Wave181: Style dialog visual parity

Date: 2026-08-22
Base: `bc5cae61f049a0c6d724c01a469827adbf3f41f2`
Target DPI: WPF 144 / Avalonia 96, compared at the shared `327x463` authority frame

## Selected Family

The bounded `style` family covers `style.initial`, `style.populated`, and
`style.validation-error`. The deterministic product delta was accumulated
vertical layout drift in the New/Modify Style dialog: Avalonia labels realized
at 14 logical pixels, its field rows used a tighter bottom rhythm, and its
action buttons were 20 pixels high while the shared WPF dialog resource uses
26 pixels. This is a product-owned layout/style mismatch, not a font-only
rasterizer floor.

## Correction

FreeW's shared `StyleDialogMetrics` now records the WPF label and action-button
heights plus the Avalonia field-row compensation. The Avalonia Style dialog
consumes those values for seven labels, all field rows, and the OK/Cancel row;
the WPF host and shared cross-app resources are unchanged. Existing comparison
thresholds and classifications were not altered.

## Fresh Evidence

Route-local captures were taken after the correction:

- WPF authority: `artifacts/freew-wave181-style-after-wpf/`
- Avalonia: `artifacts/freew-wave181-style-after2-avalonia/`
- Comparison: `artifacts/freew-wave181-style-after2-compare/`

All three WPF and all three Avalonia scenarios captured successfully. Metrics
improved as follows:

| State | Changed ratio before | Changed ratio after | Mean channel delta before | Mean channel delta after | pHash before/after | Content bounds WPF/Avalonia after |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| Initial | 21.3645% | 7.6030% | 12.0910 | 6.9487 | 14 / 0 | 280x389 / 282x389 |
| Populated | 21.3671% | 7.6994% | 12.1284 | 7.1208 | 14 / 0 | 280x389 / 282x389 |
| Validation error | 21.3724% | 7.6030% | 12.1104 | 6.9487 | 14 / 0 | 280x389 / 282x389 |

The rows remain honestly classified as `genuine-visual-mismatch`: residual
native control chrome and raster differences remain above the existing visual
threshold. No pass was manufactured and the canonical aggregate was not
regenerated; its tracked counts remain 80 pass, 141 genuine mismatches, and
70 Avalonia extensions.

## Verification

- Focused Avalonia parity tests: `20/20` passed, including realized label,
  field-row, and button geometry assertions.
- WPF route capture: `3/3` captured.
- Avalonia route capture: `3/3` captured.
- Route comparison: `3` comparable rows, all still
  `genuine-visual-mismatch` under unchanged thresholds.
