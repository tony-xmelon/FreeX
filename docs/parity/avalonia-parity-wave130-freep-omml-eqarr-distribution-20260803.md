# Avalonia/WPF Parity Wave 130: FreeP OMML Equation-Array Distribution

## Scope

This slice closes the deferred shared OMML `m:eqArrPr/m:maxDist` and
`m:objDist` gap for equation arrays whose authored markers are available to
the parser.

- Each row preserves ordered marker boundaries and classifies odd markers as
  alignment points and even markers as column separators.
- Alignment-point columns use independent maximum-left and maximum-right
  widths, so rows with opposing splits cannot overlap or overflow the array.
- `maxDist` expands only to a finite, known containing width. `objDist` moves
  the extra width into inter-column separator gaps when there are multiple
  columns; otherwise it follows the ordinary max-width margin distribution.
- Missing and explicit-off properties remain disabled. A val-less property is
  enabled, and malformed on/off values use the conservative disabled fallback.
- Nested arrays do not inherit an outer paragraph width as their own target;
  the immediate containing width is required before distribution is applied.

## Authority

- [MS-OE376 eqArr interoperability note](https://learn.microsoft.com/en-us/openspecs/office_standards/ms-oe376/d8d37e2b-532d-49db-9cba-2ef4bd8d9baa)
  specifies alignment-point versus column-separator markers, odd/even marker
  numbering, and the margin versus separator distribution behavior.
- [Open XML SDK EquationArray](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.equationarray?view=openxml-3.0.1)
  documents the implied leading spacer and defaults of `maxDist=0` and
  `objDist=0` when the properties are absent.
- [Open XML SDK MaxDistribution](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.maxdistribution?view=openxml-2.20.0)
  documents the containing-width expansion and val-less on default.
- [Open XML SDK ObjectDistribution](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.objectdistribution?view=openxml-3.0.1)
  documents object distribution and its val-less on default. Word's
  interoperability note records that `objDist` is ignored without maximum
  distribution.

## Shared implementation

`MathNode.EqArray` carries marker kind, separator columns, and the two
distribution flags. `OmmlParser` assigns marker kind in source order for both
explicit alignment markers and decoded ampersand markers, while keeping
`m:rPr/m:aln` runs in the row with their content intact. The shared
`MathLayoutEngine` resolves column widths and all distribution gaps before
either renderer receives a `MathBox`.

## Verification

- Presentation parser/layout: 339 passed.
- WPF `SlideCanvasMathBaselineTests`: 45 passed.
- Avalonia `SlideCanvasMathBaselineTests`: 46 passed.
- Added opposing alignment-split, heterogeneous separator, missing/bare/off/
  malformed property, nested-width, and run-marker coverage.
- Added paired WPF/Avalonia shared render-plan smoke coverage.

## Claim boundary

This is shared structural and render-plan parity, not a claim of exact
PowerPoint font metrics or raster identity. Distribution is applied only when
the containing width is finite and the marker model is separator-aware.
Malformed XML is handled conservatively, and nested arrays without an
immediate known containing width retain natural layout.
