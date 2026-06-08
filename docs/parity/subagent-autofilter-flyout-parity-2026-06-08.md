# AutoFilter Flyout Parity Slice - 2026-06-08

## Scope

Worker branch: `codex/autofilter-flyout-parity-20260608`

Integrated into aggregate branch: `codex/autofilter-excel-behavior-20260606`

Owned area: `AutoFilterDropdownPlanner`, `AutoFilterDialog`, focused App.Host AutoFilter tests.

## Evidence

Excel is installed at `C:\Program Files\Microsoft Office\Root\Office16\EXCEL.EXE`. A throwaway COM/UI Automation pass created a one-column workbook and confirmed the header dropdown is exposed by Excel as an in-cell menu item named `No filter applied`. Attempts to invoke and scrape the full popup timed out, so the remaining parity decisions use the user's screenshot plus stable Excel AutoFilter behavior: sort commands first, clear/filter commands next, then an in-place search field, select-all, and the value checklist.

## Changes

- Removed the standalone visible Search label from the dialog surface and put the search affordance on the textbox via UI Automation name/help/access key.
- Hid `Add current selection to filter` until search text is active, then disabled it when the search has no visible matches.
- Disabled `(Select All)` and the checklist when a search returns no values.
- Added enabled state to AutoFilter menu entries and disabled `Clear Filter From "..."` when the filter range has no filter-hidden rows.
- Preserved the aggregate branch's existing Excel-style checklist ordering, including same-type sorting and blanks at the bottom.
- Added a focused FreeX visual evidence hook: `FREEX_AUTOFILTER_FLYOUT_TOUR=1` opens the actual modeless AutoFilter dialog for a `score` range with values 1-4 plus a blank row, captures `freex_table_autofilter_dropdown.png`, and records the pair key `interactive:table-autofilter-dropdown:opened`.

## Remaining Gaps

- Per-column clear-filter state is approximated from `Sheet.FilterHiddenRows` in the current range because the model does not retain which column produced the hidden rows.
- The Excel popup could not be fully scraped in this session after invocation, so the paired Excel transient capture and submenu pixel/layout parity remain future visual evidence items.
