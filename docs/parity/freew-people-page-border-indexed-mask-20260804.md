# FreeW People page-border indexed mask (2026-08-04)

## Scope

The imported Word `people` page border (art ID 84) already used the correct
32-DIP cadence, but represented each figure with four broad outline/interior
polygons. The shared planner now consumes a measured grayscale 32x32 indexed
mask. Boundary-connected white pixels are transparent; enclosed white pixels
remain an explicit authored surface for colored-page correctness.

## Provenance

- Fixture: `people.docx`, SHA-256
  `5BB90BF5CF4C6B63D022DF33C61C0F9AC8ED55CD369A3122767231297EC57370`.
- Word COM PNG: 816x1056, SHA-256
  `D7398E4BD2D14FE2D6939567F8D76624A83E2D6AA6D9BFAB64D33EBA3CB166A9`.
- FreeW path: rebuilt Release `FreeW.FidelityRender --composite`, 816x1056.
- Current-main PNG: SHA-256
  `39659308B44FBB57FE67D23839A6EB135E38420E93DDA79EDA647108C9B7DBE3`.
- Candidate PNG: SHA-256
  `03D3110C7AEF220A0B4197866DB2EA3E49E240E66D39FCF1D40A2722B02C962C`.

## Results

Mean RGB absolute-difference percentages against the same Word PNG:

| Region | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Whole page | 2.0003% | 0.9870% | -1.0134 pp |
| Top rail | 9.8577% | 3.5631% | -6.2946 pp |
| Bottom rail | 9.9339% | 3.8193% | -6.1146 pp |
| Left rail | 8.9224% | 3.0539% | -5.8685 pp |
| Right rail | 8.9260% | 3.4165% | -5.5095 pp |
| First 32x32 motif | 13.4398% | 0.1478% | -13.2920 pp |
| Interior control | 0.5944% | 0.5944% | 0.0000 pp |

The post-test consuming-artifact rebuild produced the same candidate PNG hash.

## Cross-route controls

A same-artifact render confirmed every previously accepted mask route byte-for-byte:

- Birds Flight: `BA2D2C5E834D23B53408CD5F764DD34D9D5BAE013CADA56AA21FEE3B5D58E854`.
- Cake Slice: `6500144049ED415DE1DB10A1EF28EFF09F9381E664B929931CC656A2426A9A14`.
- Painted Eggs: `B9758DDE620851824202A4F3F228768A523B6903EADD41EC0B0C5F606E7DCFA5`.
- Weaving Ribbon: `11E13F6A385FCC819535A7AF38091623F81D418AF7229DC7CF232B782B922D17`.
- Flowers Roses: `7CCFE2FE042AD5650C6C4803A92CC2461B15AFB479A9D69A7292F8E41CFBC199`.
- Maple Muffins: `951C77A9A363831373FB8BECF1625635E518EB882F75DD53FEC14E8CDC571E07`.
- Ice Cream Cones: `1494C1C5E39CC402AD2BB46E99EC9605909C8F0BBED116145B8D4E341A935B05`.

## Verification

- Shared page-border planner contracts: 19/19.
- Avalonia direct-PDF mask-route contracts: 8/8.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Fresh isolated Word COM export: 1/1 document, 1/1 page; owned Word exited.

## Process rule

For outlined motifs whose white interior is a physical layer, do not discard all
white pixels as page background. Flood-fill boundary-connected white as
transparent and preserve enclosed white as an explicit material. Then require
target motif, every rail, and whole-page gains plus exact interior and established
route controls.
