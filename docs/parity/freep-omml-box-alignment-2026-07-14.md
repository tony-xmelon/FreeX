# FreeP OMML Box Alignment Points - 2026-07-14

Scope: bounded shared FreeP math-layout slice for PowerPoint-authored equation arrays that place alignment markers on boxed terms with `m:boxPr/m:aln`.

## Coverage

- Parses direct `m:eqArr/m:e/m:box/m:boxPr/m:aln` as an invisible row alignment point.
- Preserves the boxed expression as a `MathNode.Box` child instead of stripping or flattening it.
- Feeds the alignment index into shared `MathNode.EqArray.AlignmentPointIndices`.
- Aligns boxed equation terms in `MathLayoutEngine` before host rendering.
- Carries the aligned glyph coordinates through `MathBoxRenderPlanner`, so WPF and Avalonia consume the same draw plan without renderer-local math policy.

## Verification

- `OmmlParserTests.Parse_EqArray_BoxPropertyAlnPreservesAlignmentPointAndBox`
- `MathLayoutEngineTests.OmmlEqArray_BoxPropertyAlignmentMarkers_AlignBoxedTermsInSharedPlan`
- `SlideCanvasMathBaselineTests.RenderParaWithMath_EqArrayBoxPropertyAlignment_UsesSharedAlignmentPlan_DoesNotThrow` in WPF and Avalonia test projects.

## Command Inventory

Tracked as workflow evidence row `freep.omml.box-alignment-points` in the generated FreeP command/evidence inventory.

## Remaining

This does not add PowerPoint COM visual baselines, full OfficeMath alignment-table semantics, or visual tuning for every authored equation-array alignment variant.
