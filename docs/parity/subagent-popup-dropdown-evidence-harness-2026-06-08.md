# Popup/Dropdown Evidence Harness Parity Slice - 2026-06-08

## Scope

This slice investigated the visual-evidence harness gap for transient Excel/FreeX surfaces: ribbon dropdowns, AutoFilter flyouts, worksheet context menus, and native file dialogs. It intentionally avoided product UI code because grid/review/chart/formula/data/draw/titlebar work is active in neighboring branches.

## Findings

- Existing `tools/screenshot_excel.ps1` and `tools/screenshot_ribbon.ps1` capture only the top window band after selecting each ribbon tab.
- The scripts already block global input unless the expected application window owns foreground focus, which is the right safety baseline for any future live popup runner.
- Owner-window ribbon captures are not sufficient for transient surfaces. WPF/Win32 popup, context-menu, and native-dialog windows must be captured from the active popup/dialog/menu bounds, or from a guarded full-screen crop that includes the popup anchor.
- The highest-value first concrete scenario remains the table/AutoFilter header dropdown because it directly exercises Excel-like sort/filter flyout behavior, checklist search/select-all behavior, blanks, and submenu routing.

## Changes

- Added an `InteractiveCapturePlan` section to both screenshot script manifests.
- The plan makes five paired Excel/FreeX transient scenarios machine-readable:
  - `popup:table-autofilter-dropdown`
  - `dropdown:home-number-format`
  - `context-menu:worksheet-cell`
  - `native-dialog:open-workbook`
  - `native-dialog:save-as-workbook`
- Each scenario declares priority, evidence family, output naming, pair key pattern, trigger, capture requirement, foreground guard, and counterpart subject.
- Added source tests so future harness changes keep this transient-surface plan present in both scripts.
- Added a concise catalog note to `UI-CMD-HARNESS-001`.
- Added the first concrete in-app FreeX popup capture path: `FREEX_AUTOFILTER_FLYOUT_TOUR=1` seeds a `score` AutoFilter range, opens the production modeless AutoFilter flyout, captures `screenshots/autofilter-flyout-tour/freex_table_autofilter_dropdown.png`, and writes `autofilter_flyout_tour_manifest.json` with pair key `interactive:table-autofilter-dropdown:opened`.
- Added the paired Excel popup capture path: `FREEX_EXCEL_AUTOFILTER_FLYOUT_TOUR=1` seeds the same `score` range in Microsoft Excel, opens the header AutoFilter dropdown with a foreground-guarded header-arrow click, captures `screenshots_excel/autofilter-flyout-tour/interactive_table_autofilter_dropdown_opened.png`, and writes `excel_autofilter_flyout_tour_manifest.json` with the same pair key.
- Added the first concrete FreeX Home number-format dropdown capture path: `FREEX_HOME_NUMBER_FORMAT_DROPDOWN_TOUR=1` opens the production Home `NumberFormatBox`, captures the open WPF ComboBox popup child at `screenshots/home-number-format-dropdown-tour/freex_dropdown_home_number_format_opened.png`, and writes `home_number_format_dropdown_tour_manifest.json` with pair key `interactive:home-number-format:opened`.
- Added the paired Excel Home number-format dropdown capture path: `FREEX_EXCEL_NUMBER_FORMAT_DROPDOWN_TOUR=1` seeds a numeric A1 sample in Microsoft Excel, expands the Home `NumberFormatGallery` ComboBox through UI Automation, captures `screenshots_excel/home-number-format-dropdown-tour/interactive_home_number_format_opened.png`, and writes `excel_home_number_format_dropdown_tour_manifest.json` with the same pair key.
- Added the first concrete FreeX worksheet-cell context-menu capture path: `FREEX_WORKSHEET_CONTEXT_MENU_TOUR=1` opens the production worksheet-cell `ContextMenu` for A1, captures `screenshots/worksheet-context-menu-tour/freex_context_menu_worksheet_cell_opened.png`, and writes `worksheet_context_menu_tour_manifest.json` with pair key `interactive:worksheet-cell-context-menu:opened`.
- Added the paired Excel worksheet-cell context-menu capture path: `FREEX_EXCEL_WORKSHEET_CONTEXT_MENU_TOUR=1` seeds/selects B2 in Microsoft Excel, opens the worksheet context menu with a foreground-guarded `Shift+F10`, captures `screenshots_excel/worksheet-context-menu-tour/interactive_worksheet_cell_context_menu_opened.png`, and writes `excel_worksheet_context_menu_tour_manifest.json` with the same pair key.
- Added the Excel native Open dialog capture path: `FREEX_EXCEL_OPEN_WORKBOOK_DIALOG_TOUR=1` opens Microsoft Excel's native `Open` common dialog with foreground-guarded `Ctrl+F12`, captures `screenshots_excel/open-workbook-dialog-tour/interactive_open_workbook_dialog_opened.png`, and writes `excel_open_workbook_dialog_tour_manifest.json` with pair key `interactive:open-workbook-dialog:opened`.
- Added the paired FreeX native Open dialog capture path: `FREEX_OPEN_WORKBOOK_DIALOG_TOUR=1` opens the FreeX native Open dialog with foreground-guarded `Ctrl+O`, captures `screenshots/open-workbook-dialog-tour/freex_open_workbook_dialog_opened.png`, and writes `freex_open_workbook_dialog_tour_manifest.json` with pair key `interactive:open-workbook-dialog:opened`.
- Added the FreeX native Save As dialog capture path: `FREEX_SAVE_AS_WORKBOOK_DIALOG_TOUR=1` opens the FreeX native `Save As` common dialog with foreground-guarded `F12`, captures `screenshots/save-as-workbook-dialog-tour/freex_save_as_workbook_dialog_opened.png`, and writes `freex_save_as_workbook_dialog_tour_manifest.json` with pair key `interactive:save-as-workbook-dialog:opened`.
- Added the paired Excel Save As dialog capture path: `FREEX_EXCEL_SAVE_AS_WORKBOOK_DIALOG_TOUR=1` opens Microsoft Excel's foreground `F12` Save As surface, captures `screenshots_excel/save-as-workbook-dialog-tour/interactive_save_as_workbook_dialog_opened.png`, and writes `excel_save_as_workbook_dialog_tour_manifest.json` with the same pair key. In this Office build the first Excel Save As surface is an Excel-owned `NUIDialog`, not a Windows `#32770` common dialog.

