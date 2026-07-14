# FreeP OMML Limit Placement - 2026-07-14

Scope: bounded shared FreeP math-layout evidence for PowerPoint-authored OMML `m:limLow` and `m:limUpp` limit placement.

## Coverage

- Parses `m:limLow` as a shared `MathNode.Limit` with the limit centered below the base expression.
- Parses `m:limUpp` as the same shared node shape with the limit centered above the base expression.
- Proves `MathLayoutEngine` keeps the base expression baseline stable while expanding descent or ascent for the reduced-size limit text.
- Proves `MathBoxRenderPlanner` emits renderer-neutral glyph order, coordinates, and reduced font size before either host draws.
- Keeps WPF and Avalonia renderers as consumers of the same shared math plan; no renderer-local limit-placement policy was added.

## Verification

- Parser coverage: `OmmlParserTests.LimLow_ParsesBaseAndLowerLimit`.
- Parser coverage: `OmmlParserTests.LimUpp_ParsesBaseAndUpperLimit`.
- Shared layout coverage: `MathLayoutEngineTests.LimitLow_PlacesReducedLimitBelowBaseAndPreservesBaseline`.
- Shared layout coverage: `MathLayoutEngineTests.LimitUpp_PlacesReducedLimitAboveBaseAndRaisesAscent`.
- Shared render-plan coverage: `MathLayoutEngineTests.OmmlLimitUpperAndLower_RenderPlanCarriesCenteredReducedLimitGlyphs`.
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_LimitUpperAndLower_UseSharedCenteredLimitPlan_DoesNotThrow`.
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_LimitUpperAndLower_UseSharedCenteredLimitPlan_DoesNotThrow`.

## Command Inventory

Tracked as workflow evidence row `freep.omml.limit-placement` in the generated FreeP command/evidence inventory.

## Remaining

This is shared structural/render-plan evidence only. It does not claim PowerPoint-authoritative math visual parity, exact Cambria Math limit metrics, or complete OfficeMath display-style heuristics without COM-backed PowerPoint baselines.
