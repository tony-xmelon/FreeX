# FreeP OMML Math Defaults Production Integration - Wave 100

## Scope

This slice closes the production import and composition gap left by Wave 99.
FreeP now carries authored OMML math defaults through the package reader and
the shared compositor, so WPF and Avalonia receive the same parsed and laid-out
math model.

The production path is:

1. `PptxPackageReader` reads the PresentationML package, including any true
   presentation relationship to a settings part.
2. `ReadMathRun` preserves containing `a:graphicData/m:mathPr` values on the
   renderer-neutral `MathRunInfo` model.
3. `SlideCompositor` overlays those values with the presentation defaults and
   supplies the result to `OmmlParser.Parse`.
4. The existing shared parser and layout engine produce the plan consumed by
   both WPF and Avalonia renderers.

## Authoritative source and fallback

The Open XML `m:mathPr` element has `graphicData` and `settings` as its
document-level parents. FreeP follows only a real settings relationship from
the presentation part; it does not treat an unrelated XML part or an arbitrary
package entry as a document default source.

The current PowerPoint corpus contains no `m:mathPr` in a settings part or
other package-level document settings source. Standard PowerPoint equations
are stored as DrawingML `a14:m` runs, and the normal PresentationML package
does not expose a settings relationship. Consequently
`Presentation.DocumentMathProperties` remains null for those files. This is an
intentional fallback and avoids inventing Office defaults that were not authored
in the package.

## Precedence

Authored values are resolved property by property in this order, from lowest
to highest precedence:

1. Presentation/package settings defaults, when a related settings part exists.
2. The containing `a:graphicData/m:mathPr`, when present.
3. A preserved raw math-wrapper `m:mathPr`.
4. Paragraph `m:oMathPara/m:mathPr` and local `m:oMathParaPr` properties.
5. Local element properties already handled by the shared OMML parser.

An omitted property remains available from the next lower level. An authored
empty value does not synthesize a fallback value.

## Verification

The production package/compositor tests cover:

- extraction only through a related settings relationship;
- no defaults when an unrelated package XML part merely contains `m:mathPr`;
- document, containing-wrapper, raw-wrapper, paragraph, and local precedence;
- the same effective font plan rendered through WPF and Avalonia.

Exact focused commands and results:

```text
dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj -c Release --filter FullyQualifiedName~OmmlMathDefaultsIntegrationTests
  Passed: 3, Failed: 0

dotnet test freep/FreeP.App.Host.Tests/FreeP.App.Host.Tests.csproj -c Release --no-restore --filter FullyQualifiedName~OmmlMathDefaultsParityTests
  Passed: 1, Failed: 0

dotnet test freep/FreeP.App.Rendering.Avalonia.Tests/FreeP.App.Rendering.Avalonia.Tests.csproj -c Release --no-restore --filter FullyQualifiedName~OmmlMathDefaultsParityTests
  Passed: 1, Failed: 0
```

## PowerPoint-authoritative residuals

No package-level default corpus is available in the current PowerPoint input
set, so there is no further authoritative source to extract for ordinary PPTX
files. Exact Office font fallback, Cambria Math metrics, and broader authored
settings-part corpus coverage remain visual/product validation work rather than
data that FreeP can safely fabricate.
