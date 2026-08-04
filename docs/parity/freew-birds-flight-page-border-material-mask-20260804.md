# FreeW Birds Flight page-border material mask (2026-08-04)

## Scope

The imported Word `birdsFlight` page border (art ID 35) already had matching
frame cadence, but FreeW's symmetric polygon looked like a star rather than
Word's swept-wing bird. The shared planner now consumes a measured 32x32 mask
with source navy `#040750`, two antialias material levels, and transparency.
WPF and Avalonia/PDF use the same plan.

## Provenance

- Fixture: `birds.docx`, SHA-256
  `50B677FAAA32A1D5A902DB6C8B46E64D0A75339A209B9E2644791393BFCB97DF`.
- Word COM PNG: 816x1056, SHA-256
  `447FD3FD441AF6A8EC5CBB0B7C4B6A28C43022C966198951E80135C6E39813BE`.
- FreeW path: rebuilt Release `FreeW.FidelityRender --composite`, 816x1056.
- Current-main PNG: SHA-256
  `7E448F217D25A17CAB49C9DEB1588DA53EB2C807CB4E4B0EED867543C57D0173`.
- Candidate PNG: SHA-256
  `BA2D2C5E834D23B53408CD5F764DD34D9D5BAE013CADA56AA21FEE3B5D58E854`.

## Results

Mean RGB absolute-difference percentages against the same Word PNG:

| Region | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Whole page | 3.7401% | 1.2071% | -2.5330 pp |
| Top rail | 19.7424% | 3.0710% | -16.6714 pp |
| Bottom rail | 20.2156% | 3.3434% | -16.8722 pp |
| Left rail | 18.7181% | 5.4429% | -13.2752 pp |
| Right rail | 18.4085% | 5.5076% | -12.9009 pp |
| First 32x32 motif | 26.7558% | 0.9415% | -25.8143 pp |
| Interior control | 0.6468% | 0.6468% | 0.0000 pp |

The interior control is pixel-identical. Removing the obsolete polygon builder
after acceptance left the candidate PNG byte-identical.

## Cross-route controls

Adding the source-colored material-zero override preserved the existing mask
consumers byte-for-byte:

- Cake Slice: `6500144049ED415DE1DB10A1EF28EFF09F9381E664B929931CC656A2426A9A14`.
- Painted Eggs: `B9758DDE620851824202A4F3F228768A523B6903EADD41EC0B0C5F606E7DCFA5`.
- Weaving Ribbon: `11E13F6A385FCC819535A7AF38091623F81D418AF7229DC7CF232B782B922D17`.

## Verification

- Focused shared Birds Flight planner contract: 1/1.
- Focused Avalonia direct-PDF Birds Flight contract: 1/1.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Fresh isolated Word COM export: 1/1 document, 1/1 page; owned Word exited.

## Process rule

For monochrome border art, preserve the source foreground color and derive a
small set of composited edge levels from the actual Word tile. Accept only when
the silhouette, every edge, and whole page improve, the document interior is
unchanged, and all existing consumers of the shared material helper remain
byte-stable.
