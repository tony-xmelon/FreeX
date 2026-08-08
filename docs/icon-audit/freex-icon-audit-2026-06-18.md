# FreeX Ribbon Icon Audit

Generated: 2026-06-18

<!-- VERIFY: ~7 weeks stale as of this audit (2026-08-08). The generator
     (`tools/icon-audit/generate-freex-icon-audit.mjs`) still correctly points at
     `src/FreeX.Ribbon.Definitions/Resources/CommandIconsSvg` (icons were NOT moved into shared/ by the later
     shared-tier extraction — that project already held them at generation time), but a raw file count now
     shows 384 SVGs there versus the "390" reported below — close but drifted. Regenerate via the script
     rather than trusting exact figures. -->

## Summary

- Commands audited: 290
- SVG assets inventoried in HTML: 390
- OK: 190
- Review: 100
- Inconsistent: 0
- Contextual-tab inconsistent rows: 0
- Handler-suffixed commands normalized before SVG lookup: 33

## Main Findings

- The Home tab is mostly usable and has command-specific SVGs for the familiar Excel metaphors.
- The non-Home tabs are mixed: many commands have good SVG names, but Data, Review, View, and Page Layout still have generic fallbacks for stateful commands.
- Contextual tabs are the weakest area. Chart, table, and PivotTable commands often use fallback geometry or reuse a broad Table/PivotTable/Chart icon where Excel uses object-specific pictograms.
- Command IDs containing `#..._Click` are normalized before SVG lookup, so handler-suffixed commands can reach matching assets such as `selection-pane.svg` and `remove-duplicates.svg`.

## Suggested First Pass

1. Keep expanding command-specific SVG coverage for contextual Chart, Table, Picture/Shape, and PivotTable tabs.
2. Redraw contextual Chart Design/Format icons as a complete set: Chart Elements, Styles, Select Data, Change Chart Type, Move Chart, Fill/Border/Marker/Axes/Labels.
3. Redraw Table Design and PivotTable contextual icons as complete sets, avoiding repeated generic Table/PivotTable glyphs.
4. Fill Review comment icons: delete, previous, next, and show comments.
5. Compare the final rendered ribbon tabs after SVG asset coverage is complete.

This Markdown report is the committed summary. Regenerate the local HTML/JSON audit artifacts when the full command table or SVG inventory is needed.

## App Visual Validation - 2026-06-19

Result: pass for SVG wiring and display. The FreeX WPF app was built and run in screenshot-tour mode from `codex/icon-visual-validation-20260619`; generated PNGs show visible, nonblank icons on the rendered ribbon and worksheet context menu at the expected small and large sizes.

Evidence:

- `screenshots/icon-visual-validation-20260619/main-ribbon/`: 27 top-level ribbon captures covering Home, Insert, Draw, Page Layout, Formulas, Data, Review, View, and Help at `max`, `1100`, and `900` widths, plus `ribbon_screenshot_tour_manifest.json`.
- `screenshots/icon-visual-validation-20260619/contextual-table/`: `900_Table_Design.png` plus manifest.
- `screenshots/icon-visual-validation-20260619/contextual-chart/`: `900_Chart_Design.png`, `900_Chart_Format.png`, plus manifest.
- `screenshots/icon-visual-validation-20260619/context-menus/worksheet-context-menu-tour/`: `freex_context_menu_worksheet_cell_opened.png` plus manifest, validating small context-menu icon display.
- `screenshots/ribbon-declarative/home_live.png`: declarative ribbon capture validating the Home tab uses the SVG-backed declarative renderer.
- `screenshots/icon-visual-validation-20260619/contact-sheet.png`: scan sheet for the app-run captures above.

Visual assertion: no broken-image placeholders, blank glyph slots, or missing SVG render failures were observed in the generated app screenshots. The contextual Chart/Table icons remain marked for stylistic review where they do not yet match Excel's denser contextual-tab language, but the current validation did not find a new wiring/display discrepancy requiring a separate fix agent.

Commands:

```powershell
dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 /v:minimal

$env:FREEX_SS_TOUR='1'; $env:FREEX_SS_TOUR_ALLOW_BACKGROUND_RENDER='1'; $env:FREEX_SS_TOUR_WIDTHS='max,1100,900'; $env:FREEX_SS_TOUR_OUTPUT_SUBDIR='icon-visual-validation-20260619/main-ribbon'; .\src\FreeX.App.Host\bin\Release\net10.0-windows10.0.19041.0\FreeX.App.Host.exe

$env:FREEX_SS_TOUR='1'; $env:FREEX_SS_TOUR_ALLOW_BACKGROUND_RENDER='1'; $env:FREEX_SS_TOUR_WIDTHS='900'; $env:FREEX_SS_TOUR_CONTEXT='table'; $env:FREEX_SS_TOUR_TABS='Table Design'; $env:FREEX_SS_TOUR_OUTPUT_SUBDIR='icon-visual-validation-20260619/contextual-table'; .\src\FreeX.App.Host\bin\Release\net10.0-windows10.0.19041.0\FreeX.App.Host.exe

$env:FREEX_SS_TOUR='1'; $env:FREEX_SS_TOUR_ALLOW_BACKGROUND_RENDER='1'; $env:FREEX_SS_TOUR_WIDTHS='900'; $env:FREEX_SS_TOUR_CONTEXT='chart'; $env:FREEX_SS_TOUR_TABS='Chart Design,Format'; $env:FREEX_SS_TOUR_OUTPUT_SUBDIR='icon-visual-validation-20260619/contextual-chart'; .\src\FreeX.App.Host\bin\Release\net10.0-windows10.0.19041.0\FreeX.App.Host.exe

$env:FREEX_WORKSHEET_CONTEXT_MENU_TOUR='1'; $env:FREEX_SS_TOUR_ALLOW_BACKGROUND_RENDER='1'; $env:FREEX_SS_TOUR_OUTPUT_SUBDIR='icon-visual-validation-20260619/context-menus'; .\src\FreeX.App.Host\bin\Release\net10.0-windows10.0.19041.0\FreeX.App.Host.exe

$env:FREEX_RIBBON_DECLARATIVE='1'; $env:FREEX_RIBBON_DECLARATIVE_CAPTURE='1'; $env:FREEX_RIBBON_DECLARATIVE_WIDTH='1200'; .\src\FreeX.App.Host\bin\Release\net10.0-windows10.0.19041.0\FreeX.App.Host.exe
```

