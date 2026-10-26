# FreeX Excel command-surface inventory

> **Purpose.** This is a source-derived manual UX inventory, not an Excel parity
> claim. It enumerates the controls emitted by the current FreeX command
> catalogs and the non-ribbon command planners that make them reachable. Every
> execution/comparison cell is deliberately **Not run**. Do not infer that a
> command agrees with Excel until its row is exercised in both applications.

## Reading and execution rules

* **Path notation:** `Alt, key-tip` is the ribbon key-tip route; `>` means open
  a menu, submenu, or dialog. A bare key-tip is discoverable only after its tab
  or parent menu is open. `Right-click` also covers keyboard invocation with
  `Shift+F10`/the Apps key where the focused worksheet or tab accepts it.
* **Result:** verify the named visible effect, dialog/pane, selection, or file
  action. For commands that alter workbook content, test undo/redo as well.
* **Save check:** `Workbook` means save, close/reopen, and inspect the changed
  workbook; `Options` means restart/check the persisted application option;
  `None` means no workbook persistence is expected; `External` means a native
  picker, browser, print/share, or OS integration is expected.
* **Status:** every row is **Not run**. A semicolon-delimited command cell is a
  checklist: each named item is a separate manual execution, with the common
  path/result/persistence rule stated in that row.

## Source boundary and coverage count

| Surface | Count / inventory boundary | Primary source |
|---|---:|---|
| Main ribbon | 9 non-contextual tabs, including File and Home | `src/FreeX.Ribbon.Definitions/FreeXRibbon.cs`, `HomeRibbonDefinition.cs`, `FreeXRibbonDefinition.cs` |
| Contextual ribbon | 7 tabs: Shape, Picture, Chart Design/Format, Table Design, PivotTable Analyze/Design | `FreeXRibbonDefinition.cs:307-501` |
| Keyboard | 47 explicit application shortcut registrations and 84 dispatch identities (some commands have alternate chords) | `src/FreeX.App.Presentation/Shell/WorkbookKeyboardShortcutCatalog.cs` |
| QAT | 37 selectable commands; default Save/Undo/Redo; position/customization persisted | `src/FreeX.App.Services/Ribbon/QuickAccessToolbarCatalog.cs` |
| Worksheet menu | 75 action identifiers across worksheet, row, column, picture, shape/text-box, and chart variants | `src/FreeX.App.Services/Ribbon/WorksheetContextMenuPlanner.cs` |
| Sheet menu | 12 action identifiers | `src/FreeX.App.Services/Ribbon/SheetTabContextMenuPlanner.cs` |
| Other interactive families | Status bar, filter, pivot field/header/chart, recent-file, waterfall, native menu, and declared dialogs | `src/FreeX.App.Presentation/Interactions/InteractionSurfaceCatalog.cs` |

The source of truth for ribbon reachability is the renderer-neutral definition;
the WPF host registers the generated handler map rather than reflecting the
XAML tree (`MainWindow.RibbonDeclarative.cs`, `Ribbon/FreeXRibbonHandlerMap.g.cs`).
The rows below use the text/key tips exactly as declared there.

## File / Backstage / application chrome

| Command | Invocation path / shortcut | Intended observable result | Save check | Status |
|---|---|---|---|---|
| File / Home / Info / New / Open / Save / Save As / Print / Share / Export / Account / Feedback / Options / Close | File tab; `Alt,F`; rail key tips; `Ctrl+N`, `Ctrl+O`, `Ctrl+S`, `F12`, `Shift+F12`, `Ctrl+P`, `Ctrl+F4` where applicable | Backstage opens; selected pane or native file/print/share flow appears; file workflow either completes or surfaces a clear cancel/error state | Workbook for Save/Save As; Options for Options; External for Open/Print/Share/Export | Not run |
| Info: Protect Workbook; Check Accessibility; Workbook Statistics; Error Checking | File > Info; key tips `PW`, `CA`, `W`, `EC` | Info action changes protection state or opens its inspection/statistics dialog | Workbook for protection; None for inspectors | Not run |
| Recent / pinned files: Open, Pin, Unpin, Remove from list, Open file location | File > Home/Recent/Pinned; right-click recent item | List changes or file opens; location command enters OS shell | Options for pin/list state; External for location | Not run |
| Window chrome: Minimize; Maximize/Restore; Close; system Move; system Size; next/previous workbook window | caption buttons; `Ctrl+F9`, `Ctrl+F10`, `Ctrl+F4`, `Ctrl+F7`, `Ctrl+F8`, `Ctrl+Tab`/`Ctrl+Shift+Tab` | Expected window state/system operation or active workbook window changes | None | Not run |
| Help: Help Online; Feedback; Copy Diagnostics; Test Crash Reporting; Check for Updates; About FreeX; Legal Notices | Help tab `Alt,Y`; `H/F/D/T/U/A/L`; `F1`/Help shortcut when routed | Browser, clipboard, dialog, update check, or legal/about surface opens | External for browser/update; None otherwise | Not run |

