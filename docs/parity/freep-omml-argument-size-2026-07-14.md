# FreeP OMML Argument Size - 2026-07-14

Scope: bounded shared FreeP math-layout slice for PowerPoint-authored OMML arguments that carry `m:argPr/m:argSz`.

## Coverage

- Parses direct `m:argPr/m:argSz` metadata on OMML argument containers without emitting a visible math child.
- Preserves the OMML script-level adjustment as a shared `MathNode.ArgSize` wrapper, clamped to the `-2..2` range.
- Scales the wrapped argument in `MathLayoutEngine`, so a boxed argument with `m:argSz="-1"` renders one script level smaller.
- Lets superscript arguments with `m:argSz="1"` offset the default script shrink in the shared renderer-neutral draw plan.
- Keeps WPF and Avalonia renderers as consumers of the same `MathBoxRenderPlanner` glyph operations.

## Verification

- Parser coverage: `OmmlParserTests.BoxArgument_WithArgSizeMinusOne_WrapsBaseInSharedArgumentSizeNode`
- Parser coverage: `OmmlParserTests.SuperscriptArgument_WithArgSizePlusOne_PreservesLargerScriptRequest`
- Parser coverage: `OmmlParserTests.ArgumentSize_ClampsToOmmlScriptLevelRange`
- Layout coverage: `MathLayoutEngineTests.ArgumentSizeMinusOne_ScalesArgumentGlyphInSharedDrawPlan`
- Layout coverage: `MathLayoutEngineTests.SuperscriptArgumentSizePlusOne_RestoresScriptGlyphTowardTextSize`
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_ArgumentSize_UsesSharedScaledGlyphPlan_DoesNotThrow`
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_ArgumentSize_UsesSharedScaledGlyphPlan_DoesNotThrow`

## Remaining

This is shared structural/render-plan parity evidence. Exact PowerPoint math typography, Cambria Math metrics, and PowerPoint-authoritative visual baselines remain deferred until a COM-capable validation machine is available.
