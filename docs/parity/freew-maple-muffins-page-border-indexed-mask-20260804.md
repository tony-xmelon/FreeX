# FreeW Maple Muffins page-border indexed mask (2026-08-04)

## Scope

The imported Word `mapleMuffins` page border (art ID 2) already used Word's
32-DIP cadence, but each muffin was approximated by eight broad polygons. The
shared planner now consumes a measured 12-entry indexed palette mask for the
repeating 32x32 sprite. WPF and Avalonia/PDF continue to use the same plan.

## Provenance

- Fixture: `maple.docx`, SHA-256
  `787AAE2A1197426D41CF4983F6BF49B2310F3F410159BA89A55538B735DCBD95`.
- Word COM PNG: 816x1056, SHA-256
  `450078AE160BD3C1028BE18B3E49E68078FD81449C29F7C8D4CF0CEE42CC6D20`.
- FreeW path: rebuilt Release `FreeW.FidelityRender --composite`, 816x1056.
- Current-main PNG: SHA-256
  `5A672AE5B9A04E2D9587428D780BBFA3BF61D02BD64E92D95FB8B96A23034F27`.
- Candidate PNG: SHA-256
  `951C77A9A363831373FB8BECF1625635E518EB882F75DD53FEC14E8CDC571E07`.

## Results

Mean RGB absolute-difference percentages against the same Word PNG:

| Region | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Whole page | 2.6744% | 1.6025% | -1.0720 pp |
| Top rail | 13.2156% | 5.7072% | -7.5084 pp |
| Bottom rail | 13.2953% | 6.1526% | -7.1428 pp |
| Left rail | 12.9722% | 7.1528% | -5.8195 pp |
| Right rail | 12.8001% | 7.4161% | -5.3840 pp |
| First 32x32 motif | 18.1094% | 1.2537% | -16.8557 pp |
| Interior control | 0.6558% | 0.6558% | 0.0000 pp |

The post-test consuming-artifact rebuild produced the same candidate PNG hash.

## Cross-route controls

A same-artifact render confirmed all established mask routes byte-for-byte:

- Birds Flight: `BA2D2C5E834D23B53408CD5F764DD34D9D5BAE013CADA56AA21FEE3B5D58E854`.
- Cake Slice: `6500144049ED415DE1DB10A1EF28EFF09F9381E664B929931CC656A2426A9A14`.
- Painted Eggs: `B9758DDE620851824202A4F3F228768A523B6903EADD41EC0B0C5F606E7DCFA5`.
- Weaving Ribbon: `11E13F6A385FCC819535A7AF38091623F81D418AF7229DC7CF232B782B922D17`.
- Flowers Roses: `7CCFE2FE042AD5650C6C4803A92CC2461B15AFB479A9D69A7292F8E41CFBC199`.

## Verification

- Shared page-border planner contracts: 19/19.
- Avalonia direct-PDF mask-route contracts: 6/6.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Fresh isolated Word COM export: 1/1 document, 1/1 page; owned Word exited.

## Process rule

When a border's cadence and placement already match Word, preserve that frame and
replace only the motif owner with a measured sprite. Require the target motif,
every rail, and whole page to improve, the interior to remain exact, a fresh
consuming-artifact rerender to be byte-stable, and every established mask route
to retain its accepted hash.
