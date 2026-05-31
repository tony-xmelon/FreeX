# FreeX Menu and Toolbar Parity

**Last updated:** 2026-05-31
**Purpose:** Tracks individual ribbon button and menu-item fidelity against Excel for Windows.

## Coverage Summary

<!-- command-inventory:coverage-summary:start -->
| Tab | Implemented | Partial | Not Implemented | Deferred | Excluded | Coverage |
|---|---:|---:|---:|---:|---:|---:|
| File/Backstage | 8 | 4 | 0 | 0 | 3 | **100%** |
| QAT | 3 | 0 | 0 | 0 | 1 | **100%** |
| Home | 48 | 8 | 0 | 0 | 1 | **100%** |
| Insert | 10 | 3 | 0 | 1 | 9 | **100%** |
| Draw | 9 | 3 | 0 | 1 | 1 | **100%** |
| Page Layout | 16 | 1 | 0 | 0 | 0 | **100%** |
| Formulas | 16 | 1 | 0 | 0 | 0 | **100%** |
| Data | 17 | 1 | 0 | 0 | 2 | **100%** |
| Review | 11 | 2 | 0 | 0 | 6 | **100%** |
| View | 13 | 8 | 0 | 0 | 0 | **100%** |
| Sheet Tabs | 9 | 0 | 0 | 0 | 0 | **100%** |
| Help | 6 | 0 | 0 | 0 | 3 | **100%** |
| **TOTAL** | **166** | **31** | **0** | **2** | **26** | **100%** |
<!-- command-inventory:coverage-summary:end -->

Coverage = (Implemented + Partial) / (Implemented + Partial + Not Implemented). Deferred and Excluded items are reported separately.

## Status Legend

| Status | Meaning |
|---|---|
| Implemented | Works like Excel |
| Partial | Works but incomplete; see Notes |
| Not Implemented | Absent; not yet built |
| Deferred | Explicitly postponed because it needs a larger subsystem or interaction architecture |
| Excluded | Out of scope (cloud/proprietary/large subsystem) |

Closeout alignment note: the May 2026 command parity closeout now reflects completed Home-tab cleanup for persistent
Format Painter, alignment and shrink-to-fit style state, AutoFit measurement, and Format Cells dialog coverage. Remaining
Partial rows continue to track intentionally bounded fidelity gaps such as custom/locale number formats, conditional
formatting manager/rendering breadth, table style-theme depth, Flash Fill inference, vector PDF graphics, and remaining
Excel PDF publish options. Advanced
chart-family authoring/rendering remains Deferred until each family has a data model and renderer.
Ribbon overflow now keeps collapsed group menus closer to Excel by preserving cloned menu checked state,
input gesture text, and dynamic menu-open behavior instead of reducing collapsed groups to static labels.

---

## File Menu / Backstage

<!-- command-inventory:menu-toolbar:file-backstage:start -->
| Item | Status | Notes |
|---|---|---|
| New | Implemented | Ctrl+N |
| Open | Implemented | Ctrl+O |
| Save | Implemented | Ctrl+S; Backstage caption exposes a visible access key |
| Save As | Implemented | Backstage caption exposes a visible access key |
| Print Preview | Implemented | Keyboardable printer, copies, collation, sides, page range, zoom, margins, and Page Setup controls |
| Export to PDF/XPS | Partial | Deterministic PDF export uses the print renderer and PDFsharp-WPF raster pages plus selectable/searchable text overlays for worksheet cells, headings, header/footer text, and common WPF text controls unless the bitmap-text option is selected; active-sheet, selected-range, and entire-visible-workbook exports support grouped visible sheets, rendered page-range validation, standard/minimum-size quality, ignore-print-areas, PDF initial-view/open-mode, catalog language, bookmark modes, document properties, and access-keyed publish/open-after-publish options; XPS remains available with format-aware option summaries; full vector PDF graphics, PDF/A, tagged PDF structure, and remaining full Excel PDF publish options remain partial |
| Close | Implemented | Backstage caption exposes a visible access key |
| Options | Partial | General, Formulas, View, and Save subsets including calculation/error-checking and formula bar preferences; sidebar categories, editable fields, option toggles, and OK/Cancel expose keyboard access keys |
| Recent Files | Implemented |  |
| Info panel | Partial | Protection/accessibility summary, workbook statistics, accessibility and formula-error counts, saved file size/last-modified metadata, active sheet/workbook protection status, and Backstage action buttons for Protect Workbook, Check Accessibility, Workbook Statistics, and Error Checking |
| Share | Partial | Windows Share for saved local files; missing or unsaved local files route through Save As first; Microsoft 365 cloud links/coauthoring excluded |
| Check In/Out | Excluded | SharePoint |
| Online Templates | Excluded |  |
| XLSX unsupported-feature warnings | Implemented |  |
| Account | Partial | No MS account integration |
<!-- command-inventory:menu-toolbar:file-backstage:end -->

