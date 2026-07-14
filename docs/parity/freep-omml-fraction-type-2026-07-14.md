# FreeP OMML Fraction Type - 2026-07-14

Scope: bounded shared FreeP math-layout evidence for PowerPoint-authored OMML `m:fPr/m:type` fraction variants.

## Coverage

- Parses absent `m:fPr/m:type` as the default stacked bar fraction.
- Parses `bar`, `noBar`, `lin`, and `skw` into shared `MathNode.FracType` metadata.
- Lays out `noBar` as a stacked numerator/denominator without a horizontal rule.
- Lays out `lin` as inline numerator, slash glyph, and denominator on one shared baseline.
- Lays out `skw` as offset numerator/denominator with a renderer-neutral diagonal line.
- Keeps WPF and Avalonia renderers as thin consumers of the same shared `MathBoxRenderPlanner` glyph, horizontal-rule, and line operations.

## Verification

- Parser coverage: `OmmlParserTests.Frac_WithNoFPr_DefaultsToBar`.
- Parser coverage: `OmmlParserTests.Frac_WithExplicitType_MapsToEnum`.
- Parser coverage: `OmmlParserTests.Frac_WithUnknownType_DefaultsToBar`.
- Shared layout coverage: `MathLayoutEngineTests.Frac_DefaultBarType_RendersHRule_Unchanged`.
- Shared layout coverage: `MathLayoutEngineTests.Frac_NoBarType_HasNoHRule_ButKeepsStackedNumDen`.
- Shared layout coverage: `MathLayoutEngineTests.Frac_LinearType_RendersSlashGlyph_NotStacked`.
- Shared layout coverage: `MathLayoutEngineTests.Frac_SkewedType_RendersDiagonalLineWithOffsetNumeratorAndDenominator`.
- Shared baseline coverage: `MathLayoutEngineTests.Frac_SkewedType_PreservesRowBaselineWithAdjacentRuns`.
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_FractionTypes_UseSharedDrawPlan_DoesNotThrow`.
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_FractionTypes_UseSharedDrawPlan_DoesNotThrow`.

## Command Inventory

Tracked as workflow evidence row `freep.omml.fraction-type` in the generated FreeP command/evidence inventory.

## Remaining

This is shared structural/render-plan evidence only. It does not claim PowerPoint-authoritative math visual parity, exact Cambria Math numerator/denominator metrics, skewed-fraction slash angle fidelity, or complete OfficeMath fraction typography without COM-backed PowerPoint baselines.
