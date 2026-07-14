# FreeP OMML Pre-Sub/Superscript Layout - 2026-07-14

## Scope

This slice adds bounded shared FreeP evidence for PowerPoint-authored OMML `m:sPre` structures.

- Parser coverage preserves the base, pre-subscript, and pre-superscript children, including nested math nodes.
- Shared `MathLayoutEngine` keeps the pre-sub/sup stack to the left of the base and reduces the script font size.
- Parsed-OMML render-plan coverage now proves the pre-superscript, pre-subscript, and base glyph coordinates before WPF or Avalonia draw them.
- WPF and Avalonia consume the same `MathBoxRenderPlanner` glyph order and coordinates; no renderer-local math placement policy was added.

## Evidence

- Parser coverage: `OmmlParserTests.SPre_ParsesBaseSubAndSup_PreservingNestedChildren`
- Parser coverage: `OmmlParserTests.SPre_WithMissingSubAndSup_UsesEmptyUnknownScriptFallbacks`
- Layout coverage: `MathLayoutEngineTests.PreSubSup_PlacesScriptStackLeftOfBase_WithSupAboveSub`
- Layout coverage: `MathLayoutEngineTests.PreSubSup_UsesReducedScriptFontSize`
- Layout coverage: `MathLayoutEngineTests.PreSubSup_ContainsTallBaseAndTallScriptsWithoutClipping`
- Layout/render-plan coverage: `MathLayoutEngineTests.OmmlPreSubSup_RenderPlanCarriesLeftScriptStackBeforeBase`
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_PreSubSup_UsesSharedMathBoxPlan_DoesNotThrow`
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_PreSubSup_UsesSharedMathBoxPlan_DoesNotThrow`

## Command Inventory

Tracked as workflow evidence row `freep.omml.pre-subsup-layout` in the generated FreeP command/evidence inventory.

## Remaining Work

PowerPoint-authoritative OMML visual baselines remain blocked on this machine because PowerPoint COM is not available. This slice proves shared WPF/Avalonia pre-sub/superscript structure layout, not exact OfficeMath glyph metrics, Cambria Math script kerning, or broader script-spacing table parity.