## Home ribbon (`Alt,H`)

| Group / command | Invocation path / key tips | Intended observable result | Save check | Status |
|---|---|---|---|---|
| Clipboard ? Paste; Cut; Copy; Format Painter | Home > Clipboard; `V/X/C/FP`; `Ctrl+V/X/C` | Clipboard operation or formatting-paint mode; pasted/cut/copy selection feedback | Workbook except Copy; None for Copy | Not run |
| Paste menu ? Paste; Values; Formulas; Formatting; Keep Source Column Widths; Values & Source Formatting; Transpose; Paste Link; Picture; Linked Picture; Paste Special | Home > Paste dropdown; `P/V/F/R/W/A/T/L/I/K/S`; `Ctrl+Alt+V` for Paste Special | Selected paste mode applies or dialog opens | Workbook (except dialog cancel) | Not run |
| Font ? Font; Font Size; Increase/Decrease Font Size; Bold; Italic; Underline/Double Underline; Strikethrough; Borders; Fill Color; Font Color; Font dialog | Home > Font; key tips as displayed (`1/2/3/4`, `B/H/FC`); `Ctrl+B/I/U`, `Ctrl+1`, `Ctrl+Shift+F/P` | Font/format state changes or Font page of Format Cells opens | Workbook | Not run |
| Borders menu | Home > Borders: Bottom/Top/Left/Right/No/All/Outside/Inside/Thick Outside/Bottom Double/Thick Bottom/Top+Bottom/Top+Thick Bottom/Top+Double Bottom; Draw Border/Draw Border Grid/Erase Border; Line Color (Black/Gray/Accent 1/Accent 2); Line Style (Thin/Medium/Thick/Dashed/Dotted/Double); More Borders | Chosen border/style/color is applied to the selection; Accent swatches follow the active workbook theme | Workbook | Not run |
| Alignment ? Top/Middle/Bottom; Left/Center/Right; Orientation (Horizontal, angles, Vertical, Rotate Up/Down); Wrap Text; Increase/Decrease Indent; Merge & Center/Merge Across/Merge Cells/Unmerge; Alignment dialog | Home > Alignment; `AT/AM/AB/AL/AC/AR/RO/W/AO/AI/M`; `Ctrl+1` | Alignment, orientation, indentation, wrapping, or merge state changes / dialog opens | Workbook | Not run |
| Number ? Number Format (General, Number, Currency, Accounting, Date, Percentage, Text); Accounting currency variants; Percent; Comma; Increase/Decrease Decimal; Number dialog | Home > Number; `N/AN/P/K/QI/QD`; numeric shortcut family `Ctrl+Shift+~ ! @ # $ % ^`; `Ctrl+1` | Number format/decimal state changes or dialog opens | Workbook | Not run |
| Styles ? Conditional Formatting (all Highlight/Top-Bottom/Data Bar/Color Scale/Icon Set/New/Clear/Manage options); Format as Table; Cell Styles (all gallery styles) | Home > Styles; `L/T/J`; submenu key tips as shown | Formatting rule/table/style is applied, edited, cleared, or dialog/gallery opens | Workbook | Not run |
| Cells ? Insert Cells/Rows/Columns/Sheet; Delete Cells/Rows/Columns/Sheet; Row Height/AutoFit; Column Width/AutoFit; hide/unhide rows/columns/sheet; Rename Sheet; Tab Color; Protect Sheet; Lock Cell; Format Cells | Home > Cells > Insert/Delete/Format; key tips declared in `HomeRibbonMenus.g.cs` | Structural, dimensions, visibility, sheet, protection, or formatting change; required dialog opens | Workbook | Not run |
| Editing ? AutoSum (Sum/Average/Count Numbers/Count All/Max/Min/More Functions); Fill (Down/Right/Up/Left/Series/Flash Fill); Clear (All/Formats/Contents/Comments+Notes/Hyperlinks); Sort & Filter; Find/Replace/Go To/Go To Special and selection kinds | Home > Editing; `U/FI/E/S/FD`; `Alt+=`, `Ctrl+D/R/E`, `Ctrl+F/H/G`, `F5` | Formula/data manipulation or its dialog/selection result | Workbook except Find/Go To | Not run |

