# FreeW Vine page-border corner sprites (2026-08-04)

## Scope

After the Vine rail sprite was matched, the remaining isolated corner residual came
from a symmetric five-polygon approximation. Word uses four separately registered
32-by-32 raster orientations. The shared Vine plan now expands those four compact
binary masks into fill runs. Accepted rail geometry and every non-Vine path remain
unchanged.

## Matched reference

- Fixture SHA-256: `0943128DEEDD7114AB7E791DA0F8A84D9A4CFE3428F3CE84D30C5752963D94D3`
- Fresh Word COM PNG SHA-256: `B8B9C308EFDD32260871E023F78720CC404BCEB0C812A82EF6B9F88C08EA4960`
- Before WPF composite PNG SHA-256: `19456E783CC700EF3F73E6FB9FF8E3277A22A528B89AA2DEC7E1E38235AE1553`
- Candidate WPF composite PNG SHA-256: `BD59A23C59E578AB54DBB5A936D4370CDD301BD0BF0108AEB300812434941299`
- Dimensions: 816x1056
- Candidate provenance: `FreeW.FidelityRender`, `renderPath=composite`,
  `captureSource=wpf-composite-renderer`

The regenerated Word target is byte-identical to the accepted rail slice target,
confirming stable Word COM provenance after the prior probe corpus was cleaned.

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 2.7334% | 2.6374% | -0.0959 pp |
| Top border | 6.8539% | 5.7368% | -1.1171 pp |
| Bottom border | 18.4399% | 17.3148% | -1.1251 pp |
| Top-left corner | 23.9181% | 4.3382% | -19.5799 pp |
| Top-right corner | 25.0015% | 4.3666% | -20.6350 pp |
| Bottom-left corner | 23.4053% | 3.9315% | -19.4738 pp |
| Bottom-right corner | 24.7400% | 3.7094% | -21.0306 pp |
| Accepted rail control | 5.2764% | 5.2764% | 0.0000 pp |
| Interior control | 0.5514% | 0.5514% | 0.0000 pp |

The side ROIs excluding corners are pixel-stable. Remaining corner delta is limited
to grayscale edge antialiasing around the binary silhouettes.

## Verification

- Focused Vine shared planner contract: 1/1
- Avalonia Vine direct-PDF composition/raster contract: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh WPF candidate render: 1/1

## Process note

Corner art is not necessarily one symmetric motif. Measure each orientation from the
same Word target, preserve the accepted rail as a byte-stable control, and gate all
four local ROIs plus the whole page before replacing a shared corner approximation.
