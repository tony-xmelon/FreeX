# FreeW Cake Slice middle-separator layer (2026-08-02)

## Scope

The imported `cakeSlice` motif's existing middle layer was painted bright pink even
though Word's corresponding diagonal band is predominantly black. The shared planner
now paints only that already-owned polygon black. Tile cadence, outer silhouette,
cream and upper-icing geometry, placement, and all unrelated page-border styles stay
unchanged.

## Matched reference

- Fixture: `cake.docx`, SHA-256
  `CFC1AF6C88C6147B2257208B863BB2AA149383FEC07DC917F2DD07B7777864F5`
- Fresh Word COM PNG: 816x1056, SHA-256
  `AFF136FEA2454DAF6D37D4703A3A9B4680753B7B13CD41C4C83CA576F91AA842`
- Before WPF composite PNG: 816x1056, SHA-256
  `FD5D3153FD2D771A2CD4BB3D54F5F3FFF86E5A7D54170DD9BEE8CB0113EBAA39`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `ECDE36A39B7B013EFE43CC5504DCC5041703EDC718C7C8F5E4E7E5826C318269`

Word COM exported one document and one page from the exact fixture and exited its
owned process cleanly. The candidate used the rebuilt Release WPF composite renderer.

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 4.353618% | 3.999092% | -0.354526 pp |
| Top border | 14.459033% | 13.147985% | -1.311048 pp |
| Bottom border | 13.793743% | 12.511352% | -1.282391 pp |
| Left border | 14.028732% | 12.723925% | -1.304807 pp |
| Right border | 14.012995% | 12.712244% | -1.300751 pp |
| Isolated top tile | 30.640319% | 27.743311% | -2.897008 pp |
| Interior control | 0.573890% | 0.573890% | 0.000000 pp |

## Verification

- `PageBorderArtVisualPlannerTests`: 19/19
- WPF decorative page-border consumer source contract: 1/1
- Avalonia live/PDF consumer and Cake Slice PDF contracts: 2/2
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page

## Process note

Treat a color-count mismatch as a layer-ownership clue, then alter the smallest
existing layer rather than adding a broad overlay. Accept only when the isolated tile,
all four edge regions, and the whole page improve while interior content stays stable.
