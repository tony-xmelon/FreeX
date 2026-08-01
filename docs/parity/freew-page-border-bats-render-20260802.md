# FreeW Bats page-border visual parity (2026-08-02)

## Scope

- Canonical source: `w:pgBorders` with `w:val="bats"`, `w:sz="24"`,
  `w:space="24"`, and `w:offsetFrom="page"`.
- Model signature: `PageBorder.ArtId == 37`, `WidthPt == 3`, and `SpacePt == 24`.
- The shared planner owns the 32-DIP motif cadence and one measured concave wing polygon. WPF live
  view, print preview, FidelityRender, software evidence, Avalonia live view, and direct PDF consume
  the same point list.

## Reference provenance

- Exact source DOCX SHA-256: `2AFD3366C15A733167019CD7F230DD398065E2A6971F0C88989EB39E298289C1`.
- Microsoft Word PDF SHA-256: `8B73A0270901FDC03FB3328932513BF8DE3A1E6D2F44D8983D17F750EA57795A`.
- Word/FreeW raster dimensions: 816 x 1056 pixels at 96 DPI.
- Word PNG SHA-256: `4AF12380DCEEFCF1E396DF275D83552F2945BA0913E9C8453A6D2AD9BF15DA14`.
- Previous FreeW fallback PNG SHA-256: `8F7497E3389347071C5957DAC5A0239C2EF160ACA95F436B001D5AA7D18D7F7C`.
- Accepted FreeW candidate PNG SHA-256: `483BD1451904879E5ED2EB779B5A2CE12787EB9FC84C7E471F80DC4F40BE0BE2`.
- Readiness-polled Word COM completed the corpus export in 8.1 seconds and the preserved direct PDF
  export in 8.7 seconds. Both owned Word instances exited normally.

## Measured result

Mean absolute RGB channel difference from direct `(x,y)` pixel access against the same Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 3.8471% | 1.0598% | -2.7873 pp |
| Top edge | 9.2185% | 1.5583% | -7.6602 pp |
| Left edge | 9.1252% | 1.5884% | -7.5368 pp |
| Right edge | 9.1729% | 1.7390% | -7.4339 pp |
| Bottom edge | 9.2203% | 1.6188% | -7.6015 pp |
| Interior control | 0.7300% | 0.7300% | 0 changed pixels |

The accepted first-tile mask has the same dark-pixel bounds as Word (`x=35..59`, `y=40..55`) and
141 dark pixels versus Word's 147. The initial polygon had only 124 dark pixels; a bounded vertical
envelope refinement improved the whole page by a further 0.0944 percentage points and every edge.

## Verification and process rule

- Shared planner tests cover art-id dispatch, Word cadence, and the measured polygon.
- WPF source/consumer tests prove the live, preview, composite, and software paths use the shared plan.
- Avalonia tests prove both the live path and direct PDF emit filled bat paths instead of a line border.
- The actual Release FidelityRender consumer was rebuilt before each scored candidate.

For repeated monochrome border art, measure one exact Word tile first, reuse Word's established edge
cadence, and tune only the local mask envelope. Require all four edge ROIs and the whole page to improve,
with the interior control pixel-stable, before broad host verification.
