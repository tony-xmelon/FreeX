# FreeP OMML Phantom Multi-Glyph Spacing - 2026-07-13

## Scope

This slice tightens bounded shared FreeP support for transparent OMML phantoms:

- `m:phantPr/m:transp` still affects spacing only; hidden phantom glyphs do not reach the render plan.
- Hidden zero-width phantoms now classify common multi-glyph relation operators such as `->`, `==`, `<=`, and `<->`.
- The classification is shared with `m:boxPr/m:opEmu` in `MathLayoutEngine`, so WPF and Avalonia consume the same `MathBoxRenderPlanner` output.
- Non-operator phantom text remains packed and does not receive operator-class spacing.

## Evidence

- Parser coverage: `OmmlParserTests.Phantom_TransparentMultiGlyphOperator_PreservesRunForSharedSpacing`
- Layout/render-plan coverage: `MathLayoutEngineTests.Row_TransparentZeroWidthPhantomMultiGlyphRelation_AddsSharedSpacingAdvanceWithoutGlyph`
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_TransparentPhantomMultiGlyphRelation_UsesSharedSpacingPlan_DoesNotThrow`
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_TransparentPhantomMultiGlyphRelation_UsesSharedSpacingPlan_DoesNotThrow`

## Remaining Work

PowerPoint-authoritative OMML visual baselines remain blocked on this machine because PowerPoint COM is not available. This slice does not claim full OfficeMath spacing-table parity; broader work still needs exact font metrics, PowerPoint-authored fixture renders, and additional operator classes beyond the bounded common relation set.
