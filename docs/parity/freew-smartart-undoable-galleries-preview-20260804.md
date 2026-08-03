# FreeW SmartArt Undoable Galleries And Preview

Date: 2026-08-04

## Scope

WPF SmartArt layout and color galleries changed the model outside the undo bus. All three galleries
also applied their hover preview as a permanent mutation; style hover could create undo entries.

WPF now uses the shared `SetSmartArtLayoutCommand`, `SetSmartArtColorCommand`, and
`SetSmartArtStyleCommand` for click commits. Hover stores one complete SmartArt visual-selection
snapshot, applies a transient preview, and restores layout, kind, color, and style on leave. Clicking
first restores the preview and then records one undoable command.

Avalonia already consumes the same shared commands. Node content, object placement, dimensions, and
the other gallery-owned fields remain stable when one gallery value changes.

## Verification

- Core `SmartArtEditCommandTests`: 7/7 passed, including layout/color apply, undo, redo, and
  unrelated-state preservation.
- Focused WPF ribbon and gallery tests: 2/2 passed for layout/color commit undo/redo and transient
  layout/color/style preview leave-revert.
- Focused Avalonia `ChartSmartArtContextualTabTests`: 2/2 passed as the cross-host command control.

No Word COM baseline is required because SmartArt layout rendering and package serialization are not
changed by this command/preview ownership slice.
