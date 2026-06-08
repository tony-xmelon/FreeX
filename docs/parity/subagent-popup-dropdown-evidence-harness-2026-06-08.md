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
- The plan makes four paired Excel/FreeX transient scenarios machine-readable:
  - `popup:table-autofilter-dropdown`
  - `dropdown:home-number-format`
  - `context-menu:worksheet-cell`
  - `native-dialog:open-workbook`
- Each scenario declares priority, evidence family, output naming, pair key pattern, trigger, capture requirement, foreground guard, and counterpart subject.
- Added source tests so future harness changes keep this transient-surface plan present in both scripts.
- Added a concise catalog note to `UI-CMD-HARNESS-001`.
- Added the first concrete in-app FreeX popup capture path: `FREEX_AUTOFILTER_FLYOUT_TOUR=1` seeds a `score` AutoFilter range, opens the production modeless AutoFilter flyout, captures `screenshots/autofilter-flyout-tour/freex_table_autofilter_dropdown.png`, and writes `autofilter_flyout_tour_manifest.json` with pair key `interactive:table-autofilter-dropdown:opened`.
- Added the paired Excel popup capture path: `FREEX_EXCEL_AUTOFILTER_FLYOUT_TOUR=1` seeds the same `score` range in Microsoft Excel, opens the header AutoFilter dropdown with a foreground-guarded header-arrow click, captures `screenshots_excel/autofilter-flyout-tour/interactive_table_autofilter_dropdown_opened.png`, and writes `excel_autofilter_flyout_tour_manifest.json` with the same pair key.
- Added the first concrete FreeX Home number-format dropdown capture path: `FREEX_HOME_NUMBER_FORMAT_DROPDOWN_TOUR=1` opens the production Home `NumberFormatBox`, captures the open WPF ComboBox popup child at `screenshots/home-number-format-dropdown-tour/freex_dropdown_home_number_format_opened.png`, and writes `home_number_format_dropdown_tour_manifest.json` with pair key `interactive:home-number-format:opened`.
- Added the paired Excel Home number-format dropdown capture path: `FREEX_EXCEL_NUMBER_FORMAT_DROPDOWN_TOUR=1` seeds a numeric A1 sample in Microsoft Excel, expands the Home `NumberFormatGallery` ComboBox through UI Automation, captures `screenshots_excel/home-number-format-dropdown-tour/interactive_home_number_format_opened.png`, and writes `excel_home_number_format_dropdown_tour_manifest.json` with the same pair key.

## Remaining Limitations

- This slice now has paired FreeX and Microsoft Excel AutoFilter popup capture hooks for `interactive:table-autofilter-dropdown:opened`, plus paired FreeX and Microsoft Excel Home number-format dropdown capture hooks for `interactive:home-number-format:opened`.
- The worksheet context menu and native Open dialog remain future runner tasks.
- The current desktop session blocked the live Excel Home number-format capture because `i5-32gb - Remote Desktop Connection` retained foreground ownership; the Excel tour correctly cleared partial evidence and aborted instead of capturing the wrong window.
- The eventual runner should open one scenario at a time, verify foreground ownership before every input, verify the popup/dialog/menu target before capture, and delete partial artifacts if ownership drifts.
- Native dialogs may legitimately change the foreground title/class; the runner needs dialog-aware ownership validation instead of the current owner-window title equality check.
