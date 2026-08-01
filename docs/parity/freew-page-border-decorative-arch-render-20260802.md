# FreeW Decorative Arch page-border visual parity (2026-08-02)

## Scope

- Canonical source: `w:pgBorders` with `w:val="decoArch"`, `w:sz="24"`,
  `w:space="24"`, and `w:offsetFrom="page"`.
- Model signature: `PageBorder.ArtId == 89`, `WidthPt == 3`, and `SpacePt == 24`.
- The shared planner owns measured 21-DIP striped rails and four 32-DIP corner tiles. Each
  corner is built from one black surface plus four layered cubic arch strokes.

## Reference provenance

- Exact source DOCX SHA-256: `4A9558C2CE457E909E81A621D8751593D306529C675BE944FEF4D0164F0B3E2D`.
- Microsoft Word PDF SHA-256: `C1E00C38AE1801C993787F420FA947C3FCC3192380F52E3D314678B0ABD1557B`.
- Word/FreeW raster dimensions: 816 x 1056 pixels at 96 DPI.
- Word PNG SHA-256: `66E4F07A5B4445949484092EFABB0FF75FB0E813666888098B546345F6B96069`.
- Previous FreeW fallback PNG SHA-256: `7B4C3B902104CC94AE374D354440A08D9D3622F89C042EED778CE5525DDBA53B`.
- Accepted FreeW candidate PNG SHA-256: `3E4E76388BC532F1C8FC88F43373EA3601DE49890312B38EE72731E23EF7196D`.
- The corpus tool created the exact package at a short path. Readiness-polled Word COM exported
  the hidden direct PDF in under five seconds and exited cleanly.

## Measured result

Mean absolute RGB channel difference from direct pixel coordinates against the same Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 6.8217% | 0.6366% | -6.1851 pp |
| Perimeter excluding interior | 19.9593% | 0.5021% | -19.4572 pp |
| Top edge | 18.8020% | 0.8922% | -17.9098 pp |
| Left edge | 20.7812% | 0.8073% | -19.9739 pp |
| Right edge | 20.8013% | 0.8147% | -19.9866 pp |
| Bottom edge | 17.3842% | 1.1989% | -16.1853 pp |
| Interior control | 0.6993% | 0.6993% | 0 changed pixels |

The previous fast lock-bits scorer assumed a row ordering that was not valid for this asymmetric
fixture. These values use direct `(x,y)` pixel access; source, dimensions, and capture paths match.

## Verification and process rule

- `New-PageBorderArtProbe.ps1` now creates deterministic canonical art-border packages, accepting
  model points and converting them to eighth-point `w:sz` values.
- WPF live view, print preview, FidelityRender, and software evidence consume the shared plan.
- Avalonia live view and direct PDF consume the same fills and cubic strokes and omit the line fallback.
- Focused planner, WPF, Avalonia/PDF, and corpus-tool contracts plus Release consumer builds are the
  merge gate.

For continuous decorative art, decompose the Word raster into physical stripe surfaces and corner
paths before approximating it as repeated motifs. Validate metric tools against asymmetric content,
retain exact source/PDF/PNG hashes, and require all four edges plus whole page to improve while the
interior remains pixel-stable.
