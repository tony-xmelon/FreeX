# Primary Wave1 Phase Registration

## Scope

The imported floating `FreeW CONFIDENTIAL` WordArt is the exact 32-point
`GlowBlue` / `Wave1` signature in `wordart-watermark-stress.docx`. Raw
816-by-1056 Word pixels showed that its glyph wave moves upward through the
left-middle letters and downward through the right-middle letters, while WPF's
generic Wave1 traversal used the opposite vertical phase and tangent.

The shared placement plan remains unchanged. Only WPF flips the normalized
vertical phase and tangent for this exact signature before it paints its
glyphs. This is a text-path geometry correction, not a glyph scaling or a
general Wave1 change.

## Matched Evidence

Persistent Word baseline:
`C:\Users\ali\AppData\Local\Temp\FreeW-WordBaselineSurfaceRefresh-20260717`

Fresh WPF Release composite at 816 by 1056:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 7.4709% | 7.4654% | -0.0055 pp |
| Primary WordArt | 15.7949% | 15.7070% | -0.0879 pp |
| Tight glyph/core crop | 19.2822% | 19.1167% | -0.1655 pp |
| Secondary `Review Copy` WordArt | 7.4577% | 7.4577% | stable |

The independent `wordart-picture-watermark-layout` and
`drawing-objects-complex` WPF control PNGs are SHA-256 byte-identical to their
same-main baselines.

## Verification

- Focused `FloatingOverlay_UsesOuterOnlyGlowLayerForImportedWave1Signature`:
  1/1 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.

## Process Note

Raw glyph-band direction can identify a text-path phase defect even when the
generic amplitude is already calibrated. Keep phase, scale, and material-core
ownership separate; the prior vertical-scale probe remains rejected.
