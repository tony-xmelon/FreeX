# FreeW Avalonia PDF picture reflection parity

Date: 2026-08-05

## Scope

Avalonia's live document surface already rendered picture reflections through
`PictureEffectVisualPlanner`, but direct PDF export omitted them. Inline, floating,
header/footer, and grouped pictures all converge on `DocumentView.BuildPdfImage`, so
the fix belongs in that shared export owner.

## Result

- Direct PDF picture export now emits a `PdfEffectGroup` with
  `PdfEffectKind.Reflection` before the source bitmap.
- The effect consumes the same start/end opacity, fade positions, and distance plan
  as the live Avalonia surface.
- Reflection, source, and border share the existing rotation/flip group.
- The picture border remains outside the reflected child and paints after the source.
- Pictures without reflection retain the prior direct `PdfImage` path.
- Both Portable and Skia PDF writers accept and render the resulting operation graph.

## Verification

- Focused compiling reflection contract: 1/1 passed.
- Focused image/PDF controls with `--no-build`: 9/9 passed.
- `FreeW.App.Avalonia` Release build: 0 warnings, 0 errors.

No Word COM export was needed: this slice closes a missing FreeW export operation and
uses the already-tested shared PDF reflection backend rather than calibrating raster
geometry against a Word reference.

## Process rule

When live rendering and direct export diverge, identify their shared semantic planner
and the export convergence point. Add the missing operation there, preserve layer and
transform ownership, then gate the new route with explicit no-effect controls and every
available output backend.
