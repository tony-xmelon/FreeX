# FreeP Avalonia nested inline-table editing parity (2026-08-01)

## Functionality

The Avalonia rich-text surface already recognized an inline table as an object-replacement
run, but reduced each table-cell body to plain text while painting it. Nested inline tables,
cell-level run formatting, and other inline objects therefore survived the shared model and
clipboard round-trip without being visible in the editing surface.

Cell bodies now reuse the same shared visual-plan and text-run pipeline as the outer editor.
The recursive paint is clipped to the cell's resolved inset area and retains the existing
table geometry, cell anchors, spacing, and object-replacement offsets.

## Verification

- Avalonia rich-editor tests: 30/30.
- Headless nested-cell raster regression: 1/1.
- Shared visual planner and rich clipboard contracts: 16/16.

This is a functional/editor-surface slice. It makes nested content visible and preserves its
existing editing/clipboard model; it does not claim PowerPoint raster equivalence.
