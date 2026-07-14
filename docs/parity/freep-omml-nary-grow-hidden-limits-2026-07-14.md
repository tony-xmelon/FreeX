# FreeP OMML N-ary Grow And Hidden Limits - 2026-07-14

Scope: bounded shared FreeP math-layout evidence for PowerPoint-authored OMML n-ary operators that combine `m:naryPr/m:grow` with hidden lower and upper limits via `m:subHide` and `m:supHide`.

## Coverage

- Preserves the shared parser behavior where `m:subHide` and `m:supHide` use CT_OnOff semantics and remove authored lower/upper limits before layout.
- Preserves `m:naryPr/m:grow` on the same `MathNode.Nary`, so a tall operand still scales the n-ary operator in shared layout.
- Proves `MathLayoutEngine` and `MathBoxRenderPlanner` emit only the grown operator plus operand glyphs; hidden limit glyphs do not reach WPF or Avalonia.
- Keeps WPF and Avalonia renderers as consumers of the same renderer-neutral math plan; no renderer-local n-ary placement or hidden-limit policy was added.

## Verification

- Parser coverage: `OmmlParserTests.Nary_WithGrowAndHiddenLimits_PreservesGrowthAndDropsLimits`.
- Shared layout/render-plan coverage: `MathLayoutEngineTests.OmmlNaryGrow_WithHiddenLimits_ScalesOperatorWithoutLimitGlyphs`.
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_NaryGrowHiddenLimits_UsesSharedPlan_DoesNotThrow`.
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_NaryGrowHiddenLimits_UsesSharedPlan_DoesNotThrow`.

## Command Inventory

Tracked as workflow evidence row `freep.omml.nary-grow-hidden-limits` in the generated FreeP command/evidence inventory.

## Remaining

This is shared structural/render-plan evidence only. It does not claim PowerPoint-authoritative math visual parity, exact Cambria Math n-ary operator metrics, or complete OfficeMath display-style heuristics without COM-backed PowerPoint baselines.
