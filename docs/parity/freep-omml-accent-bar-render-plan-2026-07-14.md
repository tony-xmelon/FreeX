# FreeP OMML Accent-Bar Render Plan - 2026-07-14

## Scope

This bounded FreeP slice adds shared WPF/Avalonia render-plan evidence for PowerPoint-authored OMML accent bars that arrive as `m:accPr/m:chr` overbar/macron characters.

## Coverage

- Preserves the authored `m:accPr/m:chr` value in the shared `MathNode.Acc` parser path.
- Resolves combining macron, combining overline, and spacing macron accent values to a renderer-neutral `MathBox.HRule` above the base expression.
- Keeps ordinary accent glyphs, such as tilde and hat, on the existing glyph path.
- Carries the accent-bar decision through `MathBoxRenderPlanner` as `MathDrawOp.DrawHRule`, so WPF and Avalonia consume the same line primitive without renderer-local math policy.

## Verification

- Parser coverage: `OmmlParserTests.Acc_WithOverbarAccent_PreservesRuleAccentCharacter`
- Layout/render-plan coverage: `MathLayoutEngineTests.Acc_WithOverbarAccent_EmitsSharedHorizontalRulePlan`
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_AccentBarOverline_UsesSharedHRulePlan_DoesNotThrow`
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_AccentBarOverline_UsesSharedHRulePlan_DoesNotThrow`

## Remaining

This is shared structural/render-plan evidence only. It does not claim PowerPoint-authoritative math visual parity, exact Cambria Math accent placement, stretched accent glyph typography, or full OfficeMath accent semantics without COM-backed PowerPoint baselines.
