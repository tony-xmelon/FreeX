# FreeW Maple Muffins page-border parity (2026-08-02)

## Scope

The imported Word `mapleMuffins` page-border art (ArtId 2) previously used the generic
four-line fallback. The shared page-border planner now owns the Word-sized repeated
muffin tile: a black cap/wrapper silhouette, orange `#FF8000` fill, and dark-orange
`#BF4000` folds. Word keeps every edge tile upright, and WPF, Avalonia live rendering,
Avalonia PDF export, and the software fallback now consume the same polygon plan.

## Matched reference

- Fixture: `maple.docx`, SHA-256
  `2BA6C6D075FD6CC0C543B1A4258F1A5ACCEE84469A2A6FF6F020F74D410F7E09`
- Word COM PNG: 816x1056, SHA-256
  `66169AD9828A919A4BDFFC37D94DB1F35A024C1CA2CAFE7B9A951E0706C825DA`
- Before WPF composite PNG: 816x1056, SHA-256
  `FC6726C1F4968D287094B8554C539F5B6183F5C487525FCD1F689FB1F1821894`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `EBBF1A439C04B647746FB4343FA57C3739B0EE928E8E409E84E654F7B9CAD4B4`
- Candidate provenance: `FreeW.FidelityRender`, `renderPath=composite`,
  `captureSource=wpf-composite-renderer`

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 6.7445% | 2.7745% | -3.9700 pp |
| Top border | 25.4588% | 9.4534% | -16.0054 pp |
| Bottom border | 24.6833% | 9.4616% | -15.2217 pp |
| Left border | 24.7057% | 8.9560% | -15.7497 pp |
| Right border | 26.0560% | 8.8892% | -17.1668 pp |
| Interior control | 0.7483% | 0.7483% | 0.0000 pp |

The shared plan reproduces the source tile count, upright orientation, dominant colors,
and border ownership on all four sides. Remaining error is concentrated in Word's curved
cap/wrapper antialiasing and fine highlight detail; body layout and text are unchanged.

## Verification

- `PageBorderArtVisualPlannerTests`: 11/11
- WPF decorative-border consumer source contract: 1/1
- Avalonia live/PDF consumer source contract: 1/1
- Maple Muffins PDF composition/raster contract: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page
- Fresh WPF composite render: 1/1 page

## Process note

The fresh border sweep and raw Word color counts identified this as a missing semantic
tile rather than a generic line-registration problem. Exact `#FF8000` and `#BF4000`
coverage, the 23-tile top cadence, and the upright side tiles supplied the plan contract.
Use source color masks and tile orientation to recover decorative ownership, then require
all edge ROIs and the whole page to improve while the interior control remains stable.
