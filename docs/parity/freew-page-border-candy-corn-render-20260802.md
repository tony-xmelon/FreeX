# FreeW Candy Corn page-border parity (2026-08-02)

## Scope

The imported Word `candyCorn` page-border art (ArtId 4) previously used the generic
four-line fallback. The shared planner now owns the source tile's three-candy triangular
cadence and ordered black, yellow, orange, and white layers. WPF, Avalonia live rendering,
Avalonia PDF export, and the software fallback consume the same geometry.

## Matched reference

- Fixture: `candy.docx`, SHA-256
  `02D2643306F421A134A71DF4ADCB6243278EAF1AD5720D3ACE3585D65786E966`
- Word COM PNG: 816x1056, SHA-256
  `75241B85A08B63B36E56E4084292BCF503FEF10D7879EA409A3D89D8E19A84E5`
- Before WPF composite PNG: 816x1056, SHA-256
  `B719FE2B2F592E0F444095D3217F8358C078010CFF863CF0EB674D5A3001D82B`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `7E6F58DBAA3232447D0DC773807300EB0EAABB072A9D2BEDC65A9992993B9195`
- Candidate provenance: `FreeW.FidelityRender`, `renderPath=composite`,
  `captureSource=wpf-composite-renderer`

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 3.7978% | 3.4845% | -0.3133 pp |
| Top border | 14.5001% | 13.0205% | -1.4796 pp |
| Bottom border | 14.8522% | 13.7237% | -1.1285 pp |
| Left border | 13.7361% | 12.7056% | -1.0305 pp |
| Right border | 14.2490% | 12.7787% | -1.4704 pp |
| Interior control | 0.3891% | 0.3891% | 0.0000 pp |

The accepted candidate restores Word's exact dominant colors (`#FE4501` and `#F5C60A`),
three-object tile topology, and edge rotations. Remaining error is concentrated in the
fine diagonal contour and Word's antialiasing; document content is unchanged.

## Verification

- `PageBorderArtVisualPlannerTests`: 15/15
- WPF decorative-border consumer source contract: 1/1
- Avalonia live/PDF consumer source contract: 1/1
- Candy Corn PDF composition/raster contract: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page in 8.6 seconds
- Fresh WPF composite render: 1/1 page

## Process note

A first single-row probe used the correct colors but regressed the whole page and all
edges. Raw color-mask components exposed the real three-object 32-DIP tile. Preserve
that source topology, then require whole-page and all-edge ROI gains plus an unchanged
interior before accepting any contour or angle refinement.
