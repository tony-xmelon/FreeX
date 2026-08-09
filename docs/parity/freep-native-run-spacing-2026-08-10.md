# FreeP Native DrawingML Run Spacing - 2026-08-10

## Functional gap

PowerPoint ordinary DrawingML runs can author signed character spacing in
`a:rPr/@spc` and a kerning threshold in `a:rPr/@kern`. FreeP previously lost
both values during import and therefore changed the source run on save or an
in-canvas edit.

## Change

`Run` now preserves both controls as nullable integer values in hundredths of
a point. The PPTX reader/writer, model clones, rich clipboard payload, text
run splitting, and table-cell run merging all retain exact values and
omission. The package test also inspects the emitted `a:rPr` XML so the gate
does not rely on reader/writer symmetry.

## Scope

This slice establishes source and editing parity. It does not claim that the
WPF or Avalonia text engines yet consume these controls for glyph layout; the
authored values are available for a future renderer-owned spacing implementation.
