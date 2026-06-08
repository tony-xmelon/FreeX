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

## Remaining Limitations

- This slice now captures the FreeX AutoFilter popup through an in-app WPF render path, but it does not yet drive the Microsoft Excel popup or the other planned transient surfaces.
- The eventual runner should open one scenario at a time, verify foreground ownership before every input, verify the popup/dialog/menu target before capture, and delete partial artifacts if ownership drifts.
- AutoFilter setup should reuse the seeded `score` workbook state when opening the paired Excel header dropdown.
- Native dialogs may legitimately change the foreground title/class; the runner needs dialog-aware ownership validation instead of the current owner-window title equality check.
