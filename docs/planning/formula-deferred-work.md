# Formula Deferred Work

This file records formula-engine limitations that predate the repository's inline deferred-work reference convention.

## H28 3-D Sheet-Span Structural Rewrites

`FormulaRewriter` preserves 3-D sheet-span references during row, column, cell-move, and related structural edits because the current rewrite math does not model each sheet in the span. Rename and delete operations have dedicated handling, and paste offset and transpose remain well-defined. Full per-sheet structural rewriting is deferred until those operations can preserve Excel-compatible behavior for every sheet in the span.

The source marker remains in its historical H28 form so this documentation mapping is deliberately exact. New deferred-work markers must use the repository's standard inline `TODO(owner)` form with a direct documentation reference.
