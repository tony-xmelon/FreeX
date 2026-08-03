# FreeW undoable table formatting controls (2026-08-03)

## Gap

WPF table-cell shading, complete border payloads, cell text direction, and the seven Table Style Options
toggles mutated the model directly. Avalonia already used shared commands for shading, edge borders, and
table formatting, but its text-direction path was also direct. These accepted formatting actions therefore
had inconsistent or missing undo behavior across hosts.

## Change

- WPF cell shading now uses the existing shared `SetCellShadingCommand`.
- Added shared reversible commands for a complete `CellBorders` payload and `CellTextDirection` source token.
- WPF and Avalonia cell text direction now use the same command.
- WPF header row, banded rows, repeat header, last row, first/last column, and banded columns now use the
  existing shared `SetTableFormattingCommand`.
- All routes continue to resolve the exact table/row/cell before execution and remain no-ops outside tables.

## Verification

- Core `SetCellShadingBordersCommandTests`: 15/15 passed.
- WPF `TableStyleGalleryTests`: 11/11 passed, including four host-level undo paths.
- Avalonia table contextual direction/header tests: 2/2 passed.
- DOCX round trips for cell shading, border payload, text direction, and style toggles: 4/4 passed.
- `git diff --check`: passed.

This closes functional undo inconsistencies without changing package tokens or renderer behavior.
