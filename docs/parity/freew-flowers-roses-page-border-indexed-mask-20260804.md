# FreeW Flowers Roses page-border indexed mask (2026-08-04)

## Scope

The imported Word `flowersRoses` page border (art ID 38) used thirteen broad
polygons per motif. Word's 32x32 sprite contains thin neutral linework, multiple
petal and leaf tones, and composited edges. The shared planner now consumes a
measured 12-entry indexed palette mask; WPF and Avalonia/PDF use the same plan.

## Provenance

- Fixture: `roses.docx`, SHA-256
  `919F189001726327063B8C18E002C256EF517A7EA92B990CFDC9CF45416D7228`.
- Word COM PNG: 816x1056, SHA-256
  `EB26804B65545845BAAD267AE5EDF2C3BB36F425A1402DCBC788D35A508971B1`.
- FreeW path: rebuilt Release `FreeW.FidelityRender --composite`, 816x1056.
- Current-main PNG: SHA-256
  `5657F256102B6083CF9666DF16A5FF763E6A693FD46768FA3FA130F0B41FE468`.
- Candidate PNG: SHA-256
  `7CCFE2FE042AD5650C6C4803A92CC2461B15AFB479A9D69A7292F8E41CFBC199`.

## Results

Mean RGB absolute-difference percentages against the same Word PNG:

| Region | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Whole page | 3.4795% | 1.6375% | -1.8420 pp |
| Top rail | 17.8723% | 6.4165% | -11.4557 pp |
| Bottom rail | 17.7514% | 7.0316% | -10.7199 pp |
| Left rail | 17.5806% | 6.8436% | -10.7370 pp |
| Right rail | 17.5293% | 7.2696% | -10.2597 pp |
| First 32x32 motif | 24.9362% | 1.8344% | -23.1018 pp |
| Interior control | 0.6586% | 0.6586% | 0.0000 pp |

The interior control is pixel-identical. Removing the obsolete polygon builder
after acceptance left the candidate PNG byte-identical.

## Cross-route controls

The new indexed-palette helper is separate from the existing compact
four-material helper. A same-artifact control render nevertheless confirmed all
accepted routes byte-for-byte:

- Birds Flight: `BA2D2C5E834D23B53408CD5F764DD34D9D5BAE013CADA56AA21FEE3B5D58E854`.
- Cake Slice: `6500144049ED415DE1DB10A1EF28EFF09F9381E664B929931CC656A2426A9A14`.
- Painted Eggs: `B9758DDE620851824202A4F3F228768A523B6903EADD41EC0B0C5F606E7DCFA5`.
- Weaving Ribbon: `11E13F6A385FCC819535A7AF38091623F81D418AF7229DC7CF232B782B922D17`.

## Verification

- Focused shared Flowers Roses planner contract: 1/1.
- Focused Avalonia direct-PDF Flowers Roses contract: 1/1.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Fresh isolated Word COM export: 1/1 document, 1/1 page; owned Word exited.

## Process rule

Use compact semantic masks for motifs with a few authored materials, but admit an
indexed palette when the Word raster demonstrably contains several independent
source and edge layers. Keep it fixture-scoped and require target motif, every
edge, and whole-page gains plus exact interior and established-route controls.
