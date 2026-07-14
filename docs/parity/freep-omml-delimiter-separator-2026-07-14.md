# FreeP OMML Delimiter Separator - 2026-07-14

Scope: bounded shared FreeP math-layout evidence for PowerPoint-authored OMML delimiters that use `m:dPr/m:sepChr`.

## Coverage

- Parses absent `m:sepChr` as the OfficeMath comma separator for delimiters with two or more `m:e` elements.
- Preserves custom separator glyphs such as `|` in shared `MathNode.Delim` metadata.
- Preserves explicit empty `m:sepChr` as separator suppression, without reintroducing the default comma.
- Carries separator glyph decisions through `MathBoxRenderPlanner`, so WPF and Avalonia consume the same glyph plan without renderer-local delimiter policy.

## Verification

- `OmmlParserTests.Delim_WithTwoElements_NoSepChr_DefaultsToComma`
- `OmmlParserTests.Delim_WithTwoElements_ExplicitSepChr_UsesThatChar`
- `OmmlParserTests.Delim_WithExplicitEmptySepChr_HasNoSeparatorGlyph`
- `MathLayoutEngineTests.Delim_TwoElements_ExplicitPipeSepChr_RendersPipeBetweenElements`
- `MathLayoutEngineTests.Delim_TwoElements_DefaultSepChr_RendersComma`
- `MathLayoutEngineTests.Delim_SingleElement_NoSeparatorGlyph`
- `MathLayoutEngineTests.Delim_TwoElements_ExplicitEmptySepChr_NoSeparatorGlyph`
- `SlideCanvasMathBaselineTests.RenderParaWithMath_DelimiterSeparator_UsesSharedSeparatorPlan_DoesNotThrow` in WPF and Avalonia test projects.

## Remaining

This is shared structural/render-plan evidence only. It does not claim PowerPoint-authoritative math visual parity, exact Cambria Math separator spacing, or complete OfficeMath delimiter typography without COM-backed PowerPoint baselines.
