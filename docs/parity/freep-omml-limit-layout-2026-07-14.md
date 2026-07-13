# FreeP OMML Limit Layout - 2026-07-14

## Scope

This slice adds bounded shared FreeP evidence for PowerPoint-authored OMML limit structures:

- `m:limLow` lays out a reduced limit below the centered base expression while preserving the base baseline.
- `m:limUpp` lays out a reduced limit above the centered base expression and grows ascent so the upper limit is not clipped.
- WPF and Avalonia consume the same `MathBoxRenderPlanner` glyph order and coordinates; no renderer-local math placement policy was added.

## Evidence

- Parser coverage: `OmmlParserTests.LimLow_ParsesBaseAndLowerLimit`
- Parser coverage: `OmmlParserTests.LimUpp_ParsesBaseAndUpperLimit`
- Layout/render-plan coverage: `MathLayoutEngineTests.OmmlLimitUpperAndLower_RenderPlanCarriesCenteredReducedLimitGlyphs`
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_LimitUpperAndLower_UseSharedCenteredLimitPlan_DoesNotThrow`
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_LimitUpperAndLower_UseSharedCenteredLimitPlan_DoesNotThrow`

## Remaining Work

PowerPoint-authoritative OMML visual baselines remain blocked on this machine because PowerPoint COM is not available. This slice proves shared WPF/Avalonia limit structure layout, not full OfficeMath typography, exact Cambria Math metrics, or broader limit/operator spacing-table parity.
