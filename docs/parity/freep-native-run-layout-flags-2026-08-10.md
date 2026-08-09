# FreeP Native DrawingML Run Layout Flags - 2026-08-10

## Functional gap

PowerPoint's ordinary DrawingML run properties can carry nullable
`a:rPr/@kumimoji`, `@smtClean`, and `@normalizeH` flags. FreeP previously
dropped those authored tokens on import, which made a save/reopen or an
in-canvas edit change the source run metadata.

## Change

The shared `Run` model now preserves each flag as nullable state. The PPTX
reader and writer retain omission versus explicit `0`/`1`, and model clones,
rich clipboard payloads, text-run splitting, and table-cell run merging carry
the flags without treating them as visual properties.

## Scope

This slice preserves source semantics and does not claim a Japanese-layout,
smart-tag, or normalized-height rendering engine. Any future renderer support
can consume the explicit model state without first losing the authored token.
