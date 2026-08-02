# FreeW Flowers - Roses page-border parity (2026-08-02)

## Scope

The imported Word `flowersRoses` page-border art (ArtId 38) previously used the generic
four-line fallback. The shared planner now owns the rose's ordered dark outline, magenta
petals, green leaf and vein, and lower bud/stem geometry. WPF, Avalonia live rendering,
Avalonia PDF export, and the software fallback consume the same upright motif plan.

## Matched reference

- Fixture: `flowers-roses.docx`, SHA-256
  `ED5AE18BBAE584C5C27284B8C43E2F9F7F78FF153C69C2A58BA7AE1B0B14BE19`
- Word COM PNG: 816x1056, SHA-256
  `A3B2360FC8C3016F0F96815C748F5690D5D9A12CF2BAEAB5E9935727693A4698`
- Before WPF composite PNG: 816x1056, SHA-256
  `1CE1C5F8A93AD407E78A68C684A10027A2DDD26FE76A34FD9525C232D94CE38E`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `4ED2EA4C7FDC891576D8081A65A988645C229B5DE844D91A53A9108871F9902E`
- Candidate provenance: `FreeW.FidelityRender`, `renderPath=composite`,
  `captureSource=wpf-composite-renderer`

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 4.9561% | 3.5498% | -1.4063 pp |
| Top border | 17.8990% | 12.6774% | -5.2216 pp |
| Bottom border | 18.6520% | 12.6448% | -6.0071 pp |
| Left border | 17.4085% | 12.4175% | -4.9911 pp |
| Right border | 19.5697% | 12.3594% | -7.2103 pp |
| Interior control | 0.7803% | 0.7803% | 0.0000 pp |

The accepted candidate restores Word's 102 upright rose motifs and measured source colors
(`#E96AD3`, `#1AB300`, `#A04991`). Remaining error is concentrated in fine curved-petal
antialiasing and one-pixel outline registration; document content is unchanged.

## Verification

- Focused shared planner contract: 1/1
- WPF decorative-border consumer source contract: 1/1
- Avalonia live/PDF consumer source contract: 1/1
- Flowers - Roses PDF composition/raster contract: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page
- Fresh WPF composite render: 1/1 page

## Process note

The rose is a layered physical motif, not a tintable line style. Preserve outline, petal,
leaf, vein, and bud ownership in the shared plan, then require whole-page and every edge ROI
to improve while the white interior control remains unchanged.
