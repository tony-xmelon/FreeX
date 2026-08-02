# FreeW Weaving Ribbon corner material band (2026-08-02)

## Scope

The outer two vertical `weavingRibbon` tiles use a nearly parallel white material
band in Word. FreeW used the tapered middle-rail polygon at every vertical position.
The shared planner now uses an 8-DIP parallel white band only for those two outer
tiles at each end of the left and right rails. The body-adjacent third tile and all
middle-rail polygons retain their accepted tapered geometry.

## Matched reference

- Fixture: `weave.docx`, SHA-256
  `23E2C2D434A13BB72B7B5EDFE0F70B759E273774377CBDA9B4887DED6ACB7DA5`
- Fresh Word COM PNG: 816x1056, SHA-256
  `FAA7D440418230B5839C5E913C38AE86C6CB94A08C4B443E33FCCF7C80869658`
- Before WPF composite PNG: 816x1056, SHA-256
  `EA6A69E2E3A4608512831E7D4590D2F0366EFD90CDF2E44C1618908529677CCE`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `9EFDF5A87D49A621C50D8140FEC359ADE7D26DEE9B26A06B5A4AF3425D953FB9`

The generated DOCX container hash changes with package timestamps, but the Word PNG
and before-candidate PNG exactly match the preceding accepted slice. Word COM exported
one document and one page, then quit its owned process cleanly.

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 5.777113% | 5.758008% | -0.019105 pp |
| Top band | 13.349361% | 13.268899% | -0.080462 pp |
| Bottom band | 11.873114% | 11.785451% | -0.087663 pp |
| Left rail | 11.418737% | 11.418737% | 0.000000 pp |
| Right rail | 11.442706% | 11.442706% | 0.000000 pp |
| Interior control | 0.573890% | 0.573890% | 0.000000 pp |

## Rejected probes

- Replacing every vertical white band with the parallel polygon improved top and
  bottom but regressed left/right by +0.087042/+0.191837 pp and whole by +0.000144 pp.
- Applying it to all three transition tiles improved whole by 0.033361 pp, but moved
  the body-adjacent left ROI by +0.000929 pp.

Both broader candidates were discarded. The accepted two-tile boundary keeps every
adjacent long-rail and interior control byte-stable.

## Verification

- `PageBorderArtVisualPlannerTests`: 19/19
- WPF decorative page-border consumer source contract: 1/1
- Avalonia live/PDF consumer and Weaving Ribbon PDF raster contracts: 2/2
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page

## Process note

Treat repeated border art as position-dependent material ownership when exact masks
show a different corner transition. Test the topology globally to identify its owner,
then narrow it to complete source tiles and require adjacent rail regions to remain
byte-stable.
