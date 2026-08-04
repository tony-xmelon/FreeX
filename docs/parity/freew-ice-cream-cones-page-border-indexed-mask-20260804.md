# FreeW Ice Cream Cones page-border indexed mask (2026-08-04)

## Scope

The imported Word `iceCreamCones` page border (art ID 5) already used the
correct 32-DIP cadence, but represented each cone with five broad polygons. The
shared planner now consumes a measured 12-entry indexed palette mask for Word's
repeating 32x32 sprite. WPF and Avalonia/PDF retain one shared plan.

## Provenance

- Fixture: `cones.docx`, SHA-256
  `E6BDD7536BCB65A7B0422375ECF091FF158DCD7440B045FE2706791688B6FB9B`.
- Word COM PNG: 816x1056, SHA-256
  `B40D520A2A2B7DC372E6A780FB54B873BA3ED5DC640C8B9C87A225DC4B5A060D`.
- FreeW path: rebuilt Release `FreeW.FidelityRender --composite`, 816x1056.
- Current-main PNG: SHA-256
  `63A2948F6F06F906C92160C00444A9CA65B08C1E36C5D9734F673DC4E5D955F4`.
- Candidate PNG: SHA-256
  `1494C1C5E39CC402AD2BB46E99EC9605909C8F0BBED116145B8D4E341A935B05`.

## Results

Mean RGB absolute-difference percentages against the same Word PNG:

| Region | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Whole page | 1.5720% | 0.9314% | -0.6406 pp |
| Top rail | 7.0557% | 2.7564% | -4.2994 pp |
| Bottom rail | 7.1663% | 2.8323% | -4.3340 pp |
| Left rail | 6.3285% | 2.8401% | -3.4884 pp |
| Right rail | 6.1132% | 2.9902% | -3.1229 pp |
| First 32x32 motif | 9.6459% | 0.8093% | -8.8366 pp |
| Interior control | 0.6734% | 0.6734% | 0.0000 pp |

The post-test consuming-artifact rebuild produced the same candidate PNG hash.

## Cross-route controls

A same-artifact render confirmed every previously accepted mask route byte-for-byte:

- Birds Flight: `BA2D2C5E834D23B53408CD5F764DD34D9D5BAE013CADA56AA21FEE3B5D58E854`.
- Cake Slice: `6500144049ED415DE1DB10A1EF28EFF09F9381E664B929931CC656A2426A9A14`.
- Painted Eggs: `B9758DDE620851824202A4F3F228768A523B6903EADD41EC0B0C5F606E7DCFA5`.
- Weaving Ribbon: `11E13F6A385FCC819535A7AF38091623F81D418AF7229DC7CF232B782B922D17`.
- Flowers Roses: `7CCFE2FE042AD5650C6C4803A92CC2461B15AFB479A9D69A7292F8E41CFBC199`.
- Maple Muffins: `951C77A9A363831373FB8BECF1625635E518EB882F75DD53FEC14E8CDC571E07`.

## Verification

- Shared page-border planner contracts: 19/19.
- Avalonia direct-PDF mask-route contracts: 7/7.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Fresh isolated Word COM export: 1/1 document, 1/1 page; owned Word exited.

## Process rule

Treat border placement and motif raster as separate owners. When Word and FreeW
already agree on rail cadence, preserve the frame and measure only one canonical
tile. Accept the sprite only when the motif, every rail, and whole page improve,
the interior remains exact, and all existing mask-route hashes stay unchanged.
