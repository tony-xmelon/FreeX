# Cross-Target Command Matrix Slice

**Date:** 2026-06-08
**Scope owner:** cross-target command matrix
**Branch:** `codex/cross-target-command-matrix-20260608`

This slice turns the whole-ribbon "target-specific behavior" gap into a repeatable validation matrix. The command inventory already proves FreeX has no in-scope `Not Implemented` ribbon rows, but Excel parity still depends on what happens after the same command is invoked from different worksheet targets.

## Target Legend

| Target | Representative setup |
|---|---|
| Single cell | Active cell `B3` with adjacent populated cells. |
| Range | Multi-cell range `B3:D8`, including formulas, formats, comments, and blank cells. |
| Whole row/column | Row `5:5`, column `C:C`, and mixed row/column selections where Excel scopes a command differently. |
| Table | Structured table `SalesTable` over `A1:F12` with headers, totals row available, banded style, and table filters. |
| Filtered rows | AutoFilter or table filter hides at least one data row while the selection intersects visible and hidden rows. |
| Hidden row/column | Manually hidden row `7` and hidden column `D` next to visible boundaries. |
| Protected sheet | Sheet protected with no edit permissions, then with targeted permissions such as format rows, format columns, insert rows, delete rows, sort, AutoFilter, or edit objects. |
| Object target | Visible embedded chart, picture, drawing shape, text box, slicer/timeline, and PivotTable where supported. |

## Sample Workbook Recipe

Create one workbook with these sheets before running cross-target passes:

| Sheet | Purpose | Setup |
|---|---|---|
| `MatrixData` | Cells, ranges, rows, columns, filters, and hidden boundaries. | Headers in `A1:F1`; numeric, text, date, blank, formula, hyperlink, comment, validation, and conditional-format examples in rows 2-20; AutoFilter on `A1:F20`; hide row 7 and column D. |
| `SalesTable` | Structured table behavior. | Table `SalesTable` over `A1:F12`; style `TableStyleMedium2`; totals row toggle available; filter one category to hide rows. |
| `Protected` | Sheet-protection matrix. | Same data as `MatrixData`; protect once with no permissions, then repeat with one permission at a time. |
| `Objects` | Object and contextual command behavior. | Add one normal embedded chart, one picture, one rectangle, one text box, one PivotTable, and one slicer/timeline when the model supports it. |
| `PrintLayout` | Page layout commands. | Defined print area, manual page break, header/footer text, hidden row/column, and a filtered table. |

For live parity, run each command in Excel first and record visible enablement, selection expansion, dialog defaults, undo result, save/reopen persistence, and whether hidden or filtered rows are affected. Then run the same scenario in FreeX with the visual evidence harness.

## Representative Matrix

Status values:

| Value | Meaning |
|---|---|
| `Parity evidence` | Existing source/model/host tests exercise the target sufficiently for this planning pass. |
| `Needs live pass` | Existing source evidence exists, but the actual Excel-vs-FreeX UI workflow still needs visual capture. |
| `Needs guard` | A focused source/planner guard should be added after the owning production slice settles. |
| `Gap` | Behavior or evidence is missing enough that it should become a follow-up task. |
| `N/A` | Excel does not apply the command to that target, or FreeX intentionally scopes it elsewhere. |

