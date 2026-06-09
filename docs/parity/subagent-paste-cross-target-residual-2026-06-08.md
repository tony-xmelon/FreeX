# Paste Cross-Target Residual - 2026-06-08

## Scope

Worker slice for Paste/Paste Special behavior across source and destination targets with:

- filter-hidden source rows,
- structured table data-body selections,
- hidden destination rows and columns,
- cross-sheet internal paste/Paste Special command paths.

Out of scope for this slice: AutoFilter flyout UI, PageLayout, status/footer, Insert table/pivot, Formula UI, Draw UI, titlebar/QAT, chart contextual commands, data import, and protected-sheet command-matrix work.

## Excel Behavior Assumptions

No live Excel session was used.

Microsoft support documents the default copy behavior as including hidden or filtered cells in addition to visible cells unless the user explicitly chooses visible cells only. It also documents paste as landing copied data into consecutive rows or columns, with hidden destination rows/columns requiring unhide to inspect all pasted cells.

References:

- [Copy visible cells only](https://support.microsoft.com/en-us/office/copy-visible-cells-only-6e3a1f01-2884-4332-b262-8b814412847e)
- [Move or copy cells, rows, and columns](https://support.microsoft.com/en-us/office/move-or-copy-cells-rows-and-columns-3ebbcafd-8566-42d8-8023-a2ec62746cfc)

Given those docs, this slice treats normal internal paste as rectangular by default:

- filter-hidden source rows remain part of the copied source rectangle,
- structured table data-body selections remain rectangular unless a future explicit visible-cells-only selection/payload is introduced,
- manually hidden/filter-hidden destination rows and hidden destination columns are still written by Paste/Paste Special because the paste footprint is consecutive.

## Implemented Coverage

Added focused model tests for:

- cross-sheet internal paste from a filter-hidden source row range, proving hidden filtered rows paste by default;
- cross-sheet internal paste from a structured table data-body range with a filter-hidden row, proving the data-body payload remains rectangular and formulas rebase against the actual destination;
- cross-sheet paste into hidden destination row and hidden destination column, proving hidden metadata is retained while cells are written;
- Paste Special arithmetic across sheets into a hidden destination row;
- Paste Special formats across sheets into a hidden destination column.

## Remaining Gaps

Explicit visible-cells-only copy/paste is not modeled as a distinct internal clipboard payload in this slice. Supporting it correctly for filtered structured table data bodies would need a source capture representation that can distinguish original source addresses from compressed visible-cell clipboard positions so formulas can still rebase from their original cells.
