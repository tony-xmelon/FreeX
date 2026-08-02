# FreeW Painted Eggs mottle scale (2026-08-02)

## Scope

The imported Word `eggsBlack` border uses six small irregular black mottles inside
each white egg. FreeW preserved their topology but painted the initial approximation
at the full traced polygon size, making every egg materially too dark. The shared
planner now contracts only those six patch polygons to 70% around each patch centroid.
Cadence, shell, white interior, pedestal, and placement remain unchanged.

## Matched reference

- Fixture: `eggs.docx`, SHA-256
  `8DE0BCF280D02636B5649CE0448F4FC53081A2BE12D79184116387CB86D92D36`
- Fresh Word COM PNG: 816x1056, SHA-256
  `E592B57C4722541EE45028570A0FD88F9E17CD6232AF37D78A852C836308D6CD`
- Before WPF composite PNG: 816x1056, SHA-256
  `B461D3814E6070FF8E4D1043B580CD6E62C040D479B38E44F524266B8BC51E25`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `8E772DFCE325117B4DC310C3D9C09399A072C2116C8550D018D00522A0B6B81F`

The fresh Word COM run exported one document and one page, then closed its read-only
document and quit the owned Word process.

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 4.801899% | 4.622502% | -0.179396 pp |
| Top border | 11.737781% | 11.285824% | -0.451958 pp |
| Bottom border | 9.775940% | 9.368532% | -0.407407 pp |
| Left border | 9.126634% | 8.766084% | -0.360550 pp |
| Right border | 8.861680% | 8.502908% | -0.358772 pp |
| Isolated top egg | 27.682329% | 26.712099% | -0.970230 pp |
| Interior control | 0.573890% | 0.573890% | 0.000000 pp |

The isolated top motif's near-black count moved from 391 to 286 pixels; Word has 204.
The remaining excess is concentrated in the separately owned shell and pedestal, so
the patch scale is accepted without erasing authored mottling.

## Verification

- `PageBorderArtVisualPlannerTests`: 19/19
- WPF decorative page-border consumer source contract: 1/1
- Avalonia live/PDF consumer and Painted Eggs PDF raster contracts: 2/2
- Avalonia PDF black-ink contract tightened to the measured 285-300 pixel interval
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page

## Process note

Separate repeated-art material layers before changing frame geometry. Use an isolated
motif's ink and near-black counts to identify overdraw, then require every edge ROI and
the whole page to improve with the document interior byte-stable. Leave shell thickness
and placement for independent source-owner slices.
