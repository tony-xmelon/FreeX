# FreeP OMML Delimiter Shape - 2026-07-14

Scope: bounded shared FreeP math-layout slice for PowerPoint-authored OMML delimiters that use `m:dPr/m:shp`.

## Coverage

- Parses `m:dPr/m:shp m:val="centered"` into shared `MathNode.Delim` metadata.
- Keeps absent or `match` shape on the existing matched/stretchy delimiter path.
- Lays out centered delimiters with ordinary bracket height while preserving the tall inner expression's shared container height and baseline.
- Carries the resolved bracket height through `MathBoxRenderPlanner`, so WPF and Avalonia consume the same draw plan without renderer-local math policy.

## Verification

- `OmmlParserTests.Delim_WithCenteredShape_PreservesSharedDelimiterShape`
- `OmmlParserTests.Delim_WithAbsentOrMatchShape_UsesExistingMatchedDelimiterShape`
- `MathLayoutEngineTests.Delim_WithCenteredShape_UsesOrdinaryBracketHeightWithoutChangingInnerLayout`
- `SlideCanvasMathBaselineTests.RenderParaWithMath_CenteredDelimiterShape_UsesSharedOrdinaryBracketPlan_DoesNotThrow` in WPF and Avalonia test projects.

## Remaining

This is shared structural/render-plan evidence only. It does not claim PowerPoint-authoritative math visual parity, exact delimiter glyph metrics, or complete OfficeMath delimiter-shape typography without COM-backed PowerPoint baselines.
