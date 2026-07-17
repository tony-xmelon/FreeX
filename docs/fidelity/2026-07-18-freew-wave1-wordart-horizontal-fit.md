# FreeW Wave1 WordArt Horizontal Fit

## Scope

Imported floating `textWave1` WordArt now fits its glyph run horizontally to the authored WordArt textbox in the WPF overlay. The glyph height and the shared curve model remain unchanged; ArchUp and inline WordArt stay on their existing paths.

## Word COM Evidence

Matching 816x1056 Word COM baseline: `wordart-watermark-stress.docx`, page 1.

| Metric | Before | After |
| --- | ---: | ---: |
| Whole page mean channel diff | 8.3685% | 8.3230% |
| Primary Wave1 ROI `(315,215)-(805,310)` | 31.2220% | 30.3788% |

The measured Word ink envelope was wider than the WPF glyph run. Uniform font scaling was rejected because it also expanded the glyph height and regressed the ROI. A horizontal transform, with scaled advances passed to the shared placement planner, improved both gates.

## Controls

`wordart-picture-watermark-layout.docx`, page 1, contains the imported ArchUp plus DrawingML-picture watermark path. Its current WPF PNG is byte-identical to the pre-slice control (`SHA-256 98D465EE4F3A6C93A71CD2D5A25A9B64FFCA610A0656D7E25C163DD1CB481496`).

Focused `FloatingOverlay_RendersWarpedWordArtWithContrastingTextAndFill` and `WordArtPlacementSourceGuardTests` passed 2/2. `FreeW.FidelityRender` Release build completed with 0 warnings and 0 errors.