| Priority | Command subset | Ribbon area | Single cell | Range | Whole row/column | Table | Filtered rows | Hidden row/column | Protected sheet | Object target | Current FreeX evidence | Next validation |
|---:|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Paste and Paste Special values/formulas/formats/transpose/arithmetic/link/column-widths/picture/text | Home / Clipboard | Parity evidence | Parity evidence | Needs live pass | Needs live pass | Gap | Needs guard | Needs live pass | Needs live pass for picture paste | `PasteCellsCommandTests.*`, `PasteSpecialCommandTests.*`, `ClipboardPastePlannerTests`, command-surface rows | Exercise filtered-table paste and hidden-row paste because Excel commonly distinguishes visible cells, table expansion, and column-width targets. |
| 2 | Sort A-Z/Z-A, custom sort, color sort | Home / Editing and Data / Sort & Filter | Needs live pass | Parity evidence | Needs live pass | Needs live pass | Needs guard | Needs guard | Needs live pass | N/A | `SortCommandTests`, `DataCommandSourceTests`, `FilterProtectionCommandTests` | Compare Excel's automatic current-region expansion, table-sort scoping, hidden-row retention, and protected-sheet sort permission behavior. |
| 3 | Filter / AutoFilter dropdown | Home / Editing and Data / Sort & Filter | Needs live pass | Needs live pass | N/A | Needs live pass | Parity evidence | Needs guard | Needs live pass | N/A | `FilterCommandTests`, `AutoFilterDropdownPlannerTests.*`, `FilterPromptPlannerTests`, current AutoFilter parity work | Capture Excel flyout behavior for single-column data, table filters, blanks, hidden rows, and protected sheets after the parent AutoFilter/grid slice settles. |
| 4 | Insert/Delete cells, rows, columns, sheets | Home / Cells | Parity evidence | Parity evidence | Parity evidence | Needs live pass | Needs guard | Needs guard | Parity evidence | N/A | `InsertDeleteCellsCommandTests`, `InsertDeleteRowsTests.*`, `SheetProtectionCommandTests`, `HomeCellsCommandSourceTests` | Add table insertion/deletion workflow capture, plus hidden-boundary row/column behavior after the parent grid integration lands. |
| 5 | Hide/Unhide row/column and AutoFit row/column | Home / Cells | N/A | Needs live pass | Parity evidence | Needs live pass | Needs guard | Needs guard | Parity evidence | N/A | `RowColumnDimensionPlannerTests`, `AutoFitPlannerTests`, `SheetProtectionCommandTests`, active grid hidden-boundary branch | Validate Excel hidden-boundary hit targets and AutoFit behavior over filtered, hidden, wrapped, and table cells. |
| 6 | Clear All/Formats/Contents/Comments/Hyperlinks | Home / Editing | Parity evidence | Parity evidence | Needs live pass | Needs live pass | Needs guard | Needs guard | Parity evidence | Needs live pass for selected object text/comment surfaces | `ClearContentsCommandTests`, `CommentCommandTests.Clear`, `HyperlinkCommandTests`, `ReviewCommandSourceTests` | Distinguish filtered-row clear, table data-body clear, and object/comment clear routes. |
| 7 | Font, fill, borders, number format, alignment, merge, wrap | Home / Font, Alignment, Number | Parity evidence | Parity evidence | Needs live pass | Needs live pass | Needs guard | Needs guard | Needs live pass | Needs live pass for object text/shape formatting | `ApplyStyleCommandTests`, `GroupedApplyStyleCommandTests`, `MergeCellsCommandTests`, Home command-source tests, Format Cells planner tests | Compare Excel selection expansion for whole rows/columns, visible-cell-only expectations after filtering, and protected-sheet format permissions. |
| 8 | Conditional Formatting and Data Validation | Home / Styles and Data / Data Tools | Parity evidence | Parity evidence | Needs live pass | Needs live pass | Needs guard | Needs guard | Parity evidence | N/A | `ConditionalFormatCommandTests`, `DataValidationCommandTests`, CF/Data Validation dialog planner tests | Capture table-range rebasing, filtered-row rendering, hidden-row persistence, and protected-sheet rejection messages. |
| 9 | Format as Table, table style options, totals row, convert to range | Home / Styles and contextual Table Design | N/A | Parity evidence | Gap | Parity evidence | Parity evidence | Needs guard | Needs live pass | N/A | `StructuredTableCommandTests.*`, `HomeFormatAsTableCommandSourceTests`, `TableDesignCommandSourceTests` | Run live Excel/FreeX table workflows for selected ranges, entire columns, filtered table rows, totals row toggles, and protected sheets. |
| 10 | Insert chart, Recommended Charts, Change Chart Type, Select Data | Insert / Charts and contextual Chart Design | Needs live pass | Parity evidence | Needs live pass | Needs live pass | Needs guard | Needs guard | Needs live pass | Parity evidence for chart target | `ChartCommandTests.*`, `ChartCommandSourceTests`, `ChartDialogTests`, chart contextual branch evidence | Validate data-source selection expansion, filtered/hidden data plotting defaults, protected-sheet chart edits, and contextual tab visibility after chart selection. |
| 11 | Insert picture/shape/text box, arrange, selection pane, crop/resize/rotate | Insert / Draw and object context | Needs live pass | Needs live pass | Needs live pass | Needs live pass | N/A | Needs guard | Parity evidence for edit-object permission | Parity evidence | `PictureCommandTests`, `ShapeCommandTests`, `SelectionPanePlannerTests.*`, `DrawCommandSourceTests`, active draw/object slice | Compare Excel object anchoring to cells/ranges, hidden-row/column movement/resizing, protected-sheet edit-object gating, and z-order behavior. |
| 12 | PivotTable insert/refresh, slicer/timeline, field list, PivotChart | Insert and contextual Pivot tabs | Needs live pass | Parity evidence | Needs live pass | Needs live pass | Needs live pass | Needs guard | Needs live pass | Parity evidence for pivot target | `PivotTableCommandTests.*`, `PivotUiPlannerTests.*`, `SlicerTimelinePlannerTests`, contextual pivot ribbon tests | Capture table vs range source defaults, protected-sheet pivot refresh/edit behavior, slicer/timeline filters, and PivotChart contextual separation. |
| 13 | Page setup, print area, page breaks, scale, print titles, headers/footers | Page Layout | Needs live pass | Parity evidence | Parity evidence | Needs live pass | Needs guard | Needs guard | Needs live pass | Needs live pass for chart/object print output | `PageLayoutCommandTests.*`, `PrintLayoutPlannerTests`, `ExportPlannerTests.*`, Page Layout parity slice | Use `PrintLayout` sheet to compare print preview/export visuals over hidden rows, filtered tables, chart objects, and selected ranges. |
| 14 | Protect Sheet/Workbook, allowed edit permissions | Review / Protect | Parity evidence | Parity evidence | Parity evidence | Needs live pass | Needs live pass | Parity evidence | Parity evidence | Parity evidence for edit objects | `SheetProtectionCommandTests`, `WorkbookProtectionCommandTests`, `FilterProtectionCommandTests`, Review protection tests | Build the permission-by-command matrix so each command above has a protected-sheet expectation rather than ad hoc rejection text checks. |