## Insert, Draw, and Page Layout

| Group / command | Invocation path / key tips | Intended observable result | Save check | Status |
|---|---|---|---|---|
| Insert > Tables ? PivotTable; PivotChart; Table | `Alt,N > PT/PC/TB`; `Ctrl+T`/`Ctrl+L` for Table | Target insertion dialog/object/table appears or is created | Workbook | Not run |
| Insert > Charts ? Recommended Charts; Column/Stacked/100% Column; Bar/Stacked/100% Bar; Line; Area; Stock; Pie; Doughnut; Scatter; Bubble; Radar; Select Data Source | Insert > Charts; `RC/CC/SC/PCC/BC/SB/PB/LC/AC/ST/PY/DO/SX/BU/RD/DS` | Requested chart chooser/type or data-source editor appears; confirmed insertion creates chart | Workbook | Not run |
| Insert > Sparklines/Filters/Controls/Links/Comments/Text/Symbols | Line/Column/Win-Loss Sparkline; Insert Timeline; Form Controls submenu (Check Box, Option Button, Button, Drop-Down, List Box, Spin Button, Scroll Bar); Insert Link; Comment; Text Box; Header & Footer; Symbol ? `SL/SK/SW/IT/FC/K/C2/TX/HF/SY` | Object/dialog or editing mode appears, then creates/configures target on confirmation | Workbook | Not run |
| Draw > Illustrations/Arrange/Format | Pictures; Shapes; Bring Forward; Send Backward; Selection Pane; Rotate Object; Object Size; Shape Fill; Object Outline; Crop/Reset Crop; Shape Gradient; Shape Effects (No effect, Shadow, Inner Shadow, Reflection, Glow, Soft Edges, Bevel, 3-D Rotation) | `Alt,J`; listed key tips; object selected where required | Picker or object-editor opens; arrangement/format/crop/effect visibly changes selection | Workbook (External for picker) | Not run |
| Page Layout > Themes | Themes; Theme Colors; Theme Fonts; Theme Effects; Office/Colorful/Grayscale presets; all Customize commands | `Alt,P > TH/TC/TF/TE`; submenu tips | Theme state updates or customization dialog opens | Workbook | Not run |
| Page Layout > Page Setup | Page Setup launcher; Margins (Normal/Wide/Narrow/Custom); Orientation; Size (Letter/Legal/Executive/Statement/Tabloid/A4/A3/A5/B4/B5); Print Area set/clear; Break insert/remove/reset; Background choose/delete; Print Titles | `Alt,P`; menu tips as declared | Page setup state changes or dialog/picker opens | Workbook | Not run |
| Page Layout > Scale / Sheet Options | Scale Width/Height/Percent (Automatic, 1/2 pages, presets); Scale to Fit; View/Print Gridlines; View/Print Headings | `SW/SH/SC/SF/VG/PG/VH/PH` | Scale or sheet display/print settings visibly update | Workbook; view-only toggles should also be checked after reopen | Not run |

## Formulas, Data, Review, and View

