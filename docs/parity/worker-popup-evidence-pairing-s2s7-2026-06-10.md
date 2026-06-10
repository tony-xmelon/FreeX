# S2/S7 Popup Evidence Pairing - 2026-06-10

Scope: docs-only continuation for retained popup/dropdown/gallery evidence. This pass inventories existing Microsoft Excel foreground captures and existing deterministic FreeX captures for AutoFilter, Home Borders, Home Number Format, and the worksheet-cell context menu. No screenshot tools or product code were changed; `tools/FreeX.ForegroundCapture/Program.cs` was not touched.

## Pairing Summary

| Sub-scenario | Pair key | Excel retained artifact | FreeX deterministic artifact | Status |
|---|---|---|---|---|
| AutoFilter opened | `interactive:table-autofilter-dropdown:opened` | `screenshots_excel/autofilter-flyout-tour/interactive_table_autofilter_dropdown_opened.png` with `excel_autofilter_flyout_tour_manifest.json` | `screenshots/autofilter-flyout-tour/freex_table_autofilter_dropdown.png` with `autofilter_flyout_tour_manifest.json` | Closed for retained opened-state pairing |
| Home Number Format opened | `interactive:home-number-format:opened` | `screenshots_excel/home-number-format-dropdown-tour/interactive_home_number_format_opened.png` with `excel_home_number_format_dropdown_tour_manifest.json` | `screenshots/home-number-format-dropdown-tour/freex_dropdown_home_number_format_opened.png` with `home_number_format_dropdown_tour_manifest.json` | Closed for retained opened-state pairing |
| Worksheet-cell context menu opened | `interactive:worksheet-cell-context-menu:opened` | `screenshots_excel/worksheet-context-menu-tour/interactive_worksheet_cell_context_menu_opened.png` with `excel_worksheet_context_menu_tour_manifest.json` | `screenshots/worksheet-context-menu-tour/freex_context_menu_worksheet_cell_opened.png` with `worksheet_context_menu_tour_manifest.json` | Closed for retained opened-state pairing |
| Home Borders opened | `interactive:home-borders:opened` | `tools/foreground-captures/excel-borders/excel-borders_20260610_141515.png` with `excel-borders_manifest.json` | `screenshots/home-borders-dropdown-tour/freex_dropdown_home_borders_opened.png` with `home_borders_dropdown_tour_manifest.json` | Closed for retained opened-state pairing; Excel crop is narrow and text-clipped on the right edge |

Root `screenshots_excel/` is the canonical retained Excel evidence location for AutoFilter, Home Number Format, and worksheet context menu. The Home Borders pairing uses the newer guarded foreground harness artifact under `tools/foreground-captures/excel-borders/` because no retained `screenshots_excel/home-borders-dropdown-tour/` artifact exists.

## Observed Parity Gaps

- AutoFilter: Excel's retained flyout is an Office `Net UI Tool Window` capture with visible Sort by Color, Sheet View, disabled Clear Filter, disabled Filter by Color, Number Filters, search placeholder, checklist, and OK/Cancel. FreeX captures the same seeded `score` checklist state but uses a shorter WPF flyout, omits the disabled Office-only color/sheet-view rows when no color choices exist, has no icon column or search placeholder, and is materially smaller.
- Home Number Format: Excel renders an icon/sample gallery with two-line entries and a bottom `More Number Formats...` row. FreeX exposes the same core labels in a compact text-only dropdown, with no sample preview rows or gallery icons.
- Worksheet context menu: Excel's default cell menu is shorter, includes Paste Options graphics, disabled striped rows such as Quick Analysis/Get Data/Format Cells/Define Name where applicable, and Link submenu chrome. FreeX exposes a much larger 50-command menu with row/column sizing, data tools, comments/notes, hyperlink, format, and clear commands; the retained opened-state capture reaches the screen-height crop before the lower items.
- Home Borders: FreeX has retained evidence for the top-level menu including preset borders, draw/erase modes, Line Color, Line Style, and More Borders. Excel foreground evidence now shows the Office Borders menu, but the retained crop is narrow and clips text on the right; parity can be judged for the visible row ordering/icon family, while full-width typography remains a follow-up quality target.

## Closed vs Blocked

Closed for S2/S7 retained pairing:

- AutoFilter opened pair.
- Home Number Format opened pair.
- Worksheet-cell context menu opened pair.
- Home Borders opened pair.

Remaining S2/S7 count for this four-surface popup/dropdown/gallery slice: 0 of 4 sub-scenarios remains open. Follow-up quality work remains for a wider Excel Home Borders crop and for popup/gallery surfaces outside this four-surface slice.

## Verification Notes

This pass inspected the retained manifests and PNGs only. It did not regenerate screenshots or manifests.
