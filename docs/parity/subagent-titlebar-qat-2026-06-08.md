# Titlebar and QAT Parity Subagent - 2026-06-08

## Scope

- Validated workbook title formatting, dirty marker placement, titlebar system-button automation, Quick Access Toolbar ordering, location, and keytip behavior.
- Avoided status bar, View tab commands, Backstage save/recent files, formula bar/name box, chart, formula auditing, grid resize/unhide, slicer/timeline, and Review proofing/comment ownership areas.

## Findings Addressed

- Titlebar minimize, maximize/restore, and close buttons now expose stable automation IDs (`MinimizeBtn`, `MaxRestoreBtn`, `CloseSysBtn`) plus localized automation help text.
- The maximize/restore button now refreshes automation help text together with its dynamic automation name when the window changes between normal and maximized states.
- QAT source-level WPF coverage now proves configured command order, visible keytip sequence (`1` through `9`, then `01`), below-ribbon placement, and chrome hit-test behavior for titlebar versus below-ribbon locations.

## Existing Coverage Confirmed

- `WorkbookTitleFormatterTests` covers workbook name, dirty marker, grouped-sheet marker, and multi-window suffix ordering.
- Existing QAT tests cover direct `Alt+1/2/3` Save/Undo/Redo routing, disabled keytip guards, custom below-ribbon QAT routing, and prefix-safe generated keytips.
- Existing window chrome source tests cover minimize, maximize/restore, and close command routing to WPF `SystemCommands`.

## Remaining Gaps

- Live foreground evidence for native window drag, Alt+Space/system menu behavior, and mouse-level minimize/maximize/close clicks remains open.
- Dirty marker clearing when undo returns exactly to the last saved state remains a product gap; the current command stack exposes undo/redo availability but not a saved revision marker.
