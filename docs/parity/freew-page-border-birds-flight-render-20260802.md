# FreeW Birds in Flight page-border parity (2026-08-02)

## Scope

The imported Word `birdsFlight` page-border art (ArtId 35) previously used the generic
four-line fallback. The shared planner now owns its repeated upright bird silhouette in
Word's measured navy `#040750`. WPF, Avalonia live rendering, Avalonia PDF export, and
the software fallback consume one polygon per source tile.

## Matched reference

- Fixture: `birds.docx`, SHA-256
  `B63E56D3D75AC99CB18C53002D2667FC35B6122976342C85C321D0E29E193C9E`
- Word COM PNG: 816x1056, SHA-256
  `E843FED51932108E887B0D9D2FF42B9D6358FB66B60DF7120F0909838A070A0C`
- Before WPF composite PNG: 816x1056, SHA-256
  `D9ED77BAC2807ECCDF0F304494C6B643281D6833015328D5264D535D0E30BC26`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `40ACEE18CA4DACCBC24878B1F69ECDF61FF3CA749EA2D9A0617BADE976489F6B`
- Candidate provenance: `FreeW.FidelityRender`, `renderPath=composite`,
  `captureSource=wpf-composite-renderer`

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 5.6322% | 3.8512% | -1.7810 pp |
| Top border | 22.0919% | 13.9562% | -8.1357 pp |
| Bottom border | 18.6952% | 14.3994% | -4.2958 pp |
| Left border | 21.0400% | 13.0137% | -8.0263 pp |
| Right border | 20.9421% | 12.7676% | -8.1745 pp |
| Interior control | 0.7563% | 0.7563% | 0.0000 pp |

The candidate restores the missing navy bird objects, exact tile count, and upright
orientation on every edge. Remaining error is concentrated in wing/body contour detail
and Word's edge antialiasing; body layout and text are unchanged.

## Verification

- `PageBorderArtVisualPlannerTests`: 13/13
- WPF decorative-border consumer source contract: 1/1
- Avalonia live/PDF consumer source contract: 1/1
- Birds in Flight PDF composition/raster contract: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page
- Fresh WPF composite render: 1/1 page

## Process note

The source has one dominant exact color and no edge-dependent rotation. That made a
single semantic silhouette per Word placement both the narrowest and most portable
fix. Preserve the authored color and cadence, then require whole-page and all-edge ROI
gains plus an unchanged interior before accepting the shared polygon.
