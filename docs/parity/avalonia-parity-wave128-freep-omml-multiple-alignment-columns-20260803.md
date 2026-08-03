# Avalonia/WPF Parity Wave 128: FreeP OMML Multiple Alignment Columns

## Scope

This slice continues Wave127 `m:aln` support for authored `m:eqArr` objects:

- Each authored equation-array row preserves every explicit alignment-marker
  boundary, not only the first one.
- Shared layout resolves those boundaries as ordered alignment columns. Unequal
  prefix and inter-column widths therefore produce the same marker coordinates
  in every marked row before either renderer draws.
- Nested `m:eqArr` nodes remain separate alignment contexts. A nested marker is
  not promoted into the containing array's columns.
- The existing first-marker metadata and `AlignRowsLeft` distinction remain in
  place for Wave127 synthesized multi-`m:oMath` paragraph arrays. Authored
  `m:eqArr` rows keep their centered-row default when they have no marker.

## Authority

- [Open XML SDK `EquationArray`](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.equationarray?view=openxml-3.0.1)
  documents that an `m:eqArr` can align multiple points within its arguments;
  odd ampersand markers are alignment points and even markers are spacer
  positions, with an implied leading spacer.
- [MS-OE376 `eqArr` interoperability note](https://learn.microsoft.com/en-us/openspecs/office_standards/ms-oe376/d8d37e2b-532d-49db-9cba-2ef4bd8d9baa)
  confirms the alignment-point/column-separator model and the role of
  `maxDist` and `objDist` in distributing space.
- [MS-OE376 `oMath` interoperability note](https://learn.microsoft.com/en-us/openspecs/office_standards/ms-oe376/1d77457b-2884-4749-9b4a-c150ca13cc19)
  records that although the standard allows an `m:oMath` inside another math
  object or `m:oMath`, Word fails to open such content. There is therefore no
  authoritative Word behavior here to justify flattening nested alignment
  contexts.

## Implementation

- `MathNode.EqArray` now carries ordered per-row alignment-column boundaries
  while retaining the Wave127 first-point view for existing callers.
- `OmmlParser` records each direct `m:aln` marker and each effective run or
  operator-emulator box marker using the direct-child boundary where it occurs.
  Nested arrays are parsed as child nodes and are not searched recursively for
  the parent array's markers.
- `MathLayoutEngine` computes the widest segment for each authored alignment
  column, inserts the required shared neutral gaps, and positions marked rows
  against those shared coordinates. Single-point and synthesized paragraph
  paths retain their existing behavior.
- WPF and Avalonia consume the same `MathBox` and `MathDrawOp` output; no
  host-specific alignment policy was added.

## Evidence

- `OmmlParserTests` covers multiple marker boundaries and nested-context
  locality.
- `MathLayoutEngineTests` covers two alignment columns with unequal segment
  widths.
- `FreeP.App.Host.Tests/OmmlMathDefaultsParityTests` and
  `FreeP.App.Rendering.Avalonia.Tests/OmmlMathDefaultsParityTests` cover shared
  multi-column coordinates and renderer draw smoke paths.

## Claim Boundary and Residuals

This slice claims explicit authored `m:aln` marker columns in `m:eqArr`, not a
complete implementation of the OfficeMath ampersand model. It does not model
implicit spacer markers separately, `m:eqArrPr/m:maxDist`,
`m:eqArrPr/m:objDist`, or PowerPoint-authoritative font/raster metrics. It also
does not claim cross-array alignment for nested `m:eqArr` or support for the
Word-invalid nested `m:oMath` case. Authored `m:eqArr` remains distinct from
the synthesized paragraph-array representation introduced in Wave127.
