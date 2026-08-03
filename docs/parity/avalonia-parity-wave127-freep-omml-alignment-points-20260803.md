# Avalonia/WPF Parity Wave 127: FreeP OMML Alignment Points

## Scope

This slice adds shared `m:aln` alignment-point support for display equations
inside `m:oMathPara`:

- `m:rPr/m:aln` is retained on math runs and `m:boxPr/m:aln` is retained on
  boxes, including authored false values.
- A multi-equation `m:oMathPara` is represented as a renderer-neutral shared
  equation array. Its authored run/box alignment points are resolved across
  equations before WPF or Avalonia rendering.
- Unmarked equations in that paragraph remain left-aligned within the
  centered group. Existing authored `m:eqArr` behavior is unchanged.
- A box alignment point participates only when its box is also an operator
  emulator, matching the Open XML contract.

## Authority

- [Open XML SDK `Alignment` (`m:aln`)](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.alignment?view=openxml-3.0.1)
  defines absent as not an alignment point and a val-less element as on.
  It describes alignment points as the locations where equations in one math
  paragraph align.
- [Open XML SDK `OperatorEmulator` (`m:opEmu`)](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.operatoremulator?view=openxml-3.0.1)
  defines operator-emulator boxes as the structures that can be aligned to
  other operators.
- [MS-OE376 alignment interoperability note](https://learn.microsoft.com/en-us/openspecs/office_standards/ms-oe376/542071cf-292f-4731-be4f-88b6873d6773)
  records that Office applies `m:aln` to math runs and does not use it on a
  box that is not an operator emulator.
- [Open XML SDK `Justification` (`m:jc`)](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.justification?view=openxml-3.0.1)
  defines the absent/val-less paragraph default as `centerGroup`: equations
  align with one another while the group is centered as a whole.

## Implementation

- `MathNode.Run` and `MathNode.Box` preserve alignment-point authored state;
  parser CT_OnOff handling distinguishes absent, val-less/on, and false.
- `OmmlParser` gathers the first top-level authored alignment point from each
  display equation and emits `MathNode.EqArray` metadata for a multi-equation
  `m:oMathPara`. Box markers are effective only with `m:opEmu`.
- `MathLayoutEngine` uses the existing shared alignment coordinate calculation
  and applies the centered-group left-row default only to this synthesized
  paragraph array.
- WPF and Avalonia render the same `MathBox` and `MathDrawOp` plan; no host
  receives math-specific policy.

## Evidence

- `OmmlParserTests`: multi-equation run markers and false CT_OnOff values for
  runs and boxes.
- `MathLayoutEngineTests`: shared marker coordinates and centered-group
  placement for unmarked equations, plus authored equation-array regressions.
- `FreeP.App.Host.Tests/OmmlMathDefaultsParityTests`: WPF shared-plan and draw
  smoke coverage.
- `FreeP.App.Rendering.Avalonia.Tests/OmmlMathDefaultsParityTests`: Avalonia
  shared-plan and draw smoke coverage.

## Residuals

This slice covers top-level alignment points in multiple display equations.
It does not claim full OfficeMath operator spacing, nested alignment contexts,
PowerPoint-authoritative raster metrics, or PowerPoint COM visual comparison.
Explicit authored `m:eqArr` spacing/base-justification remains its existing
separate layout path.
