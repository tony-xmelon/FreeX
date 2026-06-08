# View Tab Residual Sweep - 2026-06-08

Worker branch: `codex/view-tab-residual-20260608`

## Scope

Residual sweep for View tab command/source parity:

- Workbook views: Normal, Page Break Preview, Page Layout, Custom Views.
- Show toggles: Gridlines, Headings, Ruler, Formula Bar.
- Zoom: Zoom, 100%, Zoom to Selection, preset/custom menu.
- Panes: Freeze Panes menu and Split.
- Windows: New Window, Arrange All, Switch Windows, Hide, Unhide, View Side by Side, Synchronous Scrolling, Reset Window Position.

Status/footer implementation files were treated as owned by the status-footer worker and were not edited.

## Findings And Fixes

- Fixed the View > Freeze Panes ribbon button to open its menu instead of immediately executing the selection-based freeze action. The menu items remain the concrete command targets for Freeze Panes, Freeze Top Row, Freeze First Column, and Unfreeze Panes.
- Added focused source coverage for View workbook view buttons and Show toggles so their localized labels, command names, keytips, and handlers are guarded alongside the existing zoom/window coverage.
- Added source coverage that workbook views route through `SetWorksheetViewModeCommand`, sheet display toggles route through `SetWorksheetViewOptionsCommand`, and Formula Bar visibility persists through `FreeXOptions`.

## Existing Coverage Confirmed

- `MainWindowRibbonKeyTipTests.View*` already covers workbook view keytips, Show prefix routing, Ruler page-layout gating, zoom presets/100%/selection, Freeze Panes menu keytips, Split toggle keytips, Arrange All keytips, and single-window disabled state for multi-window commands.
- `docs/testing/ui-test-catalog.md` already has View command rows for workbook views/show toggles, custom views, freeze/split, and zoom/window commands.
- No View-tab Status Bar toggle is present in the current source; status surface and status zoom behavior are tracked in status-footer/status-bar rows and were left untouched.

## Remaining Gaps

- Broader render proof for hidden gridlines/headings/ruler/formula-bar states.
- Freeze/split visual geometry, pane scrolling, drag dividers, and active-pane behavior.
- Status zoom slider/buttons and status surface behavior remain with status-footer work.
- Custom Views persistence/render round trip remains broader than this residual source sweep.