## Findings

1. Existing automated evidence is command-family oriented, not target-oriented. It is good at proving the command model works, but weak at proving the same command behaves correctly on rows, columns, tables, hidden boundaries, filtered rows, and objects.
2. The highest-risk uncovered axis is filtered rows. Excel often applies command-specific semantics: some commands affect all cells in the range, some visible cells only through explicit UI choices, and some expand table ranges. FreeX evidence is currently strongest for filter planning itself, not for downstream commands executed while rows are filtered.
3. Hidden row/column behavior is split between model metadata and live grid interaction. The parent grid integration should settle before adding more tests here, but the matrix makes hidden-boundary follow-up explicit for paste, sort, clear, formatting, charts, objects, and print/export.
4. Protected-sheet behavior has a solid model-test base, but it needs a command-by-command permission table tied back to ribbon enablement and Excel messages.
5. Object-target parity needs separate treatment from worksheet selection parity. Chart, PivotTable, picture, shape, text box, slicer, and timeline commands become visible through contextual or side-pane surfaces, so the matrix must record the selected object and the active contextual tab.

## Low-Risk Repeatability Guard

This branch adds `CrossTargetCommandMatrixDocumentTests` to keep the matrix usable:

| Guard | Purpose |
|---|---|
| `CrossTargetMatrix_DocumentsRequiredTargetColumnsAndRepresentativeCommands` | Verifies the main matrix keeps the required target columns and high-priority command subsets. |
| `CrossTargetMatrix_PrioritizedNextValidationKeepsHighestRiskAxesFirst` | Verifies the follow-up queue keeps filtered rows, hidden boundaries, protected sheets, and object/contextual targets visible. |

## Prioritized Next Commands and Targets

| Rank | Command/target pair | Why first |
|---:|---|---|
| 1 | Paste/Paste Special on filtered rows, table data-body ranges, and hidden rows/columns | This is the most user-visible Excel mismatch risk and overlaps the original AutoFilter report. |
| 2 | AutoFilter flyout on single-cell data, table header, hidden rows, and protected sheet | The popup/dropdown harness and parent filter work can provide direct visual proof. |
| 3 | Sort on current region, filtered table, hidden rows, and protected sheet with sort permission | Sort changes row order and metadata; mistakes are destructive and visually obvious. |
| 4 | Insert/Delete/Hide/Unhide/AutoFit on whole rows/columns with hidden boundaries | Parent grid work is already in flight, so this is ready for focused follow-up once merged. |
| 5 | Clear and formatting commands on filtered ranges and table ranges | Broad Home coverage exists, but filtered/table semantics are not yet first-class validation axes. |
| 6 | Chart insertion and contextual chart commands from range, table, filtered range, and hidden data | Chart branches added command affordances; source-target behavior still needs live parity proof. |
| 7 | Picture/shape/text-box anchoring and arrangement over hidden rows/columns and protected sheets | Draw/object owner can use this matrix to prioritize object target evidence. |
| 8 | PivotTable and slicer/timeline workflows from range vs table, then protected sheet | Pivot/source selection and contextual behavior need explicit Excel comparison. |
| 9 | Page Layout print area/page breaks/export over filtered tables, hidden rows, and objects | Print/export is high impact, but less likely to corrupt workbook state than paste/sort/delete. |
