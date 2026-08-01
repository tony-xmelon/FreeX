# FreeP OMML Math Font - 2026-08-01

## Scope

This slice adds shared FreeP support for the equation-wide OMML
`m:mathPr/m:mathFont` semantic:

- The parser preserves a non-empty `m:mathFont` value on `MathNode.MathParagraph`.
- Shared layout resolves that value before recursively creating `MathBox` glyphs,
  while retaining the caller-provided font as the fallback for absent or empty
  metadata.
- WPF and Avalonia consume the same glyph font metadata through
  `MathBoxRenderPlanner`; no host-specific math-font policy was added.

## Verification

- Parser coverage: `OmmlParserTests.OMathPara_WithMathFont_PreservesEquationWideFontMetadata`
  and `OmmlParserTests.OMathPara_WithEmptyMathFont_UsesCallerFontFallback`.
- Layout/render-plan coverage:
  `MathLayoutEngineTests.OmmlParagraphMathFont_UsesEquationWideFontInSharedGlyphPlan`.
- WPF renderer coverage:
  `SlideCanvasMathBaselineTests.RenderParaWithMath_MathFont_UsesSharedGlyphFontPlan_DoesNotThrow`.
- Avalonia renderer coverage:
  `SlideCanvasMathBaselineTests.RenderParaWithMath_MathFont_UsesSharedGlyphFontPlan_DoesNotThrow`.

## Remaining

This is shared structural and render-plan evidence. It does not claim exact
PowerPoint-authoritative font fallback, Cambria Math metric parity, or support
for document-level math property inheritance beyond the `m:mathPr` attached to
the parsed math paragraph.
