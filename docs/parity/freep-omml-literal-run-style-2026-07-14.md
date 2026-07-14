# FreeP OMML Literal Run Style - 2026-07-14

## Scope

This bounded FreeP slice adds shared WPF/Avalonia render-plan evidence for PowerPoint-authored OMML math runs that carry `m:rPr/m:lit`.

## Coverage

- Parses `m:rPr/m:lit` as a CT_OnOff property and preserves it on `MathNode.Run`.
- Treats bare/on `m:lit` with no explicit math style as literal upright text in the shared parser path.
- Keeps explicit `m:sty` visual style authoritative when authors combine `m:lit` with an explicit italic/bold request.
- Carries the resulting glyph style through `MathLayoutEngine` and `MathBoxRenderPlanner`, so WPF and Avalonia consume the same `MathDrawOp.DrawGlyph` metadata without renderer-local literal policy.

## Verification

- Parser coverage: `OmmlParserTests.Run_WithLiteralNoVal_IsLiteralAndUpright`
- Parser coverage: `OmmlParserTests.Run_WithLiteralExplicitlyOff_KeepsDefaultMathVariableStyle`
- Parser coverage: `OmmlParserTests.Run_WithLiteralAndExplicitItalicStyle_PreservesAuthoredVisualStyle`
- Layout/render-plan coverage: `MathLayoutEngineTests.OmmlLiteralRun_RenderPlanCarriesUprightLiteralGlyph`
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_LiteralRun_UsesSharedUprightGlyphPlan_DoesNotThrow`
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_LiteralRun_UsesSharedUprightGlyphPlan_DoesNotThrow`

## Remaining

This is shared structural/render-plan evidence only. It does not claim PowerPoint-authoritative math visual parity, full OfficeMath linear build-up behavior, exact Cambria Math metrics, or broader unhandled OMML construct coverage without COM-backed PowerPoint baselines.
