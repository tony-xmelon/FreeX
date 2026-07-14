# FreeP OMML Math Alphabet Style - 2026-07-14

## Scope

This bounded FreeP slice promotes the existing shared WPF/Avalonia render-plan evidence for PowerPoint-authored OMML math runs that combine `m:rPr/m:scr` alphabet selection with `m:rPr/m:sty` bold, italic, and bold-italic style requests.

## Coverage

- Parses known `m:scr` values into `MathNode.MathAlphabet` metadata for roman, script, fraktur, double-struck, sans-serif, and monospace alphabets.
- Preserves `m:sty` plain, italic, bold, and bold-italic requests on math runs.
- Resolves supported styled alphabet combinations into mathematical Unicode glyphs in the shared `MathLayoutEngine` draw plan.
- Keeps unsupported styled alphabet combinations on ordinary glyphs with renderer-neutral style metadata instead of adding host-specific math policy.
- Carries the resulting `MathBoxRenderPlanner` glyph operations to both WPF and Avalonia baseline tests, so both hosts consume the same shared math layout.

## Verification

- Parser coverage: `OmmlParserTests.Run_WithScr_MapsKnownMathAlphabet`
- Parser coverage: `OmmlParserTests.Run_WithUnknownScr_UsesDefaultAlphabet`
- Parser coverage: `OmmlParserTests.Run_WithStyPlain_IsUprightAndNotBold`
- Parser coverage: `OmmlParserTests.Run_WithStyItalic_IsItalicAndNotBold`
- Parser coverage: `OmmlParserTests.Run_WithStyBold_IsUprightAndBold`
- Parser coverage: `OmmlParserTests.Run_WithStyBoldItalic_IsItalicAndBold`
- Layout/render-plan coverage: `MathLayoutEngineTests.Run_WithMathAlphabet_MapsAsciiGlyphsInSharedDrawPlan`
- Layout/render-plan coverage: `MathLayoutEngineTests.OmmlScrWithStyVariant_RenderPlanUsesStyledUnicodeMathGlyphs`
- Layout/render-plan coverage: `MathLayoutEngineTests.OmmlScrDoubleStruck_RenderPlanUsesUnicodeMathGlyphs`
- Layout/render-plan coverage: `MathLayoutEngineTests.Run_WithRomanAlphabet_PreservesExistingItalicAndBoldBehavior`
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_MathAlphabetStyleVariants_UseSharedUnicodeGlyphPlan_DoesNotThrow`
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_MathAlphabetStyleVariants_UseSharedUnicodeGlyphPlan_DoesNotThrow`

## Remaining

This is shared parser/layout/render-plan evidence only. It does not claim PowerPoint-authoritative math visual parity, exact Cambria Math glyph metrics, full mathematical alphabet coverage beyond the bounded Unicode mappings, or broader OfficeMath typography without COM-backed PowerPoint baselines.
