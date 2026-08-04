# FreeW Cake Slice page-border material mask (2026-08-04)

## Scope

The imported Word `cakeSlice` page border (art ID 3) already had matching
placement and cadence, but its five smooth polygons did not reproduce Word's
jagged crust, separators, icing, or edge raster. The shared planner now consumes
a measured 32x32 four-material mask: transparent, black, cream `#FFEECA`, and
pink `#FF99C2`. WPF and Avalonia/PDF use the same plan.

## Provenance

- Fixture: `cake.docx`, SHA-256
  `9D7710AF601D3BBA850F4F109989968BEF6415479887BB0A15485C71D267DFA8`.
- Word COM PNG: 816x1056, SHA-256
  `576949794A4A2B2CD8FB65144C58EFCAC7F2F5B7F4E0CF764C0BC9574EF576C7`.
- FreeW path: rebuilt Release `FreeW.FidelityRender --composite`, 816x1056.
- Current-main PNG: SHA-256
  `1AAB639A4D8559ABEFCA9BBC51A60A3244D36D98C6F86FC92F00275E610D12A2`.
- Candidate PNG: SHA-256
  `6500144049ED415DE1DB10A1EF28EFF09F9381E664B929931CC656A2426A9A14`.

## Results

Mean RGB absolute-difference percentages against the same Word PNG:

| Region | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Whole page | 3.8750% | 1.7245% | -2.1506 pp |
| Top rail | 19.7263% | 5.2808% | -14.4455 pp |
| Bottom rail | 19.0283% | 5.7518% | -13.2765 pp |
| Left rail | 20.5213% | 8.9204% | -11.6009 pp |
| Right rail | 20.4495% | 9.2080% | -11.2415 pp |
| First 32x32 motif | 27.7433% | 3.9611% | -23.7822 pp |
| Interior control | 0.6250% | 0.6250% | 0.0000 pp |

The interior control is pixel-identical. Removing the obsolete polygon builder
after acceptance left the candidate PNG byte-identical.

## Cross-route controls

Generalizing the shared material-mask helper from grayscale to RGB preserved the
two existing consumers byte-for-byte:

- Painted Eggs: `B9758DDE620851824202A4F3F228768A523B6903EADD41EC0B0C5F606E7DCFA5`.
- Weaving Ribbon: `11E13F6A385FCC819535A7AF38091623F81D418AF7229DC7CF232B782B922D17`.

## Verification

- Focused shared Cake planner contract: 1/1.
- Focused Avalonia direct-PDF Cake contract: 1/1.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Fresh isolated Word COM export: 1/1 document, 1/1 page; owned Word exited.

## Process rule

When a border-art object's cadence and position already match Word, preserve the
frame planner and replace only the motif owner. Quantize against semantic source
materials, then require whole-page and every-edge gains, an unchanged interior,
and byte-stable existing consumers of any generalized helper.
