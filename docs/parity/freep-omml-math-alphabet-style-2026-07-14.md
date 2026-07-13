# FreeP OMML Math Alphabet Style Variants - 2026-07-14

Scope: bounded shared FreeP math-rendering slice for PowerPoint-authored OMML runs that combine `m:rPr/m:scr` with `m:rPr/m:sty`.

## Coverage

- `script` plus bold style maps ASCII letters to mathematical bold script glyphs.
- `fraktur` plus bold style maps ASCII letters to mathematical bold fraktur glyphs.
- `sans-serif` plus italic, bold, or bold-italic style maps ASCII letters to the matching mathematical sans-serif variant.
- Sans-serif bold digits map to mathematical sans-serif bold digits; styled alphabet variants with no Unicode digit block keep ordinary digits.
- Styled mathematical alphabet glyphs still clear renderer-local italic/bold metadata so WPF and Avalonia consume the same explicit Unicode glyph plan.
- Existing regular script, fraktur, double-struck, sans-serif, monospace, and roman behavior stays covered.

## Verification

- `MathLayoutEngineTests.Run_WithMathAlphabet_MapsAsciiGlyphsInSharedDrawPlan`
- `MathLayoutEngineTests.OmmlScrWithStyVariant_RenderPlanUsesStyledUnicodeMathGlyphs`
- `SlideCanvasMathBaselineTests.RenderParaWithMath_MathAlphabetStyleVariants_UseSharedUnicodeGlyphPlan_DoesNotThrow` in WPF and Avalonia test projects.

## Command Inventory

No generated FreeP command inventory update was made. This slice is shared OMML parsing/layout/render planning, not a command workflow surface.

## Remaining

This does not add PowerPoint COM visual baselines, exact font metric parity, or styled variants for math alphabet families that do not have distinct Unicode mathematical alphanumeric blocks.
