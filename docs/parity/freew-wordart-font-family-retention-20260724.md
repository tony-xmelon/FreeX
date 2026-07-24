# FreeW WordArt Font-Family Retention

## Scope

WordArt text runs can carry their own `w:rFonts` family independently of the
document theme. FreeW previously discarded that payload on import and emitted no
explicit font on save; WPF and Avalonia then rendered all WordArt as Calibri.

`WordArt.FontFamily` now preserves the optional authored font family. The DOCX
reader accepts `w:rFonts/@ascii` (falling back to `@hAnsi`), the writer emits
`ascii`, `hAnsi`, and `cs` only when the model contains an explicit family, and
the renderer-neutral WordArt plan sends the authored family to both hosts. An
absent family retains the existing Calibri default route.

## Verification

- `WordArtRoundTripTests`: 49/49, including explicit XML and reopened-model
  assertions for `Arial`.
- `DrawingObjectVisualPlannerTests`: 21/21, including authored-family and
  absent-family fallback planning.
- `DocumentEffectRenderingTests`: 6/6, including WPF `TextBlock.FontFamily`
  consumption of an authored `Arial` WordArt.
- WPF and Avalonia Release host builds: 0 warnings, 0 errors.
