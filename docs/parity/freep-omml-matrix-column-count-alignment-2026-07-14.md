# FreeP OMML Matrix Column Count Alignment - 2026-07-14

Scope: bounded shared FreeP math-layout evidence for PowerPoint-authored OMML matrices whose `m:mPr/m:mcs/m:mc/m:mcPr` column properties use `m:count` to repeat an alignment policy across multiple adjacent columns.

- `OmmlParser` now expands each matrix column property entry by its positive `m:count` value, defaulting missing or invalid counts to one column.
- Repeated `m:aln` metadata flows into `MathNode.Matrix.ColumnAlignments`, so shared layout applies the same left/center/right policy to every counted column.
- `MathBoxRenderPlanner` carries the resulting glyph coordinates to WPF and Avalonia; neither renderer needs matrix-specific alignment-count logic.

Focused evidence:

- Parser coverage: `OmmlParserTests.Parse_MatrixColumnAlignments_RepeatsAlignmentByCount`
- Shared layout/render-plan coverage: `MathLayoutEngineTests.OmmlMatrixColumnAlignmentCount_RepeatsAlignmentAcrossSharedColumns`
- WPF smoke coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_MatrixColumnAlignmentCount_UsesSharedRepeatedAlignmentPlan_DoesNotThrow`
- Avalonia smoke coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_MatrixColumnAlignmentCount_UsesSharedRepeatedAlignmentPlan_DoesNotThrow`

PowerPoint-authoritative matrix visual baselines remain deferred to a COM-capable baseline host. Exact OfficeMath column metrics and broader matrix spacing-table behavior are still outside this bounded slice.
