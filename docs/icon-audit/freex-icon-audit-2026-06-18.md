# FreeX Ribbon Icon Audit

Generated: 2026-06-18

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

Open `freex-icon-audit-2026-06-18.html` for the full command table and the SVG asset inventory, both with 20px and 32px renderings.

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