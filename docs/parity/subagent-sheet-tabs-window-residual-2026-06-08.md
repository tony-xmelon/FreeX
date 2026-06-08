# Sheet Tabs And Workbook Window Residual

## Scope

- Compared worksheet tab rename, selection, hide/unhide, and move affordances against Microsoft Excel support guidance.
- Compared workbook window Hide/Unhide behavior against Microsoft Excel support guidance.
- Kept the patch bounded to workbook-window Unhide selection; sheet-tab rename, click/drag move, grouped selection, context-menu Hide/Unhide, and focused-tab keyboard context affordances were already covered by existing host tests.

## Expected Excel Behavior

- Sheet tabs can be renamed by double-clicking a tab or by using the tab context menu Rename command.
- A tab context menu can Hide a sheet, and Unhide presents a list of hidden sheets.
- Adjacent worksheet tabs can be selected with Shift, nonadjacent tabs with Ctrl, and all tabs from the tab context menu.
- Sheets can be moved by dragging tabs or through the tab context move/copy surface.
- Workbook windows use View > Window > Hide and Unhide; when Unhide is invoked, Excel asks the user to select a hidden workbook window from a list.

## FreeX Result

- Already covered: sheet-tab double-click rename, right-click selection reset, Shift/Ctrl grouping planner behavior, Hide/Unhide sheet dialog behavior, focused sheet-tab Menu-key routing, and drag cleanup/source hygiene.
- Implemented: workbook-window Unhide now builds Excel-numbered hidden-window choices and routes through an `UnhideWindowDialog` instead of always restoring the first hidden window.
- Added focused tests for the hidden-window selection planner and dialog source/interaction behavior.

## Remaining Gaps

- The sheet-tab context surface still has no full Excel Move or Copy dialog parity in this slice; existing FreeX behavior supports drag and explicit move-left/move-right commands.
- Switch Windows still cycles to the next registered window rather than exposing a selectable window list/dropdown.
