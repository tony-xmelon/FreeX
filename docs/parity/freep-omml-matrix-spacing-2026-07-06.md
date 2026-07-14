# FreeP OMML Matrix Spacing - 2026-07-06

## Scope

This slice tightens shared equation matrix parsing and layout for both WPF and
Avalonia. The renderers stay thin: OMML metadata is parsed into shared math
nodes, and `MathLayoutEngine` emits the common render plan consumed by both
presentation surfaces.

## Improved

- `m:mPr/m:baseJc` now maps to shared top, center, and bottom baseline
  alignment metadata.
- `m:rSpRule` plus `m:rSp` and `m:cGpRule` plus `m:cGp` now affect shared
  matrix row and column spacing.
- `m:cSp` now contributes a minimum shared matrix column width.
- Missing matrix properties retain the previous default centered layout path.
- WPF and Avalonia render smoke tests now prove the same shared
  `MathBoxRenderPlanner` glyph coordinates and matrix baseline metrics reach
  both hosts without renderer-local matrix spacing policy.

## Evidence

- Microsoft Open XML matrix documentation lists `mPr` matrix properties
  including `baseJc`, row spacing, column gap, and column spacing:
  https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.matrixproperties?view=openxml-3.0.1
- Microsoft Open XML matrix defaults document `baseJc` as `center` and spacing
  defaults as zero-valued matrix properties:
  https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.matrix?view=openxml-3.0.1

## Verification

- `dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --disable-build-servers --filter "FullyQualifiedName~OmmlParserTests|FullyQualifiedName~MathLayoutEngineTests" -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
- WPF renderer coverage:
  `SlideCanvasMathBaselineTests.RenderParaWithMath_MatrixSpacingAndBaseJustification_UsesSharedCellPlan_DoesNotThrow`
- Avalonia renderer coverage:
  `SlideCanvasMathBaselineTests.RenderParaWithMath_MatrixSpacingAndBaseJustification_UsesSharedCellPlan_DoesNotThrow`

## Remaining

- PowerPoint-authoritative rendered equation baselines still require a machine
  with PowerPoint COM available.
- Exact OfficeMath spacing metrics, Cambria Math typography, and broader
  matrix visual baselines remain separate bounded slices.