## Quick Access Toolbar

<!-- command-inventory:menu-toolbar:qat:start -->
| Item | Status | Notes |
|---|---|---|
| Save | Implemented |  |
| Undo | Implemented |  |
| Redo | Implemented |  |
| Customize QAT | Excluded | Low v1 value |
<!-- command-inventory:menu-toolbar:qat:end -->

---

## Home Tab

<!-- command-inventory:menu-toolbar:home:start -->
### Clipboard

| Item | Status | Notes |
|---|---|---|
| Cut | Implemented | Cut marquee; paste consumes cut state |
| Copy | Implemented |  |
| Paste | Implemented | Internal values/formulas/formats/all and external text paste covered |
| Paste Special | Implemented | Supported modes are undoable with arithmetic-operation radio buttons (None/Add/Subtract/Multiply/Divide); all dialog choices and OK/Cancel expose access keys; external rich-object paste excluded |
| Format Painter | Implemented | Single-click and persistent double-click modes |

### Font

| Item | Status | Notes |
|---|---|---|
| Font Family | Implemented |  |
| Font Size | Implemented |  |
| Grow/Shrink Font | Implemented |  |
| Bold | Implemented | Ctrl+B |
| Italic | Implemented | Ctrl+I |
| Underline | Implemented | Ctrl+U |
| Double Underline | Implemented |  |
| Strikethrough | Implemented | Ctrl+5 |
| Font Color | Implemented | Shared color picker exposes custom color and button access keys; Format Cells Font tab also exposes keyboardable common-color swatches with live preview. |
| Fill Color | Implemented | Shared color picker exposes custom color and button access keys. |
| Borders (presets) | Implemented |  |
| Full Border Gallery | Partial | Expanded preset gallery with remembered line color/style; interactive draw/erase border tools deferred |
| Theme Colors | Partial | Preset color schemes plus Customize Colors entry point through an access-keyed theme dialog; loaded theme `fmtScheme` details are preserved on save |

### Alignment

| Item | Status | Notes |
|---|---|---|
| Horizontal Align | Implemented | Left/Center/Right |
| Vertical Align | Implemented | Top/Middle/Bottom |
| Wrap Text | Implemented |  |
| Merge & Center | Implemented |  |
| Indent +/- | Implemented |  |
| Text Rotation presets | Implemented |  |
| Distributed/Justify | Implemented | Style, dialog, renderer, XLSX IO |
| Shrink to Fit | Implemented | Style, dialog, renderer, XLSX IO |
| Format Cells Alignment dialog | Implemented | Supported alignment model |

### Number