| Group / command | Invocation path / key tips | Intended observable result | Save check | Status |
|---|---|---|---|---|
| Formulas > Function Library | AutoSum and its Sum/Average/Count Numbers/Count All/Max/Min/More Functions; Recently Used; Financial; Logical; Text; Date & Time; Lookup & Reference; Math & Trig; More Functions | `Alt,M`, `U/RU/Y/L/TF/DT/K/MT/MF`; `Alt+=`, `Shift+F3` | Formula is inserted or function-picker/category menu appears | Workbook once formula confirmed | Not run |
| Formulas > Defined Names/Auditing | Name Manager; Define Name; Use in Formula; Create from Selection; Trace Precedents/Dependents; Remove All/Precedent/Dependent Arrows; Show Formulas; Error Checking/Options; Evaluate Formula; Watch Window | `N/DN/I/CS/TP/TD/RA/SF/EC/V/W`; `Ctrl+F3`, `Ctrl+Shift+F3`, `Ctrl+~`, `Alt+Shift+F10` | Name/auditing dialog or overlay/setting appears; arrows/remove/show mode update | Workbook for names/show-formulas; None for transient overlays | Not run |
| Formulas > Calculation | Calculate Now; Calculate Sheet; Automatic; Automatic Except Data Tables; Manual | `CN/SC/O`; `F9`, `Shift+F9`, `Ctrl+Alt+Shift+F9` | Recalculation completes or calculation mode checks change | Workbook for mode; None for recalc | Not run |
| Data > Get/Connections/Sort & Filter | Get Data; Refresh All; Sort A?Z; Sort Z?A; Sort; Filter; Clear; Advanced; Reapply | `Alt,A`; `D/FA/SA/SD/SO/T/C/A/R`; `Ctrl+Shift+L`, `Ctrl+Alt+L` | Query/dialog or filter/sort state updates | Workbook except refresh-only | Not run |
| Data > Tools/Forecast/Outline | Text to Columns; Flash Fill; Remove Duplicates; Data Validation/Circle Invalid/Clear Circles; Consolidate; Goal Seek/Scenario Manager/Data Table; Forecast Sheet; Group/Ungroup/Clear Outline; Subtotal; Hide/Show Detail | `E/FF/M/V/N/W/FS/G/U/B/H/J`; `Ctrl+E`, `Alt+Shift+Right/Left`, `Ctrl+8` | Dialog opens or resulting data, validation, outline, or subtotal state changes | Workbook | Not run |
| Review > Proofing/Accessibility/Changes | Spelling; Translate; Check Performance; Workbook Statistics; Check Accessibility; Alt Text; Show Changes | `Alt,R`; `SP/TR/CP/W/CA/T/CH`; `F7`, `Ctrl+Shift+G` | Checker/pane/dialog opens, status/result is actionable | Workbook only for persisted alt text/fixes | Not run |
| Review > Comments/Notes/Protect | New/Delete/Previous/Next/Show Comments; New/Edit/Delete/Previous/Next/Show Notes; Convert to Comments; Protect Sheet; Protect Workbook; Allow Users to Edit Ranges; Share | `CM/XC/PC/JC/SC/O/E/D/PN/N/H/CV/PS/PW/AR/SH`; `Shift+F2` | Comment/note/protection/share surface changes or dialog opens | Workbook for comments/notes/protection; External for Share | Not run |
| View > Views/Show/Zoom | Normal; Page Break Preview; Page Layout; Custom Views; Gridlines; Headings; Ruler; Formula Bar; Zoom preset 200/100/75/50/25/Custom; 100%; Zoom to Selection | `Alt,W`; listed tips; `Ctrl+Alt++/-` | View mode, visibility, zoom, or dialog changes | Workbook where serialized; Options/None for shell-only if source shows it | Not run |
| View > Window | New Window; Arrange All (Tiled/Horizontal/Vertical/Cascade); Freeze at Selection/Top Row/First Column/Unfreeze; Split; View Side by Side; Synchronous Scrolling; Switch Windows; Hide/Unhide; Reset Window Position | `NW/A/FP/SP/B/SS/W/H/U/RP`; `Ctrl+F6`, `Ctrl+Shift+F6` | Window/pane arrangement or frozen/split state changes | Workbook for worksheet window settings where saved; None otherwise | Not run |

