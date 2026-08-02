# FreeW Weaving Ribbon top-body white band (2026-08-02)

## Scope

Word's interior top-rail `weavingRibbon` tiles use a narrower, steeper white material
band than FreeW's generic horizontal stripe. The shared planner now uses the measured
10-DIP lower width, 8-DIP upper width, and 24-DIP traverse only for complete top-body
tiles with origins x=108 through x=684. The outer two tiles at each corner, bottom
rail, vertical rails, gray material, phase, and backing geometry stay unchanged.

## Matched reference

- Fixture: `weave.docx`, SHA-256
  `0CD03ADB0F5F13EF7BC8A6D10338D764B7CA1B38F182BC318A70752C1DBBDB16`
- Fresh Word COM PNG: 816x1056, SHA-256
  `059674291F0125C3DCF29E12CDA9B862E15A79C07FCF51024E7347EAAF55DFB4`
- Before WPF composite PNG: 816x1056, SHA-256
  `117653738EB2AEED6774BE7D0AF302057D5D050D2BC0995D973AD38C4A610FEA`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `B2DBBB638060A2D44EEE35E8D47E396A00C3B6A77E2A04442700443CF73B370A`

Word COM exported one document and one page from the exact fixture and quit its owned
process cleanly. The candidate used the rebuilt Release WPF composite renderer.

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 5.734815% | 5.693848% | -0.040967 pp |
| Top border | 19.065557% | 18.427153% | -0.638404 pp |
| Top-rail body | 34.205004% | 32.390593% | -1.814411 pp |
| Bottom border | 19.694110% | 19.694110% | 0.000000 pp |
| Left rail | 18.788114% | 18.788114% | 0.000000 pp |
| Right rail | 18.964877% | 18.964877% | 0.000000 pp |
| Top-left corner control | 49.036267% | 49.036267% | 0.000000 pp |
| Top-right corner control | 50.693934% | 50.693934% | 0.000000 pp |
| Interior control | 0.573890% | 0.573890% | 0.000000 pp |

## Rejected probes

- Applying the geometry to both horizontal rails improved whole/top, but regressed
  the bottom border by 0.200866 pp.
- Applying it through the tile at x=716 regressed the top-right corner control by
  0.685509 pp. Tightening the end predicate to x=716 kept that tile unchanged.

## Verification

- `PageBorderArtVisualPlannerTests`: 19/19
- WPF decorative page-border consumer source contract: 1/1
- Avalonia live/PDF consumer and Weaving Ribbon PDF contracts: 2/2
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page

## Process note

Resolve repeated-art ownership at complete tile boundaries. A geometry change that
helps one rail is not transferable to its paired rail or corner tiles without their
own ROI evidence; preserve those regions exactly and calibrate only complete tiles in
the measured owner interval.
