# FreeP OMML Radical Degree Layout Evidence - 2026-07-14

This slice adds bounded shared FreeP evidence for visible and hidden OMML
radical degrees. It stays in the renderer-neutral math stack: `OmmlParser`
preserves a visible `m:deg` when `m:radPr/m:degHide` is absent or off,
`MathLayoutEngine` places the script-sized degree to the left of the radical
sign and above the radicand baseline, and `MathBoxRenderPlanner` carries the
same glyph and radical draw ops to WPF and Avalonia.

## Covered

- Default visible radical degree parsing now has explicit parser coverage.
- Visible degree layout asserts script-sized glyph placement before the radical
  sign, above the radicand top/baseline, while the radical baseline remains
  governed by the radicand.
- Hidden `m:radPr/m:degHide` radicals prove no degree glyph is emitted and no
  ghost degree gutter is reserved in the shared `MathBox` plan.
- Paired WPF and Avalonia baseline tests consume the same renderer-neutral
  `DrawRadical` plus degree/radicand `DrawGlyph` positions before rendering.

## Verification

- `dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~OmmlParserTests|FullyQualifiedName~MathLayoutEngineTests" --logger "trx;LogFileName=freep-presentation-omml-radical.trx"`
- `dotnet test freep\FreeP.App.Host.Tests\FreeP.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~SlideCanvasMathBaselineTests" --logger "trx;LogFileName=freep-wpf-math-radical.trx"`
- `dotnet test freep\FreeP.App.Rendering.Avalonia.Tests\FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~SlideCanvasMathBaselineTests" --logger "trx;LogFileName=freep-avalonia-math-radical.trx"`

## Remaining Gaps

This does not claim PowerPoint-authoritative math visual parity. Exact Cambria
Math radical glyph metrics, radical-degree kerning, overline/check-mark shape
tuning, broader OfficeMath radical variants, and PowerPoint-captured baselines
remain deferred to a COM-capable Microsoft PowerPoint baseline host.
