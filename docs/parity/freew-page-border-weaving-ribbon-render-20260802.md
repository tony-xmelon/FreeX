# FreeW Weaving Ribbon page-border visual parity (2026-08-02)

## Scope

- Canonical source: `w:pgBorders` with `w:val="weavingRibbon"`, `w:sz="24"`,
  `w:space="24"`, and `w:offsetFrom="page"`.
- Model signature: `PageBorder.ArtId == 95`, `WidthPt == 3`, and `SpacePt == 24`.
- The shared plan owns four black 32-DIP rails, white weave bands, and measured `#C0C0C0`
  reverse-face polygons. WPF live/preview/composite/software and Avalonia live/direct-PDF paths consume
  the same fills and polygons.

## Reference provenance

- Exact source DOCX SHA-256: `666ED9A38C6889B68E75442B34D2B88E5A2FBE7F1B4B99F005F7FB9C2C8EF0B3`.
- Microsoft Word PDF SHA-256: `A51E9C8D1F6F48BC3081D693B83384EFB7B6794FE553D5E34E114980D5E526B7`.
- Word/FreeW raster dimensions: 816 x 1056 pixels at 96 DPI.
- Word PNG SHA-256: `059674291F0125C3DCF29E12CDA9B862E15A79C07FCF51024E7347EAAF55DFB4`.
- Previous FreeW fallback PNG SHA-256: `6D5C50D71FEA55EEAC485CE1D3060739D0257C3AF82BC13426043CE7C6705B6F`.
- Accepted FreeW candidate PNG SHA-256: `DB7B08C4CBF10AD4BDB49197DBFCAED4AD4E55193B1459002E83F10B31FBA174`.
- The five-style ranking corpus exported 5/5 Word references in 51.6 seconds. A separate preserved
  direct PDF export completed through readiness-polled COM and the owned Word process exited normally.

The same current-main fallback render ranked the next curated border targets as follows. These references
can be regenerated deterministically with `New-PageBorderArtProbe.ps1`; the scratch PNGs are not retained.

| Style | Whole page | Perimeter | Interior control |
| --- | ---: | ---: | ---: |
| Papyrus | 7.2516% | 18.0840% | 0.7706% |
| Weaving Ribbon | 6.7783% | 16.7159% | 0.8327% |
| Birds in Flight | 5.6322% | 13.6681% | 0.8244% |
| Painted Eggs | 5.4440% | 13.1677% | 0.8230% |
| People | 3.1136% | 7.0506% | 0.7582% |

## Measured result

Mean absolute RGB channel difference from direct `(x,y)` pixel access against the same Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 6.7783% | 5.9436% | -0.8347 pp |
| Top edge | 17.5845% | 13.5596% | -4.0249 pp |
| Left edge | 17.0716% | 15.8795% | -1.1921 pp |
| Right edge | 15.9953% | 15.0519% | -0.9434 pp |
| Bottom edge | 16.4539% | 14.0124% | -2.4415 pp |
| Interior control | 0.8327% | 0.8327% | 0 changed pixels |

The initial equal-width black/white approximation regressed the whole page to 7.2287%. Narrowing the
white band alone still regressed to 7.0936%. Exact-color inspection showed that the omitted `#C0C0C0`
reverse face owns 144 pixels per representative 32x32 top tile. Adding that layer and matching edge
orientation improved the page, while a bounded top-rail shift search isolated the final +12-DIP weave
phase needed to make every edge improve.

## Verification and process rule

- Shared planner tests assert rail registration, 220 planned polygons, palette, and phase.
- WPF source/consumer tests cover live view, print preview, FidelityRender, and software evidence.
- Avalonia tests cover the live geometry path and direct PDF fills/paths without a line fallback.
- The actual Release FidelityRender consumer was rebuilt before every scored candidate.

For multi-material border art, a two-color silhouette can be worse than the generic fallback even when
its outline looks plausible. Recover each exact-color physical layer and edge orientation first, then use
a bounded local phase search. Accept only after all edge ROIs and the whole page improve while the interior
remains pixel-stable.
