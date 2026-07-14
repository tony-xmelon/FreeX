# FreeP OMML N-ary Limit Location - 2026-07-14

Scope: bounded shared FreeP math-layout evidence for PowerPoint-authored OMML n-ary operators that use `m:naryPr/m:limLoc`.

## Coverage

- Preserves the existing shared parser default where absent `m:limLoc` uses side script placement (`subSup`).
- Preserves explicit `m:limLoc m:val="undOvr"` as under/over limit placement.
- Proves the shared `MathLayoutEngine` and `MathBoxRenderPlanner` emit distinct renderer-neutral glyph order and coordinates for under/over versus side-script limits.
- Keeps WPF and Avalonia renderers as consumers of the same `MathBoxRenderPlanner` glyph operations; no renderer-local n-ary placement policy was added.

## Verification

- Parser coverage: `OmmlParserTests.Nary_WithNoLimLoc_DefaultsToSubSup_NotAboveBelow`.
- Parser coverage: `OmmlParserTests.Nary_WithExplicitUndOvr_IsAboveBelow`.
- Parser coverage: `OmmlParserTests.Nary_WithExplicitSubSup_IsNotAboveBelow`.
- Shared layout/render-plan coverage: `MathLayoutEngineTests.OmmlNaryLimLoc_RenderPlanDistinguishesUnderOverFromSubSup`.
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_NaryLimLoc_UsesSharedLimitPlacementPlan_DoesNotThrow`.
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_NaryLimLoc_UsesSharedLimitPlacementPlan_DoesNotThrow`.

## Command Inventory

Tracked as workflow evidence row `freep.omml.nary-limit-location` in the generated FreeP command/evidence inventory.

## Remaining

This is shared structural/render-plan evidence only. It does not claim PowerPoint-authoritative math visual parity, exact Cambria Math n-ary operator metrics, or complete OfficeMath display-style heuristics without COM-backed PowerPoint baselines.
