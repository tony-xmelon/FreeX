# FreeP OMML Script Alignment And Argument Size - 2026-07-14

## Scope

This slice promotes the paired FreeP OMML evidence for PowerPoint-authored script alignment and argument script-size adjustment:

- `m:sSubSupPr/m:alnScr` is parsed into the shared `MathNode.SubSup` alignment flag.
- Shared `MathLayoutEngine` right-aligns the shorter sub/sup script inside the renderer-neutral script column.
- `m:argPr/m:argSz` is parsed into a shared `MathNode.ArgSize` wrapper and clamped to the OfficeMath script-level range.
- Shared layout applies the argument size adjustment before `MathBoxRenderPlanner` emits glyph operations.
- WPF and Avalonia consume the same glyph order, coordinates, and font-size metadata; no renderer-local math policy is introduced.

## Evidence

- Parser coverage: `OmmlParserTests.SSubSup_WithAlignScriptsOn_PreservesSharedAlignmentFlag`
- Parser coverage: `OmmlParserTests.SSubSup_WithAlignScriptsOff_UsesExistingUnalignedLayoutFlag`
- Parser coverage: `OmmlParserTests.BoxArgument_WithArgSizeMinusOne_WrapsBaseInSharedArgumentSizeNode`
- Parser coverage: `OmmlParserTests.SuperscriptArgument_WithArgSizePlusOne_PreservesLargerScriptRequest`
- Parser coverage: `OmmlParserTests.ArgumentSize_ClampsToOmmlScriptLevelRange`
- Layout coverage: `MathLayoutEngineTests.SubSup_WithAlignScripts_RightAlignsSharedScriptColumn`
- Layout coverage: `MathLayoutEngineTests.OmmlSubSupAlignScripts_RenderPlanCarriesRightAlignedScriptGlyphs`
- Layout coverage: `MathLayoutEngineTests.ArgumentSizeMinusOne_ScalesArgumentGlyphInSharedDrawPlan`
- Layout coverage: `MathLayoutEngineTests.SuperscriptArgumentSizePlusOne_RestoresScriptGlyphTowardTextSize`
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_SubSupAlignScripts_UsesSharedRightAlignedScriptPlan_DoesNotThrow`
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_ArgumentSize_UsesSharedScaledGlyphPlan_DoesNotThrow`
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_SubSupAlignScripts_UsesSharedRightAlignedScriptPlan_DoesNotThrow`
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_ArgumentSize_UsesSharedScaledGlyphPlan_DoesNotThrow`

## Remaining Work

This is shared structural and renderer-neutral draw-plan evidence. PowerPoint-authoritative OMML visual baselines, exact Cambria Math script metrics, and broader OfficeMath script-spacing table parity remain deferred to a COM-capable validation host.
