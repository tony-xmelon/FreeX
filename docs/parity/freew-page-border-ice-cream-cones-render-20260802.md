# FreeW Ice Cream Cones page-border parity (2026-08-02)

## Scope

The imported Word `iceCreamCones` page-border art (ArtId 5) previously used the generic
four-line fallback. The shared planner now owns one upright five-layer cone per Word
placement. WPF, Avalonia live rendering, Avalonia PDF export, and the software fallback
consume the same black outline, brown cone, pink band, and yellow scoop geometry.

## Matched reference

- Fixture: `cones.docx`, SHA-256
  `51F1D4693A1FBA5CC57EA93D532ABFC525150F40D43AB1B5A48CAF230463218A`
- Word COM PNG: 816x1056, SHA-256
  `E82C9A779D9728F1A20E62652E9414E22B93CA495B76684D507BC664F64A30FE`
- Before WPF composite PNG: 816x1056, SHA-256
  `15767B2187CF1DD4D1768C9CE1299C1216B546853DEDCAD61525E725AA534692`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `80A1066C04517AE539BE0677B7E77C3CA6108267BC4F0ED3C059CD7D4089DBED`
- Candidate provenance: `FreeW.FidelityRender`, `renderPath=composite`,
  `captureSource=wpf-composite-renderer`

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 3.3811% | 1.4235% | -1.9577 pp |
| Top border | 12.1018% | 5.0449% | -7.0569 pp |
| Bottom border | 13.3004% | 5.0598% | -8.2406 pp |
| Left border | 12.4876% | 4.3778% | -8.1098 pp |
| Right border | 12.4791% | 4.2275% | -8.2516 pp |
| Interior control | 0.4000% | 0.4000% | 0.0000 pp |

The accepted candidate restores Word's exact dominant source colors (`#FFFF80`,
`#FF80FF`, and `#604020`), upright orientation, and 102-object frame cadence. Remaining
error is concentrated in curved scoop/cone antialiasing; body content is unchanged.

## Verification

- `PageBorderArtVisualPlannerTests`: 16/16
- WPF decorative-border consumer source contract: 1/1
- Avalonia live/PDF consumer source contract: 1/1
- Ice Cream Cones PDF composition/raster contract: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page in 7.8 seconds
- Fresh WPF composite render: 1/1 page

## Process note

This source uses one upright object per 32-DIP art tile, so the existing Word cadence is
the authoritative layout. Measure exact dominant colors and layer ownership, then require
whole-page and all-edge ROI gains plus an unchanged interior before acceptance.