## Observed Parity Findings

- `interactive:worksheet-cell-context-menu:opened`: Excel's default worksheet-cell context menu is shorter and focused on core cell actions (`Cut`, `Copy`, paste options, `Insert...`, `Delete...`, `Clear Contents`, `Quick Analysis`, `Filter`, `Sort`, comments/notes, `Format Cells...`, picker/dropdown, names, links). FreeX's default worksheet context menu exposes a much longer 50-command set including row/column sizing, table/data-validation/text-to-columns/remove-duplicates, hide/unhide, and comment/note variants; the live FreeX capture reaches the screen-height viewport before the lower items are visible. This is now documented as a follow-up product parity discrepancy, separate from the harness capture work.
- `interactive:open-workbook-dialog:opened`: both products route to the Windows common `Open` dialog with the expected navigation chrome, file list, file-name input, filter selector, and `Open`/`Cancel` buttons. Excel's captured dialog opens wider/taller on the same desktop, while FreeX opens a smaller dialog and uses the `All supported files` filter label. The FreeX capture path now records dialog DPI and scales the crop so WPF-owned native dialogs are not truncated by logical/physical coordinate conversion.
- `interactive:save-as-workbook-dialog:opened`: Excel `F12` first opens an Office `Save this file` dialog (`NUIDialog`) with a filename field, `.xlsx` suffix, location chooser, `More options...`, `Save`, and `Cancel`. FreeX `F12` opens the Windows common `Save As` dialog directly with filesystem navigation, `Book1.xlsx` selected, file-type selector, `Save`, and `Cancel`. This is now documented as a product parity follow-up: FreeX currently skips Excel's intermediate Office Save As surface.

## Remaining Limitations

- This slice now has paired FreeX and Microsoft Excel capture hooks for `interactive:table-autofilter-dropdown:opened`, `interactive:home-number-format:opened`, `interactive:worksheet-cell-context-menu:opened`, `interactive:open-workbook-dialog:opened`, and `interactive:save-as-workbook-dialog:opened`.
- The live Excel Home number-format capture initially blocked because `i5-32gb - Remote Desktop Connection` retained foreground ownership; after minimizing that foreground window, `FREEX_EXCEL_NUMBER_FORMAT_DROPDOWN_TOUR=1` completed and produced the paired Excel artifact.
- The eventual runner should open one scenario at a time, verify foreground ownership before every input, verify the popup/dialog/menu target before capture, and delete partial artifacts if ownership drifts.
- Native dialogs may legitimately change the foreground title/class; the runner needs dialog-aware ownership validation instead of the current owner-window title equality check.