| Item | Status | Notes |
|---|---|---|
| Number Format dropdown | Implemented |  |
| General/Number/Currency | Implemented |  |
| Accounting/Date/Time | Implemented |  |
| Percentage/Fraction/Scientific/Text | Implemented |  |
| Custom Number Format | Partial | Broader Format Cells catalog plus editable custom format codes; supports invariant conditional sections for numbers and date/time values, named colors, default indexed `Color1`-through-`Color56` and spaced `Color 1`-through-`Color 56` prefixes for numeric/date/text sections, workbook indexed-color palette overrides loaded from and saved to XLSX `indexedColors` and applied to grid display, bounded workbook-theme color directives `ThemeDark1`, `ThemeLight1`, `ThemeDark2`, `ThemeLight2`, `ThemeAccent1` through `ThemeAccent6`, `ThemeHyperlink`, and `ThemeFollowedHyperlink` resolved through the active workbook theme, escaped literals including escaped layout directive characters, active percent scaling with token placement and quoted/escaped literal handling, date/time with long and compact AM/PM markers, contextual month/minute token handling across quoted literals, five-`m` month initials, rounded clock and elapsed fractional seconds, elapsed-time, and text-section spacing/fill directive cleanup, variable decimals, variable and fixed-denominator fractions, scientific notation, elapsed time, comma scaling, visible currency symbols from LCID and culture-name tokens, common `.NET RegionInfo` symbol/name labels in Format Cells that still preserve symbol-only format codes, and deterministic decimal/group/date separators for selected modeled LCIDs including US, East Asian, European, and Latin American Spanish variants; full locale/LCID, tint-bearing theme tokens, and full localized accounting name catalogs remain partial |
| Increase/Decrease Decimal | Implemented |  |
| Comma Style | Implemented |  |
| Currency Style | Implemented |  |
| Percentage Style | Implemented |  |
| Full locale/accounting fidelity | Partial | Invariant/accounting subset with LCID currency-symbol preservation, common `RegionInfo` accounting symbol/name labels in Format Cells, modeled numeric/date separators for `404`, `405`, `406`, `407`, `409`, `40B`, `40C`, `40E`, `410`, `411`, `412`, `413`, `414`, `415`, `416`, `419`, `41D`, `41F`, `422`, `804`, `807`, `813`, `816`, `C04`, `C0A`, `1009`, and `100C`, supported workbook-theme number-format color directives, and date/time/elapsed-time/text layout directive cleanup; full Excel/OS locale fidelity, tint-bearing theme tokens, full localized accounting catalogs, and exact accounting layout widths remain partial |

### Styles

| Item | Status | Notes |
|---|---|---|
| Conditional Formatting | Partial | Authoring/editing available for modeled rules with access-keyed value/format fields, visual-rule threshold/color fields, option toggles, and OK/Cancel; Conditional Formatting > Icon Sets exposes direct one-click icon-set presets plus More Rules without disabled category pseudo-commands; grid rendering covers cell value, formulas, above/below average, top/bottom, duplicate/unique, text, blank/nonblank, error/no-error, color scales, data bars, and visible 3/4/5-band icon sets with style-aware arrows, traffic lights, signs, symbols, flags, ratings, quarters, boxes, reverse/icons-only display, and authored percent/number thresholds; simplified manager remains partial |
| Format as Table | Partial | Creates structured table metadata with generated headers, AutoFilter flag, style name, visible banding, access-keyed range/header controls, one-step undo for table creation plus styling, and an Excel-scale Light/Medium/Dark gallery with swatch previews; command-level style-option toggles for first/last column plus row/column stripes are undoable and preserve loaded table metadata; command-level and XLSX-loaded table value filters hide non-matching data rows with multi-column AND, blank inclusion, and totals-row exclusion semantics; totals-row labels and common functions (`sum`, `average`, `count`, `countNums`, `min`, `max`) can be materialized with undo; formulas evaluate modeled structured references for data-body columns, table sections, section-column intersections, current-row references, `#This Row`, and multi-column ranges; full table style theme semantics remain partial |
| Cell Styles | Partial | Expanded built-in preset gallery backed by reusable `StyleDiff` planners; Accent 20% presets resolve against the active workbook theme; full workbook named styles remain deferred |

### Cells

| Item | Status | Notes |
|---|---|---|
| Insert Cells/Rows/Columns/Sheets | Implemented |  |
| Delete Cells/Rows/Columns/Sheets | Implemented |  |
| Row Height | Implemented |  |
| Column Width | Implemented |  |
| AutoFit Row/Column | Implemented | Measurement-based estimate |
| Hide/Unhide Rows/Columns/Sheets | Implemented |  |
| Format Cells dialog | Implemented | Ctrl+1; supported style model, including Font-tab Normal font reset for modeled font fields |