## Contextual object ribbons

| Surface / command | Invocation path / key tips | Intended observable result | Save check | Status |
|---|---|---|---|---|
| Chart Design (`chart.selected`) | Select chart > `Alt,JC`: Chart Titles; Data Labels; Data Label Position; Trendline; Error Bars; Secondary Axis/Series; Chart Styles; Select Data Source; Change Chart Type; Combo Chart/Series; Move Chart | Editor/menu appears or selected chart property changes | Workbook | Not run |
| Chart Format (`chart.selected`) | Select chart > `Alt,JF`: Format Chart Area; Format Bar/Column/Pie-Doughnut/Bubble/Stock; Chart/Plot fill/border; Series color/width/dash/marker/size; chart/axis/legend/data-label text/fill/border; X/Y bounds/gridlines/labels/ticks/fonts/angles/lines/number formats/gridline styles/log scale | Correct chart formatting dialog/property state appears and applies to the intended element | Workbook | Not run |
| Picture Format (`picture.selected`) | Select picture > `Alt,JP`: Format Picture; Crop/Reset Crop; Bring Forward; Send Backward; Selection Pane; Rotate; Object Size; Alt Text | Picture editor or format/action result appears | Workbook | Not run |
| Shape Format (`shape.selected`) | Select shape/text box > `Alt,JS`: Shape Fill; Object Outline; Shape Gradient; Shape Effects; Bring Forward; Send Backward; Selection Pane; Rotate; Object Size; Alt Text | Shape editor/action result appears | Workbook | Not run |
| Table Design (`table.active`) | Active table > `Alt,JT`: Table Name; Resize Table; Summarize with PivotTable; Remove Duplicates; Convert to Range; Total/First/Last Column; Banded Rows/Columns; Filter Button; Table Styles | Table property/dialog/state changes apply to active table | Workbook | Not run |
| PivotTable Analyze (`pivot.active`) | Active pivot > `Alt,JA`: Name/Options; Field Settings; Group/Ungroup; Slicer/Timeline; Refresh/Change Data Source; Clear/Select/Move; Calculated Field/Item; PivotChart/Change Type/Options; Field List; +/- Buttons; Field Headers | Pivot command surface opens or active pivot model/rendering changes | Workbook | Not run |
| PivotTable Design (`pivot.active`) | Active pivot > `Alt,JD`: Grand Totals; Subtotals; Report Layout; Blank Rows; Banded Rows/Columns; Row/Column Headers; PivotTable Styles | Pivot layout/style changes apply to active pivot | Workbook | Not run |

## Grid, headers, filter, and object context menus

| Target / command | Invocation path / access keys | Intended observable result | Save check | Status |
|---|---|---|---|---|
| Cell / generic worksheet | Right-click cell or `Shift+F10`: Cut, Copy, Paste; Paste Special; Insert Copied Cells; Insert/Delete Cells, rows, columns; Sort A?Z/Z?A/Custom; Filter/Clear/Reapply/Pick from Drop-down; Quick Analysis; Define Name; Create/Format Table; Text to Columns; Remove Duplicates; Data Validation | Menu opens at target; each item follows its named action and updates target/selection/dialog | Workbook except clipboard/dialog-only | Not run |
| Cell: rows/columns | Same menu > Rows and Columns: Row Height/AutoFit/Hide/Unhide; Column Width/AutoFit/Hide/Unhide; Group/Ungroup | Dimensions, visibility, or outline update | Workbook | Not run |
| Cell: review/link/pivot | Same menu > Comments and Notes: New/Edit/Resolve/Unresolve/Delete Comment, New/Edit/Delete/Show-Hide/Show All Note; Hyperlink/Open/Edit/Remove; PivotTable Options; Format Cells; Clear Contents/All/Formats/Comments+Notes/Hyperlinks | Appropriate state-aware actions enable/disable and act on target | Workbook except open link | Not run |
| Row/column header | Right-click header: header is selected (or existing whole-row/column selection retained), then its row/column menu variant | Selection preservation and structural/sizing commands apply to correct full band | Workbook | Not run |
| Picture / shape / text box | Right-click object: Cut/Copy/Paste/Delete; format; crop/reset (picture); size/properties; rotate; fill/outline (shape); alt text; selection pane; bring forward/send backward for reorderable targets | Object-target menu is correct and changes only selected object | Workbook except Copy | Not run |
| Chart / waterfall point | Right-click chart: Cut/Copy/Paste/Delete; Format Chart Area; Select Data; Change Type; Styles; Titles; Size/Properties; Move; order; Alt Text; Selection Pane. Right-click waterfall point: Set as Total toggle | Correct object/point target is modified, and toggle state survives undo/redo | Workbook | Not run |
| Filter/pivot field/pivot header/pivot chart | Click filter/pivot dropdown or right-click field/header; exercise planner-provided sort/filter/field placement/value settings/clear choices | Menu options reflect target state and selected command changes filter/pivot correctly | Workbook | Not run |
| Quick Analysis | Select range > `Ctrl+Q` or cell context menu > Quick Analysis; test formatting, charts, totals, tables, sparklines offered for the selection | Popup appears beside selection and confirmed choice applies expected object/format | Workbook | Not run |

