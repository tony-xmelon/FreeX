# FreeW Painted Eggs page-border parity (2026-08-02)

## Scope

The imported Word `eggsBlack` page-border art (ArtId 66) previously used the generic
four-line fallback. The shared planner now owns an ordered nine-polygon approximation
of each upright painted egg: pedestal shadow, black shell, white interior, and six
mottled patches. WPF, Avalonia live rendering, Avalonia PDF export, and the software
fallback consume the same geometry.

## Matched reference

- Fixture: `eggs.docx`, SHA-256
  `7670A93C08604D6A53F4112B4F2AA5CC50E4D45ACD27EFD1689F381E9CD9CDCA`
- Word COM PNG: 816x1056, SHA-256
  `31F0800881946F8804D85EE5FBE44410B48A9A5881E336DFD9D588ADDB15D65B`
- Before WPF composite PNG: 816x1056, SHA-256
  `FAE1436FA018C734617F07A2D057D7AAC84932889A6C3B8673410084854FCCB1`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `6A015074637924E8CB07D3745D0BAFE34E731EFAFA191B44DD48F61A7CC0CB46`
- Candidate provenance: `FreeW.FidelityRender`, `renderPath=composite`,
  `captureSource=wpf-composite-renderer`

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 5.4440% | 4.7806% | -0.6635 pp |
| Top border | 19.2796% | 18.0889% | -1.1907 pp |
| Bottom border | 19.9197% | 17.7334% | -2.1863 pp |
| Left border | 18.8504% | 16.7747% | -2.0757 pp |
| Right border | 21.5146% | 16.6635% | -4.8511 pp |
| Interior control | 0.7551% | 0.7551% | 0.0000 pp |

The candidate replaces the missing artwork with the authored black-and-white object
cadence on all four edges. Remaining error is concentrated in Word's asymmetric shell
contour, fine mottling, and antialiasing; document content and the interior are unchanged.

## Verification

- `PageBorderArtVisualPlannerTests`: 14/14
- WPF decorative-border consumer source contract: 1/1
- Avalonia live/PDF consumer source contract: 1/1
- Painted Eggs PDF composition/raster contract: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page
- Fresh WPF composite render: 1/1 page

## Process note

The first accepted approximation must restore source semantics before fine raster
calibration. Preserve polygon order so the white shell masks the black outer silhouette,
then require every edge ROI and the whole page to improve while the interior remains
pixel-stable. Fine shell registration remains a later, separately gated refinement.
