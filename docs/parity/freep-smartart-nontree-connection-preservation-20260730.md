# FreeP SmartArt non-tree connection preservation - 2026-07-30

## Function slice

SmartArt data-part regeneration now preserves authored non-tree `dgm:cxn` relationships,
including `presOf` and `presParOf`, when both endpoints remain live after an outline edit.
Regenerated `parOf` hierarchy edges continue to come from the shared model; unrelated authored
relationships are copied with their original attributes and ids instead of being silently
dropped. Connections whose endpoints were removed are omitted to avoid dangling package data.

## Verification

- `SmartArtEditingPlannerTests`: 126/126.
- The focused regression asserts a regenerated `parOf` edge and a preserved `presOf` edge.

This is a functional/package-authoring slice. It makes no visual-rendering claim.