## Sheet tabs, status bar, formula bar, and QAT

| Surface / command | Invocation path / shortcut | Intended observable result | Save check | Status |
|---|---|---|---|---|
| Sheet tabs | Click/select; `Ctrl+PageUp/PageDown`; `Ctrl+Shift+PageUp/PageDown`; tab-strip scroll/navigation; drag reorder | Active/grouped sheet or tab order changes; overflow controls keep active tab reachable | Workbook for grouping/order | Not run |
| Sheet tab context menu | Right-click tab / Apps key: Insert Sheet; Delete Sheet; Rename; Move or Copy; View Code (expected disabled); Protect Sheet; Tab Color (palette + More Colors); Hide/Unhide; Outline Settings; Select All Sheets; Ungroup Sheets | State-aware enablement and named sheet operation; View Code remains disabled | Workbook except View Code | Not run |
| Add sheet | `+` button or `Shift+F11` | New worksheet is inserted and selected | Workbook | Not run |
| Formula/name bar | Name box selection/navigation; formula edit/commit/cancel; Insert Function; range-point mode; formula-bar expand; edit-cell `F2` | Correct focus, address selection, formula text, commit/cancel, and status cue | Workbook when formula/value committed | Not run |
| Status bar | Zoom out/slider/in/text; Normal/Page Layout/Page Break Preview; right-click Customize Status Bar; keyboard focus cycle `F6`/`Shift+F6` and Tab/Escape within bar | Zoom/view changes, options visibility toggles, and focus returns to worksheet cleanly | Options for customization; Workbook/view state where serialized | Not run |
| QAT default + catalog | Default Save/Undo/Redo; add/select the full catalog: New/Open/Save As/Print/Export PDF-XPS/Cut/Copy/Paste/Format Painter/Bold/Italic/Underline/Fill/Font Color/Format Cells/Insert Function/AutoSum/Calculate Now/Sheet/Refresh All/Sort A?Z/Z?A/Filter/Data Validation/Name Manager/Spelling/Accessibility/Share/100%/Zoom Selection/Freeze/Insert Sheet/Find & Select/Selection Pane | Click dispatches same action as main surface; history arrows show undo/redo history; key tips use visible ordinal | Options for QAT list and above/below-ribbon placement; workbook as command requires | Not run |
| QAT customization | Right-click a ribbon/QAT item > Add/Remove from QAT; QAT options dialog; Above/Below Ribbon | Command list/order/placement updates immediately and survives restart | Options | Not run |

## Keyboard-only inventory

The routed shortcut source has exact mappings; manually test both the command and
the condition in which it is disabled or intercepted by cell/formula editing.