## Inconsistent Rows

| Tab | Group | Command | Runtime source | Suggested action |
| --- | --- | --- | --- | --- |

## Review Rows

| Tab | Group | Command | Runtime source | Suggested action |
| --- | --- | --- | --- | --- |
| Chart Design (contextual) | Layouts | Chart Titles | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Design (contextual) | Layouts | Data Labels | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Design (contextual) | Layouts | Data Label Position | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Design (contextual) | Layouts | Trendline | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Design (contextual) | Layouts | Error Bars | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Design (contextual) | Layouts | Secondary Axis | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Design (contextual) | Styles | Chart Styles | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Design (contextual) | Data | Select Data Source | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Design (contextual) | Type | Change Chart Type | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Design (contextual) | Type | Combo Chart | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Design (contextual) | Type | Combo Chart Series | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Design (contextual) | Location | Move Chart | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Current Selection | Format Chart Area | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Current Selection | Format Bar/Column | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Current Selection | Format Pie/Doughnut | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Current Selection | Format Bubble Chart | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Current Selection | Format Stock Chart | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Shape Styles | Chart Area Fill | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Shape Styles | Plot Area Fill | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Shape Styles | Plot Area Border | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Shape Styles | Series Color | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Shape Styles | Series Width | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Shape Styles | Series Dash | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Shape Styles | Series Marker | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Shape Styles | Marker Size | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Text | Chart Title Color | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Text | Chart Title Size | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Text | Axis Title Color | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Text | Axis Title Size | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Text | Legend Text | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Text | Legend Font Size | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Text | Data Label Text | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Text | Data Label Fill | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Text | Data Label Border | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Axes | X Axis Bounds | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Axes | Y Axis Bounds | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Axes | X Axis Gridlines | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Axes | Y Axis Gridlines | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Axes | X Axis Labels | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Chart Format (contextual) | Axes | Y Axis Labels | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Picture Format (contextual) | Format | Format Picture | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Picture Format (contextual) | Format | Crop Picture | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Picture Format (contextual) | Arrange | Bring Forward | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Picture Format (contextual) | Arrange | Send Backward | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Picture Format (contextual) | Arrange | Selection Pane | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Picture Format (contextual) | Arrange | Rotate Object | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Picture Format (contextual) | Arrange | Object Size | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Picture Format (contextual) | Accessibility | Alt Text | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Shape Format (contextual) | Shape Styles | Shape Fill | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Shape Format (contextual) | Shape Styles | Object Outline | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Shape Format (contextual) | Shape Styles | Shape Gradient | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Shape Format (contextual) | Shape Styles | Shape Effects | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Shape Format (contextual) | Arrange | Bring Forward | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Shape Format (contextual) | Arrange | Send Backward | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Shape Format (contextual) | Arrange | Selection Pane | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Shape Format (contextual) | Arrange | Rotate Object | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Shape Format (contextual) | Arrange | Object Size | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Shape Format (contextual) | Accessibility | Alt Text | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Table Design (contextual) | Properties | Table Name | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Table Design (contextual) | Properties | Resize Table | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Table Design (contextual) | Tools | Summarize with PivotTable | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Table Design (contextual) | Tools | Remove Duplicates | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Table Design (contextual) | Tools | Convert to Range | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Table Design (contextual) | Style Options | Total Row | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Table Design (contextual) | Style Options | First Column | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Table Design (contextual) | Style Options | Last Column | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Table Design (contextual) | Style Options | Banded Rows | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Table Design (contextual) | Style Options | Banded Columns | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Table Design (contextual) | Style Options | Filter Button | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| Table Design (contextual) | Styles | Table Styles | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Pivot Table | PivotTable Name | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Pivot Table | PivotTable Options | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Active Field | Show Details | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Active Field | Field Settings | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Group | Group Field | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Group | Ungroup | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Filter | Insert Slicer | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Filter | Insert Timeline | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Data | Refresh | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Data | Change Data Source | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Actions | Clear | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Actions | Select | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Actions | Move PivotTable | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Calculations | Calculated Field | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Calculations | Calculated Item | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Tools | PivotChart | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Tools | Change Chart Type | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Tools | PivotChart Options | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Show | Field List | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Show | +/- Buttons | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Analyze (contextual) | Show | Field Headers | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Design (contextual) | Layout | Grand Totals | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Design (contextual) | Layout | Subtotals | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Design (contextual) | Layout | Report Layout | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Design (contextual) | Layout | Blank Rows | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Design (contextual) | Style Options | Banded Rows | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Design (contextual) | Style Options | Banded Columns | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Design (contextual) | Style Options | Row Headers | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Design (contextual) | Style Options | Column Headers | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
| PivotTable Design (contextual) | Styles | PivotTable Styles | command SVG | Redraw toward Excel contextual-tab language: denser, more pictorial, and specific to the selected object. |
