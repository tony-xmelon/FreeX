# FreeW People page-border parity (2026-08-02)

## Scope

The imported Word `people` page-border art (ArtId 84) previously used the generic
four-line fallback. The shared planner now owns separate black outline and white interior
polygons for each figure's head and body. WPF, Avalonia live rendering, Avalonia PDF
export, and the software fallback consume the same upright geometry.

## Matched reference

- Fixture: `people.docx`, SHA-256
  `1949C82DB507D52E495359054525333230494B500AF58A8EB635175DF12A213E`
- Word COM PNG: 816x1056, SHA-256
  `B1C965D76A7D855970787DF5851AC186B0FDDCC99A6B8F3D3FDFF51D0EE2C2A5`
- Before WPF composite PNG: 816x1056, SHA-256
  `3AD478379FDBE5BBD79D32C466A369C47B9F7087C67A68417BB9710175B70FA1`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `F8106621D622F0A176FA8F25BF0F681A09E7E9AB4CEDF455FF7475ADF23C1356`
- Candidate provenance: `FreeW.FidelityRender`, `renderPath=composite`,
  `captureSource=wpf-composite-renderer`

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 2.9001% | 1.8893% | -1.0108 pp |
| Top border | 11.2506% | 6.9842% | -4.2664 pp |
| Bottom border | 10.7792% | 7.1335% | -3.6458 pp |
| Left border | 10.3621% | 6.1985% | -4.1636 pp |
| Right border | 10.4389% | 6.1996% | -4.2393 pp |
| Interior control | 0.3826% | 0.3826% | 0.0000 pp |

The accepted candidate restores the 102 upright figures and preserves Word's white
interior over black outline ownership. Remaining error is concentrated in curved contour
antialiasing and fine limb registration; document content is unchanged.

## Verification

- `PageBorderArtVisualPlannerTests`: 17/17
- WPF decorative-border consumer source contract: 1/1
- Avalonia live/PDF consumer source contract: 1/1
- People PDF composition/raster contract: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page in 10.1 seconds
- Fresh WPF composite render: 1/1 page

## Process note

The white figure interior is a physical layer, not empty page background. Preserve that
ordered outline/interior ownership in the shared plan, then require whole-page and every
edge ROI to improve while the white interior control remains unchanged.
