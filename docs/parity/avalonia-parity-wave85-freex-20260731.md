# FreeX Avalonia parity Wave 85: formula-point cancel lifecycle

Date: 2026-07-31

## Finding

WPF's formula-bar Cancel button used the complete formula-edit cancellation path:
it restored the source cell selection, cleared point-mode and multi-area range-entry
state, refreshed the committed value, and returned keyboard focus to the worksheet.
Avalonia's Escape route already did this, but its visible formula-bar Cancel button
only cleared the session edit marker and refreshed the shell. After Shift+F8 or a
cross-sheet point selection, the button could therefore leave stale range-entry state
and focus in the formula bar.

## Change and evidence

Avalonia's formula-bar Cancel button now routes through the existing full cancel helper,
matching the WPF button and Escape behavior while preserving Wave 84 directional-anchor
handling for keyboard point selection.

Focused paired evidence covers a real named WPF Cancel button click and a real rendered
Avalonia Cancel button click after Shift+F8 plus keyboard-created multi-area formula
pointing. Both restore the committed source value, collapse the selection to the source
cell, clear point mode, and return focus to the worksheet.
