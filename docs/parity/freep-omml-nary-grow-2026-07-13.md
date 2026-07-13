# FreeP OMML N-ary Grow Layout - 2026-07-13

Scope: bounded shared FreeP math-layout slice for PowerPoint-authored OMML n-ary operators that use `m:naryPr/m:grow`.

## Coverage

- Parses `m:naryPr/m:grow` as a CT_OnOff flag on `MathNode.Nary`.
- Keeps the OfficeMath n-ary default: absent `m:grow` does not request operator growth.
- Treats a bare `m:grow` or true/on/1 value as grow-enabled, and false/off/0 as disabled.
- Grows the renderer-neutral n-ary operator glyph from shared math-layout metrics when the operand is taller than the normal display operator.
- Leaves WPF and Avalonia renderers as consumers of the existing `MathBoxRenderPlanner` glyph operations.

## Verification

- `OmmlParserTests.Nary_WithNoGrow_DefaultsOperatorGrowthOff`
- `OmmlParserTests.Nary_WithGrowOn_PreservesOperatorGrowthFlag`
- `OmmlParserTests.Nary_WithGrowOff_DoesNotRequestOperatorGrowth`
- `MathLayoutEngineTests.Nary_GrowOperator_WithTallOperand_IncreasesSharedOperatorSize`
- `MathLayoutEngineTests.OmmlNaryGrow_RenderPlanCarriesScaledOperatorGlyph`
- WPF/Avalonia `RenderParaWithMath_NaryGrow_UsesSharedScaledOperatorPlan_DoesNotThrow`

## Remaining

This does not add PowerPoint COM visual baselines, exact Cambria Math font metrics, or broader n-ary display-style policies beyond the explicit `m:grow` flag.