### Editing

| Item | Status | Notes |
|---|---|---|
| AutoSum | Implemented | Alt+= |
| Fill Down/Right/Up/Left | Implemented | Ctrl+D/R |
| Fill Series | Implemented |  |
| Flash Fill | Partial | Expanded deterministic inference including common first-name/last-name contact patterns, dotted/underscored/hyphenated and mixed-separator email display-name cleanup with plus-address tag removal, plus-address email local-part extraction, email domain-stem extraction, digit-mask formatting such as phone-number punctuation, two-part full-name reordering, known title/suffix removal such as `Dr. Ada Lovelace`, `Dr. Lovelace`, `Ada Lovelace Jr.`, or `Lovelace Jr.` to the untitled/unsuffixed name, uppercase initial inference from lowercase names, first/last or all-initial abbreviations such as `Ada Lovelace` to `Lovelace, Ada`, `A. Lovelace`, `A. L.`, `Ada L.`, `Lovelace A.`, or `Lovelace, A.`, exactly three-token name edge/middle-token drops, full last-name reordering, and initial abbreviations such as `Ada Byron Lovelace` to `Byron Lovelace`, `Ada Byron`, `Ada Lovelace`, `Lovelace, Ada`, `Lovelace, Ada Byron`, `Ada B. Lovelace`, `A. Lovelace`, `Ada L.`, `Lovelace A.`, `B. Lovelace`, `Byron L.`, `A. B. Lovelace`, `A. B. L.`, `Ada B.`, `Ada Byron L.`, `Lovelace, Ada B.`, `Lovelace A. B.`, `Lovelace, A. B.`, or `B.`, shared-domain email generation with `.`, `_`, or `-` first/last, first-initial/last, first/last-initial, and last/first-initial separators, and first/last-initial email aliases; Excel's full ML-like inference remains partial |
| Clear All | Implemented |  |
| Clear Formats/Contents/Comments/Hyperlinks | Implemented |  |
| Sort | Implemented |  |
| Filter | Implemented |  |
| Find | Implemented | Ctrl+F; dialog field, options, Find Next, and Close expose access keys |
| Replace | Implemented | Ctrl+H; dialog fields, options, Replace All, and Close expose access keys |
| Go To | Implemented | Ctrl+G/F5 |
| Go To Special | Implemented |  |
| Select Objects | Excluded | Object drag handles deferred |
<!-- command-inventory:menu-toolbar:home:end -->

---

## Insert Tab

