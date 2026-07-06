# FreeP OMML Accent And Bar Parity

Date: 2026-07-06

## Scope

This slice strengthens shared WPF/Avalonia coverage for OMML accent and bar constructs:

- `m:acc` default and explicit `m:accPr/m:chr` parsing.
- `m:bar` default overline and `m:barPr/m:pos="bot"` underline parsing.
- Shared `MathLayoutEngine` placement of accent glyphs, overlines, and underlines.
- Avalonia headless rendering over the same `MathBoxRenderPlanner` glyph and horizontal-rule plan used by WPF.

No host-specific math layout policy was added.

## Evidence

- Parser coverage: `OmmlParserTests.Acc_WithNoChr_DefaultsToHatAndPreservesBase`
- Parser coverage: `OmmlParserTests.Acc_WithExplicitChr_UsesThatAccent`
- Parser coverage: `OmmlParserTests.Bar_WithNoPos_DefaultsToOverline`
- Parser coverage: `OmmlParserTests.Bar_WithBottomPos_UsesUnderline`
- Layout coverage: `MathLayoutEngineTests.Acc_WithExplicitAccent_PlacesAccentAboveBaseOnSharedLayout`
- Layout coverage: `MathLayoutEngineTests.Bar_OverlineAndUnderline_PositionHRuleAroundBase`
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_AccentAndBar_UseSharedMathBoxPlan_DoesNotThrow`

## Remaining Work

This is shared structural/render-plan parity evidence. Exact PowerPoint math typography, glyph metrics, and PowerPoint-authoritative visual baselines remain deferred until a COM-capable validation machine is available.
