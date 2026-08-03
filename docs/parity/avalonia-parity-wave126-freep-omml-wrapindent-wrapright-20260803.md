# Wave126 FreeP OMML Wrapped Math Paragraphs

## Scope

This slice adds document-level `m:wrapIndent` and `m:wrapRight` support for the
PresentationML OMML path. Package reading, shared parser/model precedence,
renderer-neutral layout, WPF rendering, and Avalonia rendering all consume the
same resolved values.

## Authority

- [Microsoft Learn: WrapIndent](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.wrapindent?view=openxml-3.0.1)
  defines `m:wrapIndent` as a twips measure and states that both an absent
  element and a present val-less element have the effective default of 1440
  twips (one inch).
- [Microsoft Learn: WrapRight](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.wrapright?view=openxml-3.0.1)
  defines absent as false, present val-less as true, and specifies that
  continuation lines are right aligned when enabled.
- [MS-OE376 7.1.2.30](https://learn.microsoft.com/en-us/openspecs/office_standards/ms-oe376/f5f7b70e-9d07-40f0-b78f-4701a036eef5)
  records Word's Office-specific behavior that `m:dispDef` off ignores
  `defJc`, `lMargin`, `rMargin`, `wrapRight`, and `wrapIndent`; the parser
  applies that gate consistently for these document-level properties.

Invalid twips values use FreeP's existing no-margin fallback of zero, while
invalid on/off values use the existing conservative true fallback. Absent
values remain nullable at the package/model/parser boundary so document,
graphic, and local overlays can be resolved property by property. The resolved
paragraph state then applies the authority's 1440-twip effective indent and
false right-alignment default only when `m:dispDef` is on; when `m:dispDef` is
absent or off it resolves the wrap state to zero/false so the layout cannot
accidentally reintroduce the 1440-twip fallback.

## Implementation

- `OmmlMathProperties`, `PptxPackageReader`, and `SlideCompositor` carry the
  two properties through the PresentationML package path.
- `MathNode.MathProperties` preserves nullable absent versus authored values for
  overlays; `MathParagraph` resolves those values to an effective enabled or
  disabled wrap state and applies the `dispDef` gate.
- Automatic binary wrapping now produces a dedicated `MathNode.WrappedParagraph`
  with continuation indentation or right alignment. It is intentionally not an
  `MathNode.EqArray`: authored `m:eqArr` layout remains on the existing
  equation-array path with its original alignment and spacing behavior.
- WPF and Avalonia continue to render the resulting shared `MathBox` and
  `MathDrawOp` plans without host-specific math policy.

## Evidence

- `OmmlParserTests`: absent, val-less, explicit, invalid, overlay-precedence,
  and `dispDef`-off cases for both properties.
- `MathLayoutEngineTests`: enabled and disabled/absent `dispDef` behavior,
  default and explicit continuation indentation, right-aligned continuation
  lines, in-bounds indentation, measured width overflow, and ordinary authored
  equation-array regression coverage.
- `PptxPackageReaderSourceTests`: package reader wiring and val-less twips
  normalization.
- `FreeP.App.Host.Tests/OmmlMathDefaultsParityTests`: WPF shared-plan and draw
  smoke coverage.
- `FreeP.App.Rendering.Avalonia.Tests/OmmlMathDefaultsParityTests`: Avalonia
  shared-plan and draw smoke coverage.

Focused Release verification on the Wave126 branch:

```text
dotnet build freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release -m:1 /nr:false
  0 warnings, 0 errors
dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~OmmlParserTests|FullyQualifiedName~MathLayoutEngineTests"
  317 passed, 0 failed
dotnet build freep/FreeP.App.Host.Tests/FreeP.App.Host.Tests.csproj --configuration Release -m:1 /nr:false
  0 warnings, 0 errors
dotnet test freep/FreeP.App.Host.Tests/FreeP.App.Host.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~OmmlMathDefaultsParityTests|FullyQualifiedName~PptxPackageReaderSourceTests.DocumentMathProperties"
  7 passed, 0 failed
dotnet build freep/FreeP.App.Rendering.Avalonia.Tests/FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release -m:1 /nr:false
  0 warnings, 0 errors
dotnet test freep/FreeP.App.Rendering.Avalonia.Tests/FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~OmmlMathDefaultsParityTests"
  6 passed, 0 failed
```

## Residuals

This slice covers document-level defaults and automatic binary-operator
continuation layout. It does not claim full PowerPoint typography or every
possible authored manual-break interaction. Visual comparison against
PowerPoint remains the broader FreeP math parity residual.
