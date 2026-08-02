# FreeW Handmade 2 page-border parity (2026-08-02)

## Scope

The imported Word `handmade2` page-border art (ArtId 160) previously used the generic
single rectangular fallback. The shared planner now owns two separately weighted cubic
stroke rails with Word-measured inset and restrained hand-drawn curvature. WPF, Avalonia
live rendering, Avalonia PDF export, and the software fallback consume the same plan.

## Matched reference

- Fixture: `handmade2.docx`, SHA-256
  `690CB615A74B6986590E1EAB572171CDA7B18BCEB0829C027BE268F35DDD4EF6`
- Word COM PNG: 816x1056, SHA-256
  `E6275C291C9D59552A987F27863C004A4B8DDD6C8CE2E3014CD95E76828AA33D`
- Before WPF composite PNG: 816x1056, SHA-256
  `E451310C9EDA62C6332F56C85EC83BE8C94EDFCDEC0624D04650867ED8726867`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `874BD09F3E4DB82347DC8A878C1220E8358DBFED705B7A1C19EA026E25BF5F2B`
- Candidate provenance: `FreeW.FidelityRender`, `renderPath=composite`,
  `captureSource=wpf-composite-renderer`

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 3.8352% | 2.0866% | -1.7486 pp |
| Top border | 12.5905% | 4.2449% | -8.3456 pp |
| Bottom border | 14.2111% | 4.6451% | -9.5660 pp |
| Left border | 14.8368% | 8.7735% | -6.0633 pp |
| Right border | 14.3376% | 7.9189% | -6.4187 pp |
| Interior control | 0.7673% | 0.7673% | 0.0000 pp |

The accepted candidate restores the missing inner rail and Word's page-relative registration.
Remaining error is concentrated in one-pixel hand-drawn curvature and corner joins; document
content is unchanged.

## Verification

- Focused shared planner contract: 1/1
- WPF decorative-border consumer source contract: 1/1
- Avalonia live/PDF consumer source contract: 1/1
- Handmade 2 PDF composition/raster contract: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page
- Fresh WPF composite render: 1/1 page

## Process note

This gallery item is a pair of independent physical rails, not a thick or doubled line-style
token. Measure each rail's page-relative registration and weight, preserve shared cubic geometry,
and require all edge ROIs plus the whole page to improve while the interior remains unchanged.
