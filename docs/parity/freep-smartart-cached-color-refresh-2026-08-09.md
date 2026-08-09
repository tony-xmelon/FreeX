# FreeP SmartArt cached Change Colors refresh - 2026-08-09

FreeP's SmartArt Change Colors command already rewrites the native diagram colors
part and remains undoable when an imported graphic has no parsed data model. The
cache-only route previously left the in-memory `dsp:drawing` fallback unchanged,
so the command could succeed while the visible graphic stayed on the old palette
until a reopen or external cache regeneration.

The shared authoring planner now applies the selected palette to simple cached
node shapes immediately when the SmartArt has no data model. It only touches
solid-filled AutoShape nodes that carry text; effectful and picture-only cached
content remains on the conservative existing path. Native package colors remain
authoritative and undo restores both the package metadata and cached node fill.

Focused coverage asserts the cache-only command changes the visible fallback and
keeps the native colors part plus the shared undo path intact. This is a functional
editing fix; it makes no PowerPoint pixel-baseline claim.
