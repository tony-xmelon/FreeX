# Imported GlowBlue Wave Text-Path Slope Probe Rejected

## Scope

`drawing-objects-complex.docx`, imported DrawingML `WordArt8`:

- text: `FreeW`
- fill: `#242424`
- glow: `#2E75B6`, 60% alpha, 8 DIP radius
- font: 30 pt
- warp: `a:prstTxWarp prst="textWave1"`

The matched Word reference is
`C:\Temp\FreeW-F2Corpus-20260731\word-baseline\word\drawing-objects-complex_p1.png`.

## Probe

The existing generic Wave1 planner produced a much shallower glyph envelope than Word. A WPF-only,
exact-signature probe replaced it with a descending placement (`CenterYNormalized = 0.30 + 0.10 * index`)
and doubled the inverse glyph rotation. The shared planner, other WordArt signatures, and Avalonia were
unchanged.

## Result

The candidate was rejected and reverted after rebuilding `FreeW.FidelityRender` Release and rendering the
same DOCX through the WPF composite path:

| Metric | Baseline | Candidate | Change |
| --- | ---: | ---: | ---: |
| Whole page raw mean channel delta | 16.8864 | 16.9104 | +0.0240 |
| WordArt ROI `(480,210)-(635,310)` raw mean channel delta | 31.4222 | 32.4244 | +1.0022 |
| Tight WordArt ROI `(492,220)-(618,285)` raw mean channel delta | 31.2781 | 33.1748 | +1.8967 |

Focused WPF contract `FloatingOverlay_UsesOuterOnlyGlowLayerForImportedFreeW30PointWave1Signature`
passed, and the consuming FidelityRender Release build completed with zero warnings and errors.

## Conclusion

The residual is not a scale, offset, or monotonic glyph-slope calibration. The remaining gap belongs to
Word's text-path geometry and glyph rasterization. Future work must preserve this exact source guard and
prove both the local WordArt ROI and whole page against the matching Word PNG before changing it.
