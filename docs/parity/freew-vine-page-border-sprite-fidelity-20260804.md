# FreeW Vine page-border sprite fidelity (2026-08-04)

## Scope

Word renders the imported `vine` page-border token (ArtId 47) as a fixed
48-by-32 monochrome sprite. FreeW previously approximated the repeated rail with
four broad polygons, producing the right cadence but a materially different stem
and leaf silhouette. The shared planner now expands a compact binary sprite mask
into fill runs. WPF, Avalonia live rendering, Avalonia PDF export, and the software
fallback continue to consume the same plan. Corner ownership is unchanged.

## Matched reference

- Fixture SHA-256: `CDB4D7EE11B76040163F0686258ABE00D1EFBFE162A70AB8B95B6297CF0FE989`
- Fresh Word COM PNG SHA-256: `B8B9C308EFDD32260871E023F78720CC404BCEB0C812A82EF6B9F88C08EA4960`
- Before WPF composite PNG SHA-256: `907236B97283220167141A8E05FCCE0692BC7D1E0B7D5E8FB2FE7C4C4CE6F84E`
- Candidate WPF composite PNG SHA-256: `19456E783CC700EF3F73E6FB9FF8E3277A22A528B89AA2DEC7E1E38235AE1553`
- Dimensions: 816x1056
- Candidate provenance: `FreeW.FidelityRender`, `renderPath=composite`,
  `captureSource=wpf-composite-renderer`

The Word export used isolated visible Word COM with short input/output paths. Word
opened the exact fixture read-only, exported the PDF, closed the document, and quit
its owned process cleanly.

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 3.9935% | 2.7334% | -1.2601 pp |
| Top border | 18.1057% | 6.8539% | -11.2519 pp |
| Bottom border | 20.7128% | 18.4399% | -2.2728 pp |
| Left border | 22.1826% | 19.9357% | -2.2469 pp |
| Right border | 16.7953% | 5.6270% | -11.1683 pp |
| Representative top cell | 23.9093% | 3.1327% | -20.7767 pp |
| Corner control | 23.9181% | 23.9181% | 0.0000 pp |
| Interior control | 0.5514% | 0.5514% | 0.0000 pp |

The remaining error is concentrated in the unchanged flower corners, side-specific
antialiasing, and the binary threshold at curved leaf edges. A coarse vector probe
was rejected first because it regressed the whole page from 3.9935% to 4.2869%.

## Verification

- `PageBorderArtVisualPlannerTests`: 19/19
- Avalonia Vine direct-PDF composition/raster contract: 1/1
- WPF visual-evidence source contracts: 22/22
- Avalonia live/PDF visual-evidence source contracts: 16/16
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh WPF candidate render: 1/1

## Process note

When a Word border-art residual has correct rail placement and repeat cadence but
the wrong silhouette, first identify whether the source is a fixed sprite. Preserve
the measured cadence and model only the sprite mask; require all four edge ROIs and
the whole page to improve while corner and interior controls remain pixel-stable.
