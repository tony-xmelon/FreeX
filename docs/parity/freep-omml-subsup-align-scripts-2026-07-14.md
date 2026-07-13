# FreeP OMML SubSup Align Scripts - 2026-07-14

## Scope

This slice adds bounded shared FreeP evidence for PowerPoint-authored OMML `m:sSubSupPr/m:alnScr` structures.

- The OMML parser preserves the explicit align-scripts flag on `MathNode.SubSup`.
- Shared `MathLayoutEngine` right-aligns the shorter script within the sub/sup script column only when `m:alnScr` is on.
- WPF and Avalonia consume the same `MathBoxRenderPlanner` glyph order and coordinates; no renderer-local script-placement policy was added.

## Evidence

- Parser coverage: `OmmlParserTests.SSubSup_WithAlignScriptsOn_PreservesSharedAlignmentFlag`
- Parser coverage: `OmmlParserTests.SSubSup_WithAlignScriptsOff_UsesExistingUnalignedLayoutFlag`
- Layout/render-plan coverage: `MathLayoutEngineTests.SubSup_WithAlignScripts_RightAlignsSharedScriptColumn`
- Layout/render-plan coverage: `MathLayoutEngineTests.OmmlSubSupAlignScripts_RenderPlanCarriesRightAlignedScriptGlyphs`
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_SubSupAlignScripts_UsesSharedRightAlignedScriptPlan_DoesNotThrow`
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_SubSupAlignScripts_UsesSharedRightAlignedScriptPlan_DoesNotThrow`

## Remaining Work

PowerPoint-authoritative OMML visual baselines remain blocked on this machine because PowerPoint COM is not available. This slice proves shared WPF/Avalonia script-stack alignment behavior, not exact OfficeMath glyph metrics or broader script-spacing table parity.