<!-- command-inventory:menu-toolbar:insert:start -->
| Item | Status | Notes |
|---|---|---|
| PivotTable | Partial | Creates worksheet-range PivotTables on the current sheet or a new worksheet; create dialog source/placement choices expose access keys; Field List action buttons expose access keys; PivotTable Options choices expose access keys including undoable "For empty cells show" and "For error values show" text persistence; materialized value cells apply supported built-in and custom workbook-catalog value-field number format IDs; missing matrix intersections can display modeled empty-cell text; label/value filter dialogs expose access-keyed fields and OK/Cancel; checked-item filter search/select-all and the tabbed Value Field Settings dialog expose access-keyed fields, tabs, and OK/Cancel; Value Field Settings exposes a broader built-in preset catalog and edits custom format codes; model-first load/save |
| PivotChart | Partial | Inserts a bound chart from an existing PivotTable, preserves the PivotTable connection across type changes, reads/writes native `pivotSource`, renders PivotChart field buttons, and exposes PivotChart Options with undoable master, report-filter, axis-field, and value-field button toggles; full PivotChart Tools layout/design editing remains partial |
| Recommended PivotTables | Excluded | Proprietary heuristics |
| Table | Partial | Creates structured table metadata with generated headers, AutoFilter flag, style name, visible banding, access-keyed range/header controls, and one-step undo via the same path as Format as Table; the shared Format as Table gallery exposes Excel-scale Light/Medium/Dark style choices with swatch previews; style-option toggles for first/last column plus row/column stripes are undoable and preserve loaded table metadata; table value filters execute for command and XLSX-loaded metadata; totals-row labels and common functions can be materialized with undo; formulas evaluate modeled structured references for data-body columns, table sections, section-column intersections, current-row references, `#This Row`, and multi-column ranges; full table style theme semantics remain partial |
| Picture (from file) | Implemented |  |
| Online Pictures | Excluded |  |
| Shapes | Implemented | Rect/ellipse/line |
| Icons | Excluded | Proprietary Microsoft icon library |
| 3D Models | Excluded |  |
| SmartArt | Excluded | Retained part |
| Screenshot | Excluded | OS-level feature |
| Chart - column/bar/line/area | Implemented | Select Data Source, Move Chart, Insert Chart, and chart format dialogs expose keyboard access keys for modeled fields and option controls |
| Chart - pie/doughnut/scatter/bubble | Implemented |  |
| Chart - stock/radar/surface | Implemented | Surface and 3D Surface insert/change, render as value-colored matrix views, and write standard OOXML package parts with series axes |
| Chart - treemap/sunburst/histogram | Deferred | Recognized from XLSX where detected; authoring/rendering and lossless package writing need per-family model/renderer |
| Chart - waterfall/funnel/true 3D mesh | Deferred | Recognized from XLSX where detected; authoring/rendering and lossless package writing need per-family model/renderer. Map Chart remains recognized for XLSX preservation but is hidden from the Insert ribbon until authoring/rendering is implemented. |
| Recommended Charts | Excluded | Proprietary heuristics |
| Sparklines (line/column/win-loss) | Implemented |  |
| Text Box | Implemented |  |
| Header & Footer | Implemented | Presets, section fields, token buttons, options, and OK/Cancel expose access keys |
| WordArt | Excluded |  |
| Symbols | Implemented | Picker Cancel action exposes a keyboard access key. |
| Hyperlink | Implemented | Ctrl+K |
| Comment/Note | Partial | Insert tab creates local threaded comments; Review tab also keeps simple note commands. Full threaded conversation/reply UI remains partial |
| Equation | Excluded | Hidden from the Insert ribbon until equation authoring is implemented |
<!-- command-inventory:menu-toolbar:insert:end -->

---

## Draw Tab

<!-- command-inventory:menu-toolbar:draw:start -->
| Item | Status | Notes |
|---|---|---|
| Rectangle | Implemented |  |
| Ellipse | Implemented |  |
| Line | Implemented |  |
| Freehand Ink | Excluded | Out of scope and not surfaced in the ribbon |
| Bring Forward | Implemented |  |
| Send Backward | Implemented |  |
| Object Size/Rotation | Implemented | Command-based |
| Fill Color | Implemented | Shared color picker exposes custom color and button access keys. |
| Outline Color | Implemented |  |
| Alt Text | Implemented |  |
| Interactive drag handles | Deferred | Needs object-selection/adornment layer |
| Crop | Partial | Image crop/reset commands render and persist to native JSON/XLSX; interactive handles pending |
| Gradients/Effects | Partial | Shape gradient fill with dedicated access-keyed start/end color pickers plus selectable None/Shadow/Glow/Soft Edges effects with native JSON/XLSX persistence; full Excel gradient/effect galleries pending |
| Selection Pane | Partial | Lists sheet objects with per-item visibility checkboxes, search/filter controls, access-keyed Show All / Hide All bulk controls, Bring Forward / Send Backward reorder buttons, same-kind drag reorder within the list, model-backed object renaming with undo plus Native JSON and XLSX `cNvPr` name persistence for supported drawing objects, and OK/Cancel; full Excel pane visuals remain partial |
<!-- command-inventory:menu-toolbar:draw:end -->

---

## Page Layout Tab

