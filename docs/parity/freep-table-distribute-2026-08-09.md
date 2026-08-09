# FreeP Table Distribution

FreeP now exposes PowerPoint-style **Distribute Rows** and **Distribute Columns** commands in the contextual table ribbon.

Both commands operate on the selected table when an active cell is present. They redistribute the complete row-height or column-width vector evenly, preserve the exact total in EMU by assigning any integer remainder from the first item forward, and record one undoable command. WPF and Avalonia route the same shared `EditingSession` operation.

This is a functional parity slice only; it makes no new Word raster-fidelity claim. The focused model, WPF command registry, and Avalonia headless ribbon tests cover execution, total preservation, and undo restoration.
