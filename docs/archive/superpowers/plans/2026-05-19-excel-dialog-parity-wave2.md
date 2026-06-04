# Excel Dialog Parity Wave 2 Plan

## Status

Wave 1 replaces prompt-driven workbook operations with local modal dialogs for formatting, navigation, sorting/filtering, data tools, scenarios, protection, and validation range selection.

Wave 2 first pass is implemented for local chart, PivotTable/PivotChart, object/picture, Page Setup, Name Manager, Data Validation, Paste Special, and Selection Pane entry points. The remaining Wave 2 items are deeper Excel galleries, full-format panes, or workbook-model behaviors that need richer models, renderer support, or larger UI surfaces.

## Implemented First Pass

- Insert Chart / Recommended Charts picker.
- PivotChart Change Type dialog.
- PivotTable creation dialog with source, destination, and field-list options.
- PivotTable Change Data Source dialog.
- Insert Slicer and Insert Timeline dialogs.
- Hyperlink dialog.
- Picture/object size, rotation, crop, shape gradient, alt text, comment, and text box entry dialogs.
- Shape gradient start/end color picker buttons.
- Data Validation Settings/Input Message/Error Alert tabs.
- Paste Special operation radio-button group.
- Selection Pane show/hide all and visibility/order controls.
- Page Setup reuse for custom margins, scaling, and print titles.
- Name Manager reuse for Define Name.

## Dialog Surfaces

1. Chart creation and editing
   - [Done first pass] Insert Chart / Recommended Charts picker.
   - [Done first pass] Change Chart Type and Move Chart result dialogs.
   - [Done first pass] Select Data Source result dialog.
   - [Done first pass] Format Chart Area, Axis, Data Series, Data Labels, Trendline, Error Bars, and Legend panes with color picker buttons where color values are edited.
   - [Remaining] Deeper Excel chart format-pane parity and chart style/filter galleries.

2. PivotTable and PivotChart workflows
   - [Done first pass] Create PivotTable dialog with source/range and destination picker.
   - [Done first pass] PivotTable Change Data Source dialog with source range picker.
   - [Existing/partial] PivotTable Fields pane with layout zones and field settings dialogs.
   - [Done first pass] Pivot filters, grouping, calculated field/item, value field settings, and slicer/timeline insert dialogs.
   - [Remaining] PivotTable Fields search/deferred-update pane ergonomics and full PivotTable style gallery parity.

3. Object and drawing formatting
   - [Done first pass] Format Shape / Picture dialog entry points for size, rotation, crop, gradient, colors, alt text, and text options.
   - [Done first pass] Selection Pane object visibility/order controls, including Show All and Hide All.
   - [Done first pass] Hyperlink and comment/note dialogs where workbook objects need non-cell editing surfaces.

4. Richer galleries and pickers
   - [Existing/partial] Theme colors, standard colors, and custom RGB picker parity across common color entry points.
   - [Existing/partial] Border gallery presets, line styles, diagonal borders, and live preview integration.
   - Cell Styles, Table Styles, chart styles, and conditional formatting rule galleries.

5. Print/page and workbook environment dialogs
   - [Done first pass] Full Page Setup dialog tabs, print titles, margins, header/footer, and sheet options.
   - [Done first pass] Name Manager / Define Name dialog reuse with reference picker text.
   - Options-adjacent workbook settings that affect calculation, proofing, display, and compatibility.

## Verification Expectations

- Each dialog surface gets planner or model tests before wiring to `MainWindow`.
- UI-only XAML coverage should verify required tabs, controls, and command routing.
- Any dialog that edits workbook state must have at least one command-level test proving the selected options are honored.
- WPF tests should be run with stale `FreeX.App.Host` processes cleared first to avoid locked build outputs.