<!-- command-inventory:menu-toolbar:page-layout:start -->
| Item | Status | Notes |
|---|---|---|
| Margins | Implemented |  |
| Orientation | Implemented |  |
| Paper Size | Implemented |  |
| Print Area (set/clear) | Implemented |  |
| Breaks | Implemented | Manual page breaks |
| Background | Implemented | Display-only tiled |
| Print Titles | Implemented |  |
| Scale to Fit | Implemented |  |
| Print Gridlines | Implemented |  |
| Print Headings | Implemented |  |
| Sheet Options | Implemented |  |
| Themes | Partial | Presets plus custom theme dialog reachable from Themes, Theme Colors, Theme Fonts, and Theme Effects; dialog preset buttons, metadata fields, color slots, and Save/Cancel expose keyboard access keys; loaded `fmtScheme` OOXML is preserved, while full OOXML effect interpretation remains deferred |
| Colors preset menu | Implemented |  |
| Fonts preset menu | Implemented |  |
| Effects preset menu | Implemented |  |
| Header/Footer editing | Implemented | Presets, section fields, token buttons, option toggles, and OK/Cancel expose access keys |
| Page Setup dialog | Implemented | Page, Margins, and Sheet tab labels plus footer actions expose access keys |
| Center on page | Implemented |  |
| Page Order | Implemented |  |
<!-- command-inventory:menu-toolbar:page-layout:end -->

---

## Formulas Tab

