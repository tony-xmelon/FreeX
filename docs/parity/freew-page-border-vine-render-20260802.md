# FreeW Vine page-border parity (2026-08-02)

## Scope

The imported Word `vine` page-border art (ArtId 47) previously used the generic
four-line fallback. The shared page-border planner now owns its black rails, repeated
white stem-and-leaf cells, and isolated flower corners. WPF, Avalonia live rendering,
Avalonia PDF export, and the software fallback consume the same fill-and-polygon plan.

## Matched reference

- Fixture: `vine.docx`, SHA-256
  `48B2A4D05866005E721823FF0C635EFC52D43D80F0CF8103677F33F38B38286B`
- Word COM PNG: 816x1056, SHA-256
  `5AFFEA19F50417912C8072A5862D9CE4000501D0358D8177F295ADD31B069364`
- Before WPF composite PNG: 816x1056, SHA-256
  `5C345884AA35E4D7B9BC341F8FDE87B94AB28D8C814C92CCFED1AD271C23C985`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `42222670AA3CCECEDE3311870A29EF8E56C238E91D9719F633AFF0E003E4516A`
- Candidate provenance: `FreeW.FidelityRender`, `renderPath=composite`,
  `captureSource=wpf-composite-renderer`

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 7.4025% | 4.0899% | -3.3126 pp |
| Top border | 29.0431% | 13.9129% | -15.1302 pp |
| Bottom border | 27.5668% | 15.8454% | -11.7214 pp |
| Left border | 28.8423% | 16.6002% | -12.2421 pp |
| Right border | 27.0463% | 12.5651% | -14.4812 pp |
| Interior control | 0.6567% | 0.6567% | 0.0000 pp |

The new path reproduces the source's black band ownership and repeated white vine
silhouette on every edge. Remaining border error is concentrated in leaf curvature,
flower detail, and raster antialiasing; body layout and text remain unchanged.

## Verification

- `PageBorderArtVisualPlannerTests`: 10/10
- WPF decorative-border consumer source contract: 1/1
- Avalonia live/PDF consumer source contract: 1/1
- Vine PDF composition/raster contract: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh WPF composite renders: control plus two bounded orientation candidates

## Process note

A fresh ten-fixture Word COM sweep ranked Vine as the largest remaining page-border
residual. Reversing only the bottom and left tile cross-axis orientation improved the
whole page from the first candidate's 4.5652% to 4.0899%, while top/right and the
interior control remained stable. Decorative tiles must preserve edge-specific
orientation; accept a shared motif only when all four edge ROIs and the whole page
improve against the same Word reference.
