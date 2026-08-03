# Avalonia/WPF Parity Wave 122: FreeP OMML `m:defJc`

Date: 2026-08-03

## Scope

This slice carries OMML document/default paragraph justification through the
shared FreeP model, package reader, parser, layout engine, and both renderers.
`m:oMathParaPr/m:jc` remains the highest-precedence paragraph setting; when it
is absent, the resolved `m:mathPr/m:defJc` value is used.

## Semantics and claim boundary

The implementation follows the Microsoft Open XML SDK documentation for
[`DefaultJustification` (`m:defJc`)](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.defaultjustification?view=openxml-3.0.1)
and [`Justification` (`m:jc`)](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.justification?view=openxml-3.0.1):

- `m:defJc` is a document-level default for display math.
- An omitted or val-less `m:defJc` resolves to `centerGroup`.
- An omitted or val-less local `m:jc` resolves to `centerGroup`.
- A local `m:jc` overrides the inherited document/containing-part default.
- The shared layout keeps the existing centered coordinates for both `Center`
  and `CenterGroup`; this change corrects the semantic metadata and precedence
  without claiming a new visual distinction that the current layout does not
  render.

The source pages describe the Open XML contract and are not PowerPoint pixel
evidence. No PowerPoint-authoritative pixel baseline is claimed in this slice;
PowerPoint COM is not used by the focused verification.

## Implementation

- Added `DefaultJustification` to `FreeP.Core.Model.OmmlMathProperties` and its
  property-by-property overlay.
- Read `m:defJc` from related settings/containing `m:mathPr` parts in
  `PptxPackageReader`, retaining val-less `defJc` as the semantic
  `centerGroup` value.
- Propagated the value through `MathNode.MathProperties` and
  `SlideCompositor` into the shared `OmmlParser` and `MathParagraph`.
- Added case-insensitive `center`/`centerGroup` parsing plus the existing
  hyphenated and reasonable British-spelling aliases.
- Added parser, inheritance, settings-reader, layout, and paired WPF/Avalonia
  shared-plan assertions.

## Verification

All commands below ran from this Wave122 worktree:

- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~OmmlParserTests|FullyQualifiedName~OmmlMathDefaultsIntegrationTests|FullyQualifiedName~MathLayoutEngineTests"` — 292 passed, 0 failed.
- `dotnet test freep/FreeP.App.Host.Tests/FreeP.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~OmmlMathDefaultsParityTests"` — 2 passed, 0 failed.
- `dotnet test freep/FreeP.App.Rendering.Avalonia.Tests/FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~OmmlMathDefaultsParityTests"` — 2 passed, 0 failed.
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Test-RepositoryPreflight.ps1` — passed.
- `dotnet build FreeP.slnx --configuration Release` — passed, 0 warnings, 0 errors.

The focused tests cover parser defaults/aliases, `MathNode` inheritance,
related-settings reader values, layout coordinates, and paired WPF/Avalonia
renderer consumption of the same shared plan. This note intentionally does not
update generated global dashboard summaries; integration owns those files.

## Remaining limitations

PowerPoint-authoritative raster comparison for OMML justification still requires
a machine with registered PowerPoint COM. Broader OMML elements and exact
PowerPoint font metrics remain outside this bounded `defJc` slice.
