# FreeW Weaving Ribbon vertical phase registration (2026-08-02)

## Scope

The imported Word `weavingRibbon` page border already had the correct 32-DIP rail
width, cadence, colors, and horizontal registration. Its two long vertical rails
used the same zero phase, while Word starts the left and right motifs at different
phases. The shared page-border planner now applies the measured phases only between
complete motif boundaries at y=128 and y=928. The top, bottom, corners, and document
interior retain their previous geometry.

## Matched reference

- Fixture: `weave.docx`, SHA-256
  `DC4791D2D659637FCC8CDE57ACA380DFCCF82DC328E089D1E8D81EFB0F32106A`
- Fresh Word COM PNG: 816x1056, SHA-256
  `FAA7D440418230B5839C5E913C38AE86C6CB94A08C4B443E33FCCF7C80869658`
- Before WPF composite PNG: 816x1056, SHA-256
  `C00A26E280575A9DD9330CC0022234E8DBC589E4C1437B515E74B60E1A2BDD02`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `7D0B387C88435706EACFCF14D56957EA6E155733E1B3F46DADB8FF613081EE2C`
- Candidate provenance: `FreeW.FidelityRender`, `renderPath=composite`,
  `captureSource=wpf-composite-renderer`

The Word automation run completed one document and one page in 6.2 seconds, then
quit its owned Word process cleanly.

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 5.966745% | 5.829527% | -0.137218 pp |
| Top band | 13.349361% | 13.349361% | 0.000000 pp |
| Bottom band | 11.873114% | 11.873114% | 0.000000 pp |
| Left rail | 12.618452% | 11.879986% | -0.738466 pp |
| Right rail | 11.911757% | 11.442706% | -0.469050 pp |
| Interior control | 0.573890% | 0.573890% | 0.000000 pp |

The left rail uses a periodic +8-DIP phase and the right rail uses the equivalent
-11-DIP phase. The split points are complete 32-DIP motif boundaries, avoiding
clipped antialias seams and preserving the horizontal/corner owners exactly.

## Rejected probes

- Applying the phases to each full vertical rail improved the long-rail ROIs but
  regressed the top and bottom bands by +0.467765 and +0.650855 pp.
- Preserving only the 32-DIP corner tiles still created a clipping seam and moved
  the bottom band by +0.027113 pp.

Both probes were discarded. Phase correlation is diagnostic until corner, adjacent,
and whole-page gates also pass.

## Verification

- Focused `WeavingRibbon_UsesContinuousRailsAndAlternatingDiagonalStripes`: 1/1
- WPF decorative page-border consumer source contract: 1/1
- Avalonia live/PDF consumer and Weaving Ribbon PDF raster contracts: 2/2
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page

## Process note

Cross-correlate periodic edges independently, then constrain a phase correction to
the measured owner region. Preserve complete motif boundaries at transitions and
require target rails plus whole-page improvement with top, bottom, and interior
controls byte-stable.
