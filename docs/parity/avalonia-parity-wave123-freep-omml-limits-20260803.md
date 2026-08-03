# Wave123 FreeP OMML document limit placement

## Scope

FreeP's shared OMML pipeline previously handled local `m:limLoc`, but did not
carry document-level `m:mathPr/m:intLim` or `m:naryLim` from package settings
through the model and compositor. An omitted local `m:limLoc` therefore used a
hardcoded placement and could not distinguish integral operators from other
n-ary operators.

## Implemented

- Added nullable `IntegralLimitLocation` and `NaryLimitLocation` values to
  `OmmlMathProperties`, preserving property-by-property overlay semantics.
- Read `m:intLim` and `m:naryLim` from the related settings part. Val-less
  elements normalize to `subSup` and `undOvr`, respectively.
- Added typed limit locations to the shared `MathNode.MathProperties` plan.
- Threaded immutable resolved math properties through every recursive OMML
  parser path, including nested fractions, matrices, equation arrays, and
  nested n-ary nodes. No mutable or static ambient parser state is used.
- Resolved absent local `m:limLoc` using `intLim` for integral glyphs and
  `naryLim` for other n-ary glyphs. A local `m:limLoc` always wins.
- Invalid document values use the conservative property defaults:
  `intLim` -> `subSup`, `naryLim` -> `undOvr`.
- Kept WPF and Avalonia on the same `MathBox` render plan and added paired
  visible placement assertions.

## Authority

Microsoft Learn documents that `m:intLim` is a document-level setting whose
omitted or val-less default is `subSup`, and that its legal values are
`subSup` and `undOvr`: [IntegralLimitLocation](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.integrallimitlocation?view=openxml-3.0.1).
The corresponding `m:naryLim` semantics and values are documented at
[NaryLimitLocation](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.narylimitlocation?view=openxml-3.0.1); its omitted or val-less default is `undOvr`.

## Verification

- `dotnet build FreeP\\FreeP.App.Presentation\\FreeP.App.Presentation.csproj --configuration Release --no-restore` passed with 0 warnings/errors.
- Focused parser, package-reader, and layout tests passed: 182/182.
- WPF paired host tests passed: 3/3.
- Avalonia paired host tests passed: 3/3.
- The new WPF and Avalonia tests assert upper/lower glyph Y placement around
  an integral rendered from the document default and both invoke the platform
  renderer.

No PowerPoint COM baseline was available in this slice; verification is based
on the official Open XML semantics and the shared WPF/Avalonia render plan.