<!-- command-inventory:menu-toolbar:formulas:start -->
| Item | Status | Notes |
|---|---|---|
| Insert Function | Implemented | Search, category, function list, Help, OK, and Cancel expose access keys |
| AutoSum variants | Implemented |  |
| Logical menu | Implemented |  |
| Text menu | Implemented |  |
| Date & Time menu | Implemented |  |
| Lookup & Reference menu | Implemented |  |
| Math & Trig menu | Implemented |  |
| Name Manager | Implemented | Dialog list, name/range fields, and Define/Delete/Close commands expose access keys |
| Define Name | Implemented | Name/range fields and command buttons expose access keys through the named-range manager |
| Use in Formula | Implemented |  |
| Create from Selection | Implemented | Dialog choices and OK/Cancel expose access keys |
| Trace Precedents | Implemented |  |
| Trace Dependents | Implemented |  |
| Remove Arrows | Implemented |  |
| Show Formulas | Implemented | Ctrl+` |
| Error Checking | Partial | Issue list plus ribbon entry point to error-checking options, access-keyed issue actions, and supported checks including numbers stored as text, formulas referring to blank cells, two-digit-year text dates, formulas inconsistent with nearby formulas, SUM formulas omitting adjacent cells including gaps between separate SUM arguments, and unlocked formula cells; partial rule taxonomy |
| Evaluate Formula | Implemented | Help, Previous, Step Out, Evaluate, Step In, and Close actions expose access keys |
| Watch Window | Implemented | Dialog command buttons expose keyboard access keys. |
| R1C1 Reference Style | Implemented |  |
| Calculation Options | Implemented | Manual/auto |
| Calculate Now | Implemented |  |
| Calculate Sheet | Implemented |  |
<!-- command-inventory:menu-toolbar:formulas:end -->

---

## Data Tab

<!-- command-inventory:menu-toolbar:data:start -->
| Item | Status | Notes |
|---|---|---|
| Get Data (CSV) | Implemented |  |
| Queries & Connections | Excluded | External workbook queries, connection management, and Power Query connectors are excluded and are not surfaced as a disabled ribbon command; Refresh All remains available |
| Refresh All | Implemented | Recalc |
| Sort | Implemented | Single/multi-key |
| Filter | Implemented |  |
| Advanced Filter | Implemented | Access-keyed action/options/reference controls |
| Text to Columns | Implemented | Wizard exposes access-keyed source mode, delimiter, qualifier, destination, reference picker, and OK/Cancel controls |
| Remove Duplicates | Implemented |  |
| Data Validation | Implemented |  |
| Consolidate | Implemented | Function, reference list, destination, label options, and Add/Delete/OK/Cancel expose access keys |
| Goal Seek | Implemented | Dialog input labels, status dialog buttons, and OK/Cancel expose access keys |
| Scenario Manager | Implemented | Dialog list, add/edit/result-cell fields, action buttons, scenario summary result cells, and Close expose access keys. |
| Data Table | Implemented | 1-var/2-var dialog with access-keyed table type and input-cell reference fields |
| Forecast Sheet | Implemented | No chart UI |
| Subtotal | Implemented |  |
| Group/Outline | Implemented |  |
| Ungroup | Implemented |  |
| Show/Hide Detail | Implemented |  |
| Data Model / Power Pivot | Excluded |  |
| Flash Fill | Partial | Expanded deterministic inference including common first-name/last-name contact patterns, dotted/underscored/hyphenated email display-name cleanup with plus-address tag removal, plus-address email local-part extraction, email domain-stem extraction, digit-mask formatting such as phone-number punctuation, two-part full-name reordering, known title/suffix removal such as `Dr. Ada Lovelace`, `Dr. Lovelace`, `Ada Lovelace Jr.`, or `Lovelace Jr.` to the untitled/unsuffixed name, uppercase initial inference from lowercase names, first/last or all-initial abbreviations such as `Ada Lovelace` to `Lovelace, Ada`, `A. Lovelace`, `A. L.`, `Ada L.`, `Lovelace A.`, or `Lovelace, A.`, exactly three-token name edge/middle-token drops, full last-name reordering, and initial abbreviations such as `Ada Byron Lovelace` to `Byron Lovelace`, `Ada Byron`, `Ada Lovelace`, `Lovelace, Ada`, `Lovelace, Ada Byron`, `Ada B. Lovelace`, `A. Lovelace`, `Ada L.`, `Lovelace A.`, `B. Lovelace`, `Byron L.`, `A. B. Lovelace`, `A. B. L.`, `Ada B.`, `Ada Byron L.`, `Lovelace, Ada B.`, `Lovelace A. B.`, `Lovelace, A. B.`, or `B.`, shared-domain email generation with `.`, `_`, or `-` first/last, first-initial/last, first/last-initial, and last/first-initial separators, and first/last-initial email aliases; Excel's full ML-like inference remains partial |
<!-- command-inventory:menu-toolbar:data:end -->

---

## Review Tab

<!-- command-inventory:menu-toolbar:review:start -->
| Item | Status | Notes |
|---|---|---|
| Spell Check | Partial | Broader known-corrections text-cell scan with casing-preserving replace, replace-all, ignore support, and internet/email/file-address span skipping; no full dictionary/proofing engine |
| Thesaurus | Excluded | Requires external dictionary service |
| Accessibility Checker | Partial | Merged cells, low-contrast cell text with 4.5:1 normal-text and 3.0:1 large-text thresholds using registered font/fill colors, patterned fills, and no fill treated as white, blank structured-table headers, missing/generic alt text, untitled or generic-titled charts, non-descriptive hyperlink text, default worksheet tab names, and hidden sheets/rows/columns with content; conditional-format rendered colors, theme/tint expansion beyond existing style values, chart/shape/text-box text, and full Excel rule taxonomy remain partial |
| Smart Lookup | Excluded |  |
| Translate | Excluded |  |
| New Comment | Partial | Threaded comment text can be added/edited/deleted locally through the Review ribbon and Ctrl+Shift+F2, including root-message edits, explicit Reply/Add actions, Ctrl+Enter reply submission, and created/modified UTC metadata for local threads; full threaded conversation UI remains partial |
| Delete Comment | Implemented | Removes the threaded comment on the selected cell |
| Previous/Next Comment | Implemented | Navigates threaded comments and notes on the active sheet |
| Show Comments | Implemented | Opens a list of threaded comments and notes on the active sheet |
| New Note | Implemented | Simple cell notes |
| Edit Note | Implemented | Reuses the note editor with existing note text preloaded |
| Delete Note | Implemented |  |
| Previous/Next Note | Implemented | Navigates simple cell notes on the active sheet |
| Show Notes | Implemented | Opens a list of simple cell notes |
| Protect Sheet | Implemented | Password dialog OK/Cancel expose access keys |
| Allow Users to Edit Ranges | Implemented | Add, remove, and clear allowed ranges with undo support; range field and OK/Cancel expose access keys |
| Protect Workbook | Implemented | Password dialog OK/Cancel expose access keys |
| Share | Implemented | Windows Share for saved local files; missing current paths route through Save As |
| Share Workbook (legacy) | Excluded |  |
| Track Changes | Excluded |  |
| Threaded Comments | Partial | Local threaded comment model, shortcut, navigation, delete command, list/dialog summaries with authors, replies, created timestamps, and resolved state, plus Native JSON persistence for reply/thread activity metadata are supported; XLSX threaded-comment authoring and cloud identity semantics remain partial |
| Statistics | Implemented |  |
<!-- command-inventory:menu-toolbar:review:end -->

---

## View Tab

<!-- command-inventory:menu-toolbar:view:start -->
| Item | Status | Notes |
|---|---|---|
| Normal | Implemented |  |
| Page Break Preview | Implemented |  |
| Page Layout | Implemented |  |
| Custom Views | Implemented | Dialog list, actions, Add View name field, and OK/Cancel expose access keys |
| Show Gridlines | Implemented |  |
| Show Headings | Implemented |  |
| Show Ruler | Implemented |  |
| Show Formula Bar | Implemented |  |
| Freeze Panes | Implemented |  |
| Split | Implemented | Toggle clears frozen panes and supports independent split quadrants, draggable dividers, pane-specific scrollbars, wheel targeting, clipping, and active-state ribbon feedback |
| Zoom | Implemented |  |
| Zoom to Selection | Implemented |  |
| 100% Zoom | Implemented |  |
| New Window | Implemented | Creates a secondary MainWindow over the shared workbook through WorkbookWindowRegistry |
| Arrange All | Partial | Stores choice and marks the selected menu option; no live multi-window layout |
| Hide Window | Deferred | Removed from the ribbon until workbook-window visibility state exists |
| Unhide Window | Deferred | Removed from the ribbon until hidden workbook-window state exists |
| View Side by Side | Deferred | Removed from the ribbon until paired workbook-window layout exists |
| Synchronous Scrolling | Deferred | Removed from the ribbon until paired-window synchronized viewport routing exists |
| Reset Window Position | Deferred | Removed from the ribbon until paired workbook-window layout exists |
| Switch Windows | Implemented | Cycles focus through the live WorkbookWindowRegistry and enables once a second workbook window exists |
<!-- command-inventory:menu-toolbar:view:end -->

---

## Sheet Tab Context Menu

<!-- command-inventory:menu-toolbar:sheet-tabs:start -->
| Item | Status | Notes |
|---|---|---|
| Add Sheet | Implemented |  |
| Rename Sheet | Implemented |  |
| Delete Sheet | Implemented |  |
| Duplicate Sheet | Implemented |  |
| Move Left | Implemented |  |
| Move Right | Implemented |  |
| Tab Color | Implemented |  |
| Hide/Unhide Sheet | Implemented |  |
| Select All Sheets | Implemented | Group |
| Ungroup Sheets | Implemented |  |
<!-- command-inventory:menu-toolbar:sheet-tabs:end -->

---

## Help Tab

<!-- command-inventory:menu-toolbar:help:start -->
| Item | Status | Notes |
|---|---|---|
| Help (opens repo) | Implemented |  |
| Send Feedback | Implemented |  |
| Copy Diagnostics | Implemented | Copies safe tester diagnostics |
| Check for Updates | Implemented | Opens the stable latest tester release page |
| About FreeX | Implemented |  |
| Legal Notices | Implemented | Shows the project license, legal notice, privacy notice, third-party notices, and bundled license texts packaged with the app |
| Contact Support | Excluded | Not surfaced in the ribbon; in-app support is excluded |
| Show Training | Excluded | Not surfaced in the ribbon; training content is excluded |
| What's New | Excluded | Not surfaced in the ribbon; release-notes content is excluded |
<!-- command-inventory:menu-toolbar:help:end -->
