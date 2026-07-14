# FreeP OMML Equation-Array Spacing And Base Justification - 2026-07-14

Scope: bounded shared FreeP math-layout slice for PowerPoint-authored equation arrays that use `m:eqArrPr` row spacing and base-justification metadata.

## Coverage

- Parses `m:eqArrPr/m:rSpRule`, `m:rSp`, and `m:baseJc` into shared `MathNode.EqArray` metadata.
- Keeps direct `m:aln` equation-array alignment points intact while spacing metadata changes row offsets.
- Resolves row spacing in `MathLayoutEngine` before either host renders.
- Carries `m:baseJc` through shared `MathBox` ascent/baseline metrics.
- Proves WPF and Avalonia consume the same `MathBoxRenderPlanner` glyph coordinates without renderer-local equation-array policy.

## Verification

- `OmmlParserTests.Parse_EqArrayProperties_ReadsBaseJustificationAndRowSpacingMetadata`
- `MathLayoutEngineTests.EqArray_RowSpacingRuleChangesVerticalGapWithoutChangingRowOrder`
- `MathLayoutEngineTests.EqArray_BaseJustificationChangesReportedAscentWithoutMovingRowsOrAlignmentPoints`
- `MathLayoutEngineTests.OmmlEqArraySpacingAndBaseJustification_RenderPlanCarriesSharedRowOffsets`
- `SlideCanvasMathBaselineTests.RenderParaWithMath_EqArraySpacingAndBaseJustification_UsesSharedRowPlan_DoesNotThrow` in WPF and Avalonia test projects.

## Command Inventory

Tracked as workflow evidence row `freep.omml.eqarray-spacing-base-justification` in the generated FreeP command/evidence inventory.

## Remaining

This does not add Microsoft PowerPoint COM visual baselines, exact OfficeMath spacing metrics, or complete paragraph-level equation alignment semantics.
