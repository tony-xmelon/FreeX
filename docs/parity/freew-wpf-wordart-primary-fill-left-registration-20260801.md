# FreeW WPF primary WordArt fill left registration (2026-08-01)

## Scope

The imported `FreeW CONFIDENTIAL` WordArt uses an exact WPF compositor path for the `GlowBlue`,
`Wave1`, 32-point signature. Its dark fill surface began one output pixel to the right of Word while
the right edge was already aligned. The WPF-only fill layer now extends one DIP farther left and one
DIP wider, preserving its existing top, bottom, and right edges. Glyph placement, glow layers, object
anchor, shared planning, Avalonia, and every other WordArt signature are unchanged.

## Provenance

- Fixture SHA-256: `B440981BA284A29A425A4A2BF199C365ECC101458A173A05AFD1ED6F7130B549`
- Word 16: isolated visible COM `ExportAsFixedFormat`, short flat PDF staging path
- Word PNG: 816x1056, SHA-256
  `08FC07DB49E17BDCB9C6841905F34DE6E5767EFFA228C97BB94914786645EB2B`
- Baseline FreeW PNG SHA-256:
  `5F2815FE8CC543113942D5EBC452E41570F6FF6116422452BF779538C059BDB8`
- Candidate FreeW PNG SHA-256:
  `5BB23C1C3AFD90ABD7DC902A6ECAAC0C2A232B7FB9EB96965D0C9A719114A479`

Word COM completed create, ready, open, export, close, and owned-process quit in about four seconds;
the complete export and raster operation finished in 7.5 seconds.

## Evidence

Mean absolute RGB channel delta against the matching Word PNG:

| Region | Before | After | Change |
|---|---:|---:|---:|
| Whole page | 4.2071% | 4.1852% | -0.0218 pp |
| Banner broad | 5.2198% | 4.9393% | -0.2805 pp |
| Banner panel | 6.7994% | 6.3952% | -0.4042 pp |
| Glyph crop | 7.3360% | 6.7637% | -0.5723 pp |
| Top glow | 2.1676% | 2.1671% | -0.0005 pp |
| Bottom edge band | 5.2377% | 5.2379% | +0.0001 pp |
| Review Copy | 4.4226% | 4.4226% | byte-stable |
| Lower body flow | 7.4946% | 7.4946% | byte-stable |

The bottom-band movement affects 0.07% of that crop and is below the 0.001 pp adjacent-region
quantization bound. All candidate pixels remain inside the primary banner neighborhood.

## Rejected vertical probe

A first probe also extended the fill one DIP upward while preserving its bottom edge. It improved the
whole page to 4.1940% and the banner to 5.0521%, but regressed the top-glow band from 2.1676% to
2.9313%. That vertical portion was removed. A more aggressive fill-height reduction was also rejected
(`4.2071% -> 4.3139%` whole page) because the canvas and blurred backing layer still own the dark
surface below the fill layer.

## Verification

- Focused WPF contracts: 2/2
- `FloatingObjectRenderTests` and `WordArtPlacementSourceGuardTests`: 26/26
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Exact candidate render: 1/1 page
- Word COM export: 1/1 document, clean owned-process exit

## Process rule

For layered WordArt effects, inspect full row bands and score each adjacent physical layer. A matching
global color bbox can hide disconnected antialias pixels, and changing only one overlapping fill layer
cannot correct a surface also owned by the canvas or blurred backing layer.
