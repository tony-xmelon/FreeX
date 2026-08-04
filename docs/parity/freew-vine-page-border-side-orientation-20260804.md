# FreeW Vine page-border side orientation (2026-08-04)

## Scope

After the shared Vine rail and corner sprites were matched, the remaining large
residual was isolated to the bottom and left rails. Word uses separately registered
sprite orientations on those sides; reflecting the top sprite reproduced neither
mask. The shared planner now uses measured bottom and left masks while preserving the
accepted top/right rails, four corners, cadence, and all non-Vine paths.

## Matched reference

- Fixture SHA-256: `244FC4AACE90F4AD2F436D32F1406A395DC9F6B037E74E108CD99C329A5521C1`
- Fresh Word COM PNG SHA-256: `B8B9C308EFDD32260871E023F78720CC404BCEB0C812A82EF6B9F88C08EA4960`
- Before WPF composite PNG SHA-256: `BD59A23C59E578AB54DBB5A936D4370CDD301BD0BF0108AEB300812434941299`
- Candidate WPF composite PNG SHA-256: `8B1E654AE9DAA44657FF46A82759B03BA33357DD6C1240E0F48C793DF733553B`
- Dimensions: 816x1056
- Candidate provenance: `FreeW.FidelityRender`, `renderPath=composite`,
  `captureSource=wpf-composite-renderer`

The regenerated Word PNG is byte-identical to both preceding Vine targets.

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 2.6374% | 1.3152% | -1.3222 pp |
| Bottom border | 17.3148% | 3.6621% | -13.6527 pp |
| Left border | 19.9357% | 5.5357% | -14.4000 pp |
| Bottom rail | 28.0568% | 5.5148% | -22.5420 pp |
| Left rail | 26.7886% | 5.1338% | -21.6548 pp |
| Top rail control | 5.2764% | 5.2764% | 0.0000 pp |
| Right rail control | 8.3649% | 8.3649% | 0.0000 pp |
| Interior control | 0.5514% | 0.5514% | 0.0000 pp |

The top border improved slightly only where the corrected left rail joins its corner.
The accepted top/right rail crops and interior are pixel-stable.

## Verification

- Focused Vine shared planner contract: 1/1
- Avalonia Vine direct-PDF composition/raster contract: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh WPF candidate render: 1/1

## Process note

Do not infer side orientation from a visually symmetric border-art token. Extract the
effective mask in each local side coordinate system, preserve the measured repeat
cadence, and require the changed sides plus whole page to improve while opposite
sides and the body remain pixel-stable.