| Shortcut family | Commands to execute | Save check | Status |
|---|---|---|---|
| File/edit | `Ctrl+N/O/S`, `F12`, `Shift+F12`, `Ctrl+P`, `Ctrl+C/X/V`, `Ctrl+Alt+V`, `Ctrl+Z/Y`, `Alt+Backspace`, `Ctrl+F4` | Workbook/External as appropriate | Not run |
| Selection/navigation | `Ctrl+A`, `Ctrl+Arrow`, `Ctrl+Backspace`, `Ctrl+.`, `F2`, `Enter`, `Esc`, `Alt+Down`, `Shift+F10`/Apps, `F6`/`Shift+F6` | None unless editing commits | Not run |
| Formatting/entry | `Ctrl+B/I/U`, `Ctrl+5`, `Ctrl+1`, `Ctrl+Shift+F/P`, number-format shortcuts, `Ctrl+;`, `Ctrl+Shift+;`, `Ctrl+'`, `Ctrl+Shift+'`, `Backspace`, `Shift+Backspace` | Workbook when content/format changes | Not run |
| Data/formula | `Ctrl+D/R/E`, `Ctrl+Shift+L`, `Ctrl+Alt+L`, `Ctrl+Q`, `Alt+=`, `Shift+F3`, `Ctrl+F3`, `Ctrl+Shift+F3`, `Ctrl+~`, `F9`, `Shift+F9`, `Ctrl+Alt+Shift+F9`, `Alt+Shift+F10`, `Ctrl+[ / ]`, `Ctrl+Shift+[ / ]`, `Ctrl+8` | Workbook for changes; None for navigation/inspection | Not run |
| Find/sheet/view | `Ctrl+F/H/G`, `F5`, `F7`, `Ctrl+Shift+G`, `Ctrl+PageUp/PageDown`, `Ctrl+Shift+PageUp/PageDown`, `Shift+F11`, `Alt+F1`, `F11`, `Ctrl+Alt++/-` | Workbook only where setting/content changes | Not run |
| Ribbon/key tips/window | `Alt` to enter ribbon key tips, top-level tab key tips `F/H/N/J/P/M/A/R/W/Y`, contextual key tips `JS/JP/JC/JF/JT/JA/JD`; `Ctrl+F5/F7/F8/F9/F10`, `Ctrl+Tab` | None except action-specific result | Not run |

## Dialog and surface completeness checks

Use `InteractionSurfaceCatalog.Dialogs` as the canonical dialog *family* list.
For every dialog opened from a row above, test initial focus, Tab/Shift+Tab,
Enter where meaningful, Escape/cancel, validation/disabled Apply/OK, and focus
return. This covers application, workbook, worksheet, formatting, data,
formula, chart, pivot, drawing, review, page-layout, protection, and view
families without inventing undocumented controls. The catalog marks several
portable-desktop implementations `Unverified`; this inventory is intentionally
for the implemented FreeX command surface, so record the running shell in the
test evidence.

## Source evidence that is ambiguous or needs a targeted observation

* Ribbon definitions prove reachability and provide a host handler registration,
  but a label alone cannot prove the dialog's complete interaction contract or
  whether its successful change round-trips to every supported file format.
* The `HomeRibbonMenus.g.cs` comment says it was extracted from older ribbon
  XAML. Treat the current generated definition as the reachability source and
  verify every listed menu item is still visible/enabled in the live shell.
* Some commands are intentionally conditional: contextual tabs, object menus,
  filter/pivot variants, QAT availability, sheet protection, and enabled
  state all depend on selection/workbook state. Test both eligible and
  ineligible cases.
* Backstage has WPF and portable projections; the interaction catalog labels
  some portable surface capability `Unverified`. Do not treat WPF behavior as
  cross-platform evidence.
* Browser, native picker, printer, share, and update commands cross an OS or
  external boundary. Capture the handoff and cancel path; they do not have a
  normal workbook save assertion.

## Evidence record template

For each checklist item record: build/SHA, shell, workbook/fixture, starting
selection and preconditions, exact invocation, screenshot or automation trace,
result, save/reopen observation, undo/redo result where mutating, corresponding
Excel result, and a status replacing `Not run` (`Pass`, `Gap`, `Blocked`, or
`Not applicable` with reason).
