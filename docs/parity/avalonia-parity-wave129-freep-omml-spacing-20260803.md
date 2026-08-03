# Avalonia/WPF Parity Wave 129: FreeP OMML Inter-Equation Spacing

## Scope

This slice continues the shared OfficeMath work after Wave 128 multiple
alignment columns. It implements authored `m:mathPr/m:interSp` spacing for a
display math paragraph containing multiple `m:oMath` equations.

- `interSp` is preserved as a non-negative twips value in shared math
  properties and the parsed `MathParagraph`.
- Canonical inherited `m:mathPr` placement is covered through an ancestor
  settings wrapper; explicit zero is preserved, while negative and malformed
  values are ignored as invalid `ST_TwipsMeasure` values.
- The value applies only to the rows synthesized for multiple display
  equations in the same `m:oMathPara`; an authored single equation retains its
  existing layout path.
- Shared layout converts twips to DIP before resolving the row gap. WPF and
  Avalonia consume the same `MathBox` and `MathDrawOp` coordinates.

## Authority And Claim Boundary

Microsoft documents `interSp` as spacing between equations, expressions, or
other mathematical text within a display math paragraph, measured in twips:

- [Open XML SDK `InterSpacing`](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.interspacing?view=openxml-3.0.1)
- [Open XML SDK `MathProperties.InterSpacing`](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.mathproperties.interspacing?view=openxml-3.0.1)

This is shared structural and render-plan evidence. It does not claim
PowerPoint-authoritative font metrics or raster baselines.

`m:eqArrPr/m:maxDist` and `m:objDist` remain deferred in this wave. The
MS-OE376 `eqArr` note requires alternating alignment-point and column-separator
semantics, and specifies that distribution depends on those separators. Wave
128 intentionally records every current marker as an alignment boundary but
does not model spacer markers separately, so applying `maxDist`/`objDist` to
that model would change semantics without sufficient source evidence.

The same authority review also leaves `m:preSp` and `m:intraSp` out of scope:
Microsoft records that Word ignores `preSp` and does not implement `intraSp`.

## Verification

- `OmmlParserTests.OMathPara_InterEquationSpacingReadsAuthoredTwipsAndMultiEquationScope`
- `MathLayoutEngineTests.OmmlParagraph_InterEquationSpacingChangesOnlyMultiEquationRowGap`
- `SlideCanvasMathBaselineTests.RenderParaWithMath_InterEquationSpacing_UsesSharedMathBoxPlan_DoesNotThrow` in WPF
- `SlideCanvasMathBaselineTests.RenderParaWithMath_InterEquationSpacing_UsesSharedMathBoxPlan_DoesNotThrow` in Avalonia

Residuals are the authoritative alignment-versus-column-separator model and
PowerPoint-backed visual baselines for equation-array distribution.
