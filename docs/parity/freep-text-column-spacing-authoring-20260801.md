# FreeP Text-Column Spacing Authoring

Date: 2026-08-01

## Function slice

PowerPoint text frames already preserved `a:bodyPr/@spcCol` and both renderers
already consumed `TextBody.ColumnSpacingEmu`, but users could only change the
column count. FreeP now exposes a shared Column Spacing ribbon control in WPF
and Avalonia. Values are parsed as 0-144 pt, converted to EMU, and applied to
all selected text shapes as one undoable operation. Existing column count and
all other text-frame properties remain unchanged.

## Verification

- spacing parser: valid point conversions and invalid bounds covered
- spacing command: apply/undo/redo covered
- editing-session selection route covered
- WPF/Avalonia ribbon definitions expose the same options
- WPF and Avalonia ribbon command routes covered

This closes the authoring gap for explicit spacing; arbitrary freeform numeric
entry remains outside the fixed option control.
