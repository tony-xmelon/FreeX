# Formula Bar and Name Box Residual Parity - 2026-06-08

## Scope

Validated a bounded interactive residual around the formula bar and name box:

- Name box display for active cells, typed references, typed defined names, and canceled edits.
- Name box navigation to cell references, ranges, and workbook named ranges.
- Formula bar synchronization with inline edits and Enter/Escape commit/cancel behavior via the existing host tests.
- Selection synchronization after name-box and Go To navigation.

## Excel Behavior Compared

Representative Excel behavior used for this pass:

- Typing a cell reference in the Name Box and pressing Enter navigates to that cell and returns focus to the worksheet.
- Typing a range reference selects that range, with the formula bar showing the top-left cell content.
- Typing a valid new name while a range is selected defines that name for the selected range.
- Typing an existing defined name navigates to the full named range.
- When the selected cell or the entire selected range exactly matches a defined name, Excel displays that defined name in the Name Box; partial selections continue to display the active address/range.
- Escape in the Name Box cancels the typed draft and restores the current selection's display.

Microsoft's Name Box documentation confirms named ranges can be selected through the Name Box; Excel training/reference material confirms the selected named range's name is displayed when the full range is selected.

## FreeX Finding

FreeX already supported the important behaviors for typed references, typed defined names, new-name definition, formula bar commit/cancel, and formula bar/inline-editor synchronization.

The residual gap was display-only but visible: after navigating to an existing named range, or canceling a Name Box draft while an exact named range was selected, FreeX showed the raw address text such as `B2:C3` instead of the defined name such as `SalesData`.

## Fix

Added a small name-box display formatter that:

- Returns the alphabetically first workbook defined name whose range exactly equals the selected range.
- Falls back to the existing formatted A1/R1C1 range text when no exact defined-name match exists.
- Is used for active-cell selection, range selection, Go To selection, option refresh, and Escape restore.

Formula editing behavior was not changed.

## Verification Added

Added/updated focused host tests around:

- Name-box navigation to defined ranges preserving the canonical defined-name display.
- Case-insensitive and padded defined-name input restoring the workbook's defined-name casing.
- Exact single-cell defined names displaying the name when selected.
- Escape restore displaying the defined name for an exact named-range selection.
- Go To source refresh using the same name-box selection formatter.

## Remaining Gaps

- The Name Box drop-down list itself is still not modeled as an Excel-like selectable list of defined names, tables, and objects.
- Table/object names in the Name Box remain out of scope for this slice.
- Ambiguous overlapping names are resolved deterministically by alphabetic name order; this is sufficient for stable FreeX behavior but has not been exhaustively compared against every Excel duplicate/overlap scenario.
