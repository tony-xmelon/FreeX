# FreeP Table Row and Column Commands

FreeP now exposes table row and column insertion/deletion through the contextual ribbon in both WPF and Avalonia:

- Insert Row Above / Below
- Insert Column Left / Right
- Delete Row / Delete Column

The commands reuse the existing model operations, active-cell selection, merged-cell handling, and undo stack. Avalonia keeps its inline table-cell editor route; WPF and Avalonia both consume active-cell-gated `EditingSession` wrappers. This is a functional parity slice only and makes no new Word raster-fidelity claim.
