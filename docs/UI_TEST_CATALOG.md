# FreeX UI Test Catalog

Canonical path: `docs/UI_TEST_CATALOG.md`
Baseline source: synced from latest `origin/main` before each catalog update.

## Purpose

This is the comprehensive and append-only UI test catalog for FreeX. It translates the command parity, shortcut parity, and WPF surface into an execution plan for mouse, keyboard, keytip, context-menu, dialog, and UI Automation testing, and it is also the single chronological place to record coverage status, findings, smoke checks, blocked attempts, and session notes.

Do not append new UI testing work to a separate coverage log. Every pass should update this catalog with which rows were exercised, what target was used, which command was expected, and which model/UI state proved the action worked.

## Coverage Contract

Every supported command should eventually have evidence for each applicable layer:

| Layer | Required proof |
|---|---|
| Visible surface | Button/menu/control is visible in the correct ribbon, backstage page, dialog, context menu, status bar, or grid state. |
| Mouse activation | Click, double-click, drag, wheel, resize, or menu selection triggers the expected command path. |
| Keyboard activation | Shortcut, access key, keytip sequence, tab traversal, Enter/Space, Escape, and accelerator behavior trigger or cancel correctly. |
| Command routing | The UI path reaches the intended host handler and command bus/model command where one exists. |
| State mutation | Workbook, sheet, selection, style, drawing, chart, pivot, table, view, file, or dialog state changes exactly as expected. |
| Undo/repeat | Undo/redo and F4 repeat are verified for commands that are meant to be undoable or repeatable. |
| Target breadth | The command is tested against every supported target class listed in the target matrix below. |
| Accessibility | Automation name/id, Invoke/Toggle/Selection/ExpandCollapse pattern, focus return, and disabled-state behavior are verified where applicable. |
| Persistence | Save/load or export output is checked when the command changes persisted workbook state. |

## Current Verification Baseline

| Check | Command | Result |
|---|---|---|
| Git state | `git status --short --branch` | Record the active session branch and leave unrelated modified files untouched. |
| Worktrees | `git worktree list --porcelain` | Current checkout is an active session branch; no nested worktree created. |
| Build | `dotnet build FreeX.slnx -m:1` | Passed, 0 warnings, 0 errors. |
| Rebuild after worktree changed | `dotnet build FreeX.slnx -m:1` | Passed, 0 warnings, 0 errors. |
| Focused finding regression tests | `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter "FullyQualifiedName~MainWindowXamlKeyTipTests\|FullyQualifiedName~KeyboardShortcutMatcherTests\|FullyQualifiedName~WorksheetContextMenuPlannerTests"` | Passed, 194 tests, 0 failures. |
| UIA dialog entry regression tests | `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter "FullyQualifiedName~MainWindowXamlKeyTipTests"` | Passed, 68 tests, 0 failures. |
| UIA dialog entry regression recheck | `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter "FullyQualifiedName~MainWindowXamlKeyTipTests" -m:1 /nodeReuse:false -p:UseSharedCompilation=false` | Passed, 74 tests, 0 failures. |
| Host regression suite | `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj` | Passed, 847 tests, 0 failures. |
| Current build | `dotnet build FreeX.slnx -m:1` | Passed, 0 warnings, 0 errors. |
| Continuation UIA/mouse dialog pass | Fresh Debug build launched via `src\FreeX.App.Host\bin\Debug\net10.0-windows10.0.19041.0\FreeX.App.Host.exe`; UIA activation plus guarded mouse clicks where foreground was verified. | Account and About opened by foreground-confirmed mouse clicks. UIA `InvokePattern` still returned success for Insert Function/About without opening a dialog before the fix. |
| Catalog branch build baseline | `dotnet build FreeX.slnx -m:1 /nodeReuse:false -p:UseSharedCompilation=false` | Passed on 2026-05-21 from latest fetched `origin/main`. |

## Coverage Model

Each surface is tracked with these states:

| State | Meaning |
|---|---|
| Not Started | No current manual pass in this session. |
| In Progress | One or more paths tested, more expected. |
| Passed | Smoke path passed with no issue observed. |
| Finding | One or more issues recorded below. |
| Blocked | Could not test because of environment, missing data, modal/system dependency, focus safety, or crash. |
| Excluded | Intentionally out of scope for FreeX or delegated to operating-system/native UI. |

## Inventory Snapshot

| Source | Current count | Notes |
|---|---:|---|
| Command surface in-scope rows | 196 | From `COMMAND_INVENTORY.json`: Implemented + Partial command-surface rows. |
| Menu/toolbar in-scope rows | 197 | Includes the current Draw tab menu/toolbar delta. |
| Top-level ribbon/backstage tabs | 10 | File, Home, Insert, Draw, Page Layout, Formulas, Data, Review, View, Help. |
| Contextual ribbon tab declarations | 3 | Table Design, PivotTable Analyze, Design from collapsed `MainWindow.xaml` tab declarations. |
| Dialog source classes | 107 | Unique `*Dialog` class/x:Class names in `src/FreeX.App.Host`. |
| XAML click-wired controls | 622 | `Click="..."` occurrences in `MainWindow.xaml` on latest synced `origin/main`. |
| Explicit UIA automation ids | 55 | `AutomationProperties.AutomationId="..."` declarations in `MainWindow.xaml`. |
| Ribbon keytip metadata declarations | 656 | `RibbonTooltip.KeyTip="..."` declarations in `MainWindow.xaml`. |
| Keyboard command shortcut usages | 74 | 74 matcher rules / 73 dispatcher targets |
| Documented shortcut rows | 87 | From `SHORTCUT_PARITY_MATRIX.md`: 87 parity, 0 partial. |
| Worksheet context menu commands | 50 | From `WorksheetContextMenuPlanner.BuildCommands()`. |
| Screenshot tool scripts | 2 | `tools/screenshot_excel.ps1`, `tools/screenshot_ribbon.ps1` documented and present. |
| Existing UI evidence screenshots | 0 | Historical PNG evidence artifacts were removed during documentation cleanup; append new evidence paths to the relevant row. |

## Target Matrix

Each command should be tested against every applicable target. Mark non-applicable targets explicitly instead of leaving them ambiguous.

| Target class | Required variants |
|---|---|
| Cell | blank, value, formula, error, date/time, formatted, protected locked/unlocked. |
| Range | single cell, contiguous range, multi-area selection, whole row, whole column, whole sheet, current region, visible-cells-only filtered range. |
| Sheet | first/middle/last sheet, hidden/very hidden where supported, grouped sheets, chart sheet, renamed sheet, colored tab. |
| Table | plain range, structured table with headers, totals row, filtered table, styled table. |
| PivotTable | row fields, column fields, value fields, page filters, empty intersections, contextual Analyze/Design tabs, field list. |
| Chart | embedded chart, chart sheet, PivotChart, selected series/point/axis/title/legend/plot area/chart area. |
| Drawing object | picture, shape, text box, selected object, multi-object selection where supported, cropped/rotated/resized object. |
| Sparkline | line/column/win-loss groups, selected sparkline range, hidden row/column interactions. |
| Slicer/timeline | active slicer, active timeline, connected PivotTable, selected/cleared items. |
| Workbook/file | unsaved workbook, saved XLSX, CSV, unsupported-feature XLSX, read/write path, missing file, print/export output. |
| View state | normal/page layout/page break, frozen panes, split panes, zoom levels, hidden headings/gridlines/formula bar. |
| Dialog state | default values, changed values, invalid input, OK, Cancel, Escape, access keys, focus order. |

## Interaction Channels

| Channel | Scope |
|---|---|
| Mouse | Ribbon buttons, dropdown arrows, menu items, grid click/drag, fill handle, column/row resize, sheet tabs, status zoom, dialogs, backstage navigation. |
| Keyboard shortcut | All rows in `SHORTCUT_PARITY_MATRIX.md`, with exact-modifier rejection where documented. |
| Ribbon keytips | Alt/F10 top-level badges, tab badges, QAT badges, command badges, dropdown menu keytips, nested Conditional Formatting menu keytips, Escape cancellation. |
| Access keys | Dialog mnemonic labels, menu headers, backstage commands, context menus, OK/Cancel/Apply-style button rows. |
| Context menu | Worksheet right-click, Shift+F10, Menu key, sheet-tab context menu, pivot field context menu, chart/PivotChart field menus, object-aware variants. |
| UI Automation | Stable AutomationId/Name, Invoke/Toggle/Selection/ExpandCollapse patterns, focus movement, top-level owned dialog detection. |
| Direct model verification | Use command bus state, workbook model assertions, saved file inspection, or existing unit tests to confirm non-visual effects. |

## Inspected Surface Inventory

| Surface | Catalog notes |
|---|---|
| Shortcut/keytip routing | 87 documented shortcut rows; 74 matcher rules; 73 dispatcher targets; broad XAML keytip metadata including top-level `F/H/N/J/P/M/A/R/W/Y` plus contextual PivotTable `JA/JD`; representative nested menu keytip coverage exists; all 87 shortcut rows are at Parity. |
| Mouse/grid interaction | Grid click, Shift+click, drag selection, double-click edit/pivot detail, row/column/top-left header selection, autofill handle, row/column resize, page-layout margin guide drag, split divider drag, split-pane mini-scrollbars, pivot chart field buttons, wheel/Shift+wheel/Ctrl+wheel, and sheet-tab click/group/drag/double-click/right-click all need live WPF hit-test evidence. |
| Context menus | Worksheet context menu has 50 planner commands and should be tested through right-click, Shift+F10, Menu key, access-key traversal, target-specific disabled states, and command state mutation. Sheet-tab, pivot field, ribbon dropdown, backstage recent/pinned, and object-aware context menus need separate rows. |
| Ribbon/backstage/dialogs | Backstage, QAT, Home, Insert, Draw, Page Layout, Formulas, Data, Review, View, contextual PivotTable Analyze/Design, and Help are fully inventoried in parity docs. Dialog coverage is strong at parser/planner level but needs real focus order, access keys, Escape/Enter/default/cancel, high-DPI layout, and UIA pattern checks. |
| System-dependent flows | Open/Save file dialogs, picture/background import, CSV Get Data, PDF/XPS export save dialogs, Windows Share, browser Help/Feedback links, and print dialogs require guarded environment-aware manual testing. |

## Live Input Safety Rule

Before any global keyboard or mouse input, verify that the foreground window belongs to the launched FreeX process and that the window title matches the expected workbook. Re-check this before every click, drag, wheel, or key sequence. If any other application owns foreground focus, mark the attempt Blocked and discard any screenshots from that attempt.

## Command Families

| Area | Surfaces to exercise | Required target breadth | Existing automated coverage | Manual/UI gaps |
|---|---|---|---|---|
| App shell and title bar | Launch, QAT Save/Undo/Redo, custom title buttons, window focus/activation. | Unsaved workbook, saved workbook, maximized/restored window. | App host source hygiene and QAT/keytip tests. | Real window chrome clicks, Alt+Space/system behavior, focus after modal closure. |
| File/backstage | New, Open, Save, Save As, Print, Export, Info, Share, Account, Options, Recent/Pinned, Close, Back. | Unsaved/saved file, missing recent file, unsupported XLSX, print/export scopes. | Backstage automation/keytip/source tests; print/export planner tests. | Native file dialogs, guarded mouse clicks, UIA Invoke on every backstage command, output file inspection for PDF/XPS. |
| Formula bar/name box | Name box navigation, formula entry, `fx`, expand/collapse, formula edit references. | Named range, A1/R1C1, cross-sheet refs, long formula, invalid reference. | Cell entry/parser, formula reference and edit planner tests. | Mouse focus into name box/formula bar, F2/Ctrl+F2 parity, visual reference highlight confirmation. |
| Worksheet grid | Selection, navigation, entry, edit, autofill, fill handle, resize, scroll, split/freeze, page layout margins. | Target matrix cell/range/view variants. | Selection/navigation/edit/viewport/grid planner tests. | Real drag selection, fill handle drag, resize mouse hit testing, wheel/trackpad scroll, page layout visual checks. |
| Home clipboard | Cut, Copy, Paste, Paste Special, Format Painter. | Internal/external text, formulas, styles, comments, validation, images, overlapping/non-overlapping cut paste. | Clipboard/paste planner and command tests. | Real clipboard formats, mouse paste dropdown, persistent Format Painter double-click and Escape cancel. |
| Home font/alignment/number/styles | Font, size, bold/italic/underline, colors, borders, alignment, merge, number formats, CF, Format as Table, Cell Styles. | Blank/value/formula/range/table/protected cells, themed workbook. | Style model, dialogs, planners, source hygiene tests. | Dropdown galleries by mouse/keytip, visual swatches, applied rendering across grid and saved XLSX. |
| Home cells/editing | Insert/delete cells/rows/cols/sheets, row/column size, hide/unhide, AutoSum, fill, Flash Fill, clear, sort/filter, find/replace/go-to. | Rows, columns, tables, filtered ranges, notes/comments, formulas. | Planner/command/filter/find tests. | Modal prompts through keyboard/mouse, F4 repeat, focus return, visible row/column state. |
| Insert | PivotTable, Table, charts, sparklines, pictures, shapes, text box, symbol, hyperlink, comment/note. | Range/table/pivot/chart/object targets. | Dialog parser/planner and chart/pivot tests. | End-to-end insert workflows, object selection handles, chart sheet activation, symbol picker mouse/keyboard. |
| Draw/object formatting | Shapes, ordering, size/rotate with default numeric-input focus, fill/outline/effects, crop/reset crop with left-crop focus, alt text. | Picture, shape, text box, selected chart/drawing object. | Drawing target/input parser and object dialog tests. | Mouse selection/drag handles, object context states, visual rendering after changes. |
| Page Layout | Themes, margins, orientation, size, print area, breaks, background, print titles, scale, sheet options, arrange. | Normal/page layout/page break views, saved print settings, exported output. | Page layout parser/dialog and print model tests. | Dialog tab traversal, live page layout visuals, print/export smoke. |
| Formulas | Insert Function, AutoSum categories, names, auditing, show formulas, error checking, evaluate, watch window, calculation. | Formula/value/error/cross-sheet refs, named ranges, watched cells. | Formula planner/dialog/error-checking tests. | Real Formula Auditing arrows, Watch Window add/delete/refresh, Evaluate Formula modal flow. |
| Data | Get data/import, refresh, sort/filter, Advanced Filter, Text to Columns, Remove Duplicates, Validation, Consolidate, What-If, Outline. | Tables, filtered ranges, grouped rows/columns, validation lists, scenario/data-table targets. | Data dialog parsers/planners and command tests. | Real dropdown filter UI, drag selected ranges into dialogs, grouped outline buttons, import/native file dialogs. |
| Review | Spelling, Accessibility, comments/notes, protect sheet/workbook/ranges, workbook statistics, share messages. | Notes/threaded comments, locked cells, protected sheet/workbook, issue-bearing workbook including low-contrast cell text. | Spell check, accessibility/protection/workbook stats tests. | Dialog workflows by mouse/keyboard, protected-state disabled commands, UIA names. |
| View | Workbook views, show toggles, freeze/split panes, zoom, arrange/window commands, custom views. | View-state matrix, hidden gridlines/headings/formula bar, multiple sheets. | View command and arrangement planner tests. | Real status zoom slider/buttons, split-pane drag, frozen pane visuals, custom view round trip. |
| Help | Help Online, Send Feedback, About, Legal Notices. | Online launch blocked/allowed environment, About dialog, offline legal notices. | Help/about/legal UIA and source tests. | Guarded external process checks, About dialog focus/accessibility, copyable packaged legal text. |
| Contextual PivotTable/PivotChart | Analyze/Design tabs, field list, filters, value settings, PivotChart buttons. | Pivot target matrix, slicer/timeline, chart field buttons. | Pivot planner/dialog/slicer/timeline tests. | Contextual tab visibility, field-list drag/drop, field button mouse menus. |
| Worksheet context menu | 50 planner commands via right-click, Shift+F10, Menu key. | Cell/range/row/column/table/filter/comment targets. | Worksheet context menu planner and source routing tests. | Every menu item by mouse and keyboard access key, disabled/hidden states by target. |
| Sheet tab strip | Add, rename, duplicate, delete, move, hide/unhide, color, group/ungroup, navigation arrows. | First/middle/last/hidden/grouped sheets. | Sheet tab service/planner tests where present. | Real tab drag/reorder, right-click menu, overflow arrows, grouped sheet commands. |
| Status bar | Ready text, selection stats, zoom out/in/slider, view hints. | Single/range numeric/text selection, formula/error cells, zoom min/max. | Status/stat planner tests. | Mouse click/drag slider, live stat update, accessibility names. |
| Dialog catalog | All modal and modeless dialogs from ribbon/context/backstage. | Valid/default/invalid/cancel states for every input field. | Parser/planner tests for most dialogs. | End-to-end keyboard tab order, access keys, UIA patterns, layout screenshots. |

## Full UI Surface Coverage

| Area | Status | Manual Scope |
|---|---|---|
| App launch and shell | In Progress | Process launch, main window render, custom title bar, QAT Save/Undo/Redo, minimize/maximize/close. |
| File/backstage/start overlay | In Progress | File tab, Home/Info/New/Open/Save/Save As/Print/Export/Account/Options/Close, recent/pinned list. |
| Formula bar and name box | In Progress | Name box navigation, formula entry, `fx` Insert Function, expand/collapse formula bar. |
| Worksheet grid core | In Progress | Cell selection, drag selection, data entry, inline edit, formula edit, navigation, undo/redo. |
| Home ribbon | In Progress | Clipboard, Paste Special, Format Painter, font, fill, border, alignment, number formats, styles, cells, editing. |
| Insert ribbon | In Progress | PivotTable, Table, charts, sparklines, pictures, shapes, text box, symbols, hyperlink with address-box default focus, comments. |
| Draw ribbon | In Progress | Shapes, ordering, size/rotation, fill/outline, alt text, crop/effects prompts. |
| Page Layout ribbon | In Progress | Margins, orientation, paper, print area, breaks, background, print titles, scale, themes, page setup. |
| Formulas ribbon | In Progress | Insert Function, AutoSum/categories, names, auditing, error checking, evaluate, watch window, calculation. |
| Data ribbon | In Progress | Import, refresh, sort/filter, Advanced Filter, Text to Columns, Remove Duplicates, Validation, What-If, outline. |
| Review ribbon | In Progress | Spell Check, Accessibility, comments/notes, protections, sharing messages, workbook statistics. |
| View ribbon | In Progress | Workbook views, show toggles, freeze/split panes, zoom, arrange/window commands. |
| Help ribbon | In Progress | Help, feedback, About and excluded/help messaging. |
| Contextual PivotTable tabs | Not Started | Analyze/Design visibility, field list, filters, value settings, contextual commands. |
| Worksheet context menu | In Progress | Shift+F10/Menu key/right-click, clipboard, insert/delete, sort/filter, notes, hyperlink, Format Cells, clear commands. |
| Sheet tab strip/context menu | In Progress | Add, rename, duplicate, delete, move, color, hide/unhide, grouping, tab navigation. |
| Status bar and zoom | In Progress | Ready/status text, selection stats, zoom buttons, slider, keyboard/mouse-wheel zoom. |
| Dialog catalog | In Progress | Format Cells, Find/Replace, Data Validation, Page Setup, Options, Names, CF manager, Goal Seek, Custom Views, pivot filters, Evaluate Formula, Watch Window, Theme, Symbol picker. |
| Keyboard shortcuts | In Progress | Shortcut matrix high-risk paths: Ctrl+P, Ctrl+V/Ctrl+Alt+V, Ctrl+1, Ctrl++/Ctrl+-, Alt+Down, Ctrl+Q, Shift+F10, F4 repeat. |
| Ribbon keytips | In Progress | Alt/F10 overlay, tab keytips, QAT keytips, visible command keytips, menu/nested menu keytips, Escape cancellation. |
| Accessibility and focus | In Progress | Keyboard-only traversal, focus return after dialogs, visible focus indicators, screen-reader naming smoke. |
| Visual fidelity | In Progress | Ribbon density, overlay placement, dialog layout, grid rendering, chart/drawing rendering, split/freeze visual behavior. |
| File IO and interop smoke | Not Started | Open/save round trip with representative XLSX/CSV, unsupported feature warnings, export output behavior. |

## Catalog Row Index

Append test results against these row IDs. A row is not complete until mouse, keyboard/keytip/access-key, UI Automation where applicable, target breadth, command route, visible result, and persistence proof are either passed or explicitly marked not applicable.

| Catalog ID | Area | Commands / controls | Required interaction paths | Targets / states | Required proof | Status |
|---|---|---|---|---|---|---|
| UI-CAT-SHELL-001 | Launch/title/QAT | Process launch, workbook title, Save, Undo, Redo, custom minimize/maximize/close. | Mouse, Alt+Space/system menu, QAT keytips, UIA invoke. | Unsaved workbook, saved workbook, maximized/restored window, dirty/clean undo stack. | Shell renders, focus lands in grid, QAT Undo/Redo enabled states are command-stack backed, title updates after save/rename. | In Progress |
| UI-CAT-SHELL-002 | Ribbon chrome | Tab selection, collapsed group overflow, keyboard focus, high-DPI/resize behavior. | Mouse tab click, F6/Shift+F6 shell focus cycling, Ctrl+F6 where supported, Alt/F10 keytips, Tab/Shift+Tab traversal, focused-ribbon arrow and Home/End traversal. | Narrow width, normal width, maximized, active contextual tab. | Correct tab/group visible, overflow menu preserves checked/input-gesture state, F6 skips regions that reject focus, focused Tab remains in ribbon traversal, Esc returns ribbon focus to worksheet, focus indicator remains visible. | In Progress |
| UI-CAT-FILE-001 | Backstage navigation | File Home/Info/New/Open/Save/Save As/Print/Export/Share/Account/Options/Close/Back. | Mouse, Alt+F keytips, Tab/Ctrl+Tab containment, F6/Shift+F6 containment, access keys, Escape, sidebar Up/Down/Home/End traversal, Shift+F10 recent/pinned row menus with first-item focus, UIA invoke. | Unsaved, saved local path, missing recent file, unsupported-feature workbook. | Correct page/dialog opens, File/Backstage focus lands on Home navigation for keyboard continuation, disabled/excluded commands explain state, Escape/Back returns focus to workbook, F6 does not move focus behind the overlay. | In Progress |
| UI-CAT-FILE-002 | Print/export | Print Preview, PDF/XPS export options, page ranges, open-after-publish, document properties. | Backstage mouse/keytip/access keys, dialog Tab/Enter/Escape, guarded native save dialog. | Active sheet, selected range, entire visible workbook, extensionless `.pdf`, explicit `.xps`, invalid path/page range. | Output file exists, metadata embedded, invalid input blocked, preview toolbar and close return focus. | Not Started |
| UI-CAT-GRID-001 | Grid selection/navigation | Cell/range/row/column/sheet selection, arrows, Tab, Enter, Home/End, Ctrl variants. | Mouse click/drag, Shift+click, keyboard shortcuts, name box navigation. | Blank/value/formula/error cells, whole row/column, multi-area where supported, filtered visible rows. | Selection model, name box, formula bar, status stats, and visual highlight all agree. | In Progress |
| UI-CAT-GRID-002 | Editing/formula entry | Type values/formulas, F2 edit, formula bar edit, reference highlighting, cancel/commit. | Mouse into grid/formula bar, keyboard, Enter/Tab/Escape, Ctrl+Enter where supported. | Long text, formula, cross-sheet reference, invalid formula, date/time, protected locked/unlocked cell. | Value/formula stored correctly, undo/redo works, invalid input messaging/focus recovery matches expectation. | In Progress |
| UI-CAT-GRID-003 | Pointer mechanics | Autofill handle, row/column resize, page-layout margins, split dividers, wheel/Shift+wheel/Ctrl+wheel. | Drag, double-click, wheel, keyboard fallback. | Normal/page layout/page break views, frozen panes, split panes, zoom min/max. | Hit targets respond only at correct edges, layout persists, scroll/zoom/status update correctly. | Not Started |
| UI-CAT-HOME-001 | Clipboard | Cut, Copy, Paste, Paste dropdown, Paste Special, Format Painter single/double-click. | Mouse, Ctrl+X/C/V, Ctrl+Alt+V, initial Paste Special focus, menu keytips, dialog access keys. | Values, formulas, formats, comments/notes, validation, tables, overlapping cut/paste, external text. | Clipboard effects, undo stack, cut marquee, persistent Format Painter, dialog choices, and target mutation verified. | In Progress |
| UI-CAT-HOME-002 | Font/alignment/number | Font family/size, grow/shrink, bold/italic/underline, borders, fill/font color, alignment, merge, number formats. | Ribbon mouse, dropdown galleries, keytips, Ctrl+B/I/U/5, Ctrl+1 dialog. | Blank/value/formula/range/table/protected cells, custom number LCIDs, theme color variants. | Rendered grid style, model style, saved/reloaded XLSX/native JSON state, undo/redo. | In Progress |
| UI-CAT-HOME-003 | Styles/conditional/table | Conditional Formatting, Format as Table, Cell Styles, table totals/filter styling. | Mouse galleries, nested menu keytips, dialogs, context menu where present. | Plain range, structured table with headers/totals, filtered table, themed workbook. | Gallery preview/selection, rule/table metadata, visible rendering, saved/reloaded package state. | In Progress |
| UI-CAT-HOME-004 | Cells/editing | Insert/delete cells/rows/columns/sheets, hide/unhide, row height/column width with default input focus, AutoFit, Clear, Fill, Flash Fill, Sort/Filter, Find/Replace/Go To. | Mouse, shortcuts, keytips, dialog access keys, context menu. | Rows, columns, formulas, notes, hyperlinks, filtered ranges, contact-pattern Flash Fill data. | Correct command route, visible sheet mutation, undo/redo/F4 repeat, dialog focus return. | In Progress |
| UI-CAT-INSERT-001 | Tables/pivots | PivotTable, Table, Pivot field list, value settings, pivot filters. | Mouse, keytips, dialog access keys, UIA invoke. | Source range/table, new sheet/current sheet placement, empty intersections, value formats, label/value filters. | Pivot/table created, contextual tabs visible, field list/action buttons work, saved/reloaded model state. | Not Started |
| UI-CAT-INSERT-002 | Charts/sparklines | Supported chart families, Select Data, Move Chart, chart formatting, line/column/win-loss sparklines. | Mouse, keytips, dialog access keys, chart selection handles. | Embedded chart, chart sheet, selected series/axis/title/legend/plot area, sparkline group. | Chart/sparkline renders, dialogs mutate model, unsupported chart families are disabled or clearly blocked. | Not Started |
| UI-CAT-INSERT-003 | Objects/links/text | Picture, shapes, text box, symbol, hyperlink, header/footer, comment/note. | Mouse, keytips, Ctrl+K, dialogs, object selection. | Picture/shape/text box, selected object, hyperlink cell, threaded comment/note cell. | Object appears and can be selected, dialog choices persist, saved/reloaded drawing/comment/hyperlink state. | In Progress |
| UI-CAT-DRAW-001 | Drawing commands | Rectangle, ellipse, line, bring/send, size/rotation, fill/outline, alt text, crop/reset, gradients/effects, Selection Pane. | Mouse, keytips, dialogs, list keyboard traversal, UIA patterns. | Picture, shape, text box, chart/drawing object, multiple objects where supported. | Object z-order/size/fill/name/visibility mutates, Selection Pane rename/visibility persists to native JSON/XLSX. | Not Started |
| UI-CAT-PAGE-001 | Page layout | Margins, orientation, paper size, print area, breaks, background, print titles, scale, gridlines/headings, themes, header/footer, page setup. | Mouse/keytips, dialogs, access keys, page-layout drag. | Normal/page layout/page break, saved print settings, themed workbook, export output. | Visual page setup changes, dialog state round trips, print/export output reflects settings. | In Progress |
| UI-CAT-FORMULAS-001 | Formula authoring/audit | Insert Function, AutoSum variants, function menus, names, Use in Formula, Create from Selection. | Mouse, keytips, shortcuts, dialog access keys, UIA invoke. | Named ranges, formula/value/error cells, cross-sheet refs. | Dialog results insert correct formula/name state, undo/redo, saved/reloaded defined names. | In Progress |
| UI-CAT-FORMULAS-002 | Formula diagnostics | Trace precedents/dependents, Remove Arrows, Show Formulas, Error Checking, Evaluate Formula, Watch Window, calculation options. | Mouse/keytips, Ctrl+`, dialog access keys, modal/modeless focus. | Error cells, inconsistent formulas, formulas referring to blanks, watched cells, manual/auto calc. | Arrows/rendering/status/dialog steps update correctly, Watch Window opens on the watch list with the first row selected when present, add/delete/refresh works, command buttons/list expose stable automation IDs/help text, and refresh preserves selected watched rows. | In Progress |
| UI-CAT-DATA-001 | Import/sort/filter | Get Data CSV, Refresh All, Sort, Filter dropdowns, Advanced Filter, AutoFilter search/select all. | Mouse, keytips, native file dialog guard, dropdown keyboard, access keys. | Tables/plain ranges, blanks, numeric/text/date filters, filtered rows, invalid CSV/path. | Rows hidden/shown correctly, sort/filter criteria persist where modeled, focus returns after dropdown/dialog. | In Progress |
| UI-CAT-DATA-002 | Data tools | Text to Columns, Remove Duplicates, Data Validation, Consolidate, Goal Seek, Scenario Manager, Data Table, Forecast Sheet. | Mouse/keytips, wizard/dialog access keys, range picker, Enter/Escape. | Delimited/fixed-width text, validation list/input/error, scenario variables, one/two-variable table. | Dialog choices mutate workbook correctly, invalid input blocked, Goal Seek status lands on the default action button, undo/redo. | In Progress |
| UI-CAT-DATA-003 | Outline | Subtotal, Group, Ungroup, Show/Hide Detail, outline buttons. | Ribbon mouse/keytips, grid outline buttons, keyboard where applicable. | Rows/columns grouped, nested groups, filtered ranges. | Data ribbon keytips now route `Alt,A,G` and `Alt,A,U` through the real Group/Ungroup commands and mutate selected row outline levels. Outline level rendering, collapse/expand buttons, nested groups, filtered ranges, and persistence remain. | In Progress |
| UI-CAT-REVIEW-001 | Proofing/accessibility | Spell Check, Accessibility Checker, Statistics. | Mouse/keytips, dialogs, list selection, access keys. | Text cells with known corrections, hyperlinks/emails/files skipped, inaccessible workbook issues including low-contrast cell text. | Replace/replace-all/ignore works, Accessibility Checker issue text receives default focus and includes the low-contrast cell location/message, stats dialog OK is focused by default, stats match workbook state, and proofing/statistics dialog fields and actions expose stable automation IDs/help text. | In Progress |
| UI-CAT-REVIEW-002 | Comments/protection/share | New/Delete/Previous/Next/Show Comment, New/Edit/Delete Note, previous/next/show notes, Protect Sheet/Workbook, Allow Edit Ranges, Share. | Mouse/keytips, Ctrl+Shift+F2, dialogs/access keys, protected-state command checks. | Note/comment cells, locked/unlocked cells, allowed ranges, saved/unsaved local file. | Comment/note/protection state mutates and persists, password dialogs focus password entry, Allow Edit Ranges focuses/selects the range box, disabled commands respect protection, share routes save when needed. | In Progress |
| UI-CAT-VIEW-001 | Workbook views/show toggles | Normal/Page Break/Page Layout, Custom Views, gridlines/headings/ruler/formula bar. | Mouse/keytips, dialog access keys, status/view buttons. | Multiple sheets, saved custom view, hidden UI toggles. | View state and UI visibility update, custom views save/show/delete correctly, persistence where supported. | In Progress |
| UI-CAT-VIEW-002 | Panes/window/zoom | Freeze Panes, Split, Zoom, Zoom to Selection, 100%, Arrange All. | Mouse/keytips, split drag, wheel zoom, status slider/buttons. | Frozen/split panes, selected range, narrow/wide viewport, multiple zoom levels. | Pane geometry, active pane scrolling, zoom value/status, Arrange All partial state all behave as documented. | In Progress |
| UI-CAT-HELP-001 | Help/about/feedback/legal | Help, Send Feedback, About, Legal Notices. | Mouse/keytips, UIA invoke, guarded external process check. | Online allowed/blocked environment, modal About dialog, offline legal notice dialog. | External launches are guarded and documented; About and Legal Notices dialog focus/accessibility and close paths work. | In Progress |
| UI-CAT-CONTEXT-001 | Worksheet context menu | 50 worksheet context-menu planner commands. | Right-click, Shift+F10, Menu key, initial menu-item focus, access keys, UIA menu items. | Cell/range/row/column/table/filter/comment/hyperlink/protected targets. | Menu opens at active target, focus lands on the first enabled command, comment/note/hyperlink enabled state is model-backed, every item routes to expected command. | In Progress |
| UI-CAT-CONTEXT-002 | Sheet tab/contextual menus | Add, rename, duplicate, delete, move, color, hide/unhide, select all, ungroup, overflow arrows. | Mouse click/double-click/drag/right-click, F6 focus, tab-strip arrow keys, Shift+F10/Menu key, keyboard access keys. | First/middle/last sheet, hidden sheet, grouped sheets, colored tab. | Tab state/order/name/color/visibility mutates, grouping commands target correct sheets. | In Progress |
| UI-CAT-CONTEXT-003 | Contextual object tabs/menus | PivotTable Analyze/Design, PivotChart field buttons, chart/object/table/sparkline surfaces. | Mouse, keytips, field-button dropdowns, object context menus. | Active pivot/chart/table/sparkline/drawing object, selected chart subpart. | Correct contextual tab appears/disappears, commands route to active object, disabled states match target. | Not Started |
| UI-CAT-DIALOG-001 | Dialog behavior contract | All modal/modeless FreeX dialogs. | Tab/Shift+Tab, access keys, Enter default, Escape cancel, mouse OK/Cancel/Apply, UIA patterns. | Default, changed, invalid, canceled, high-DPI/narrow-window cases. | Focus order, automation names/ids, validation, result/cancel semantics, focus return, screenshot evidence. | In Progress |

## Expanded Child Rows

Use these child rows when a broad `UI-CAT-*` row is too large for a single pass. Add result/evidence notes to the parent row and the child row.

| Child ID | Parent | Surface | Required test focus | Status |
|---|---|---|---|---|
| UI-CAT-FILE-001A | UI-CAT-FILE-001 | Open/Save As native dialogs | Guarded OpenFileDialog/SaveFileDialog focus, cancel, invalid path, recent list update, workbook title/path state. | In Progress - Backstage source coverage proves native Open/Save As dialogs use the format registry, require existing open targets, force single-file open, append `.xlsx` by default, prompt before overwrite, and route accepted paths through the workbook open/save pipelines. |
| UI-CAT-FILE-001B | UI-CAT-FILE-001 | Recent/Pinned backstage items | Open recent, pin/unpin, remove/missing file handling, context-menu access keys, UIA names. Planner coverage now proves recent/pinned paths are sorted newest-first, missing paths are filtered before the Backstage Recent and Pinned sections are split, and XAML/source tests prove visible pin/unpin affordances, context-menu keytips, and stable UIA names/help text for open, pin/unpin, and remove commands. | In Progress |
| UI-CAT-FILE-001C | UI-CAT-FILE-001 | Open progress/unsupported warnings | Loading overlay, unsupported-feature message, focus recovery after dismiss, file state after failure. Source/XAML coverage now proves open progress uses the shared overlay binder, exposes accessible progress text, always hides the overlay and clears `_isOpeningFile` in `finally`, and routes open failures plus unsupported-feature open/save warnings through owned message boxes. | In Progress |
| UI-CAT-FILE-002A | UI-CAT-FILE-002 | Print Preview | Toolbar buttons with Print as the default keyboard focus target, page navigation, zoom, close, keyboard traversal, output scope, and unique access keys within the print-range group. | In Progress |
| UI-CAT-FILE-002B | UI-CAT-FILE-002 | Export Options dialog | Active sheet/selection/workbook scope, page range validation, standard/minimum quality, open-after-publish, access keys. | In Progress - Export planner/source coverage proves the scope choices, selection disabled state, page-range validation route, standard/minimum quality options, open-after-publish, and access keys. |
| UI-CAT-FILE-002C | UI-CAT-FILE-002 | PDF/XPS publish save dialog | Extensionless `.pdf`, explicit `.xps`, existing file overwrite/cancel, metadata/output inspection. Source coverage now proves the export save dialog declares PDF/XPS filters, `.pdf` default extension, add-extension and overwrite prompts, FilterIndex-based explicit XPS routing, planner normalization for extensionless/mismatched paths, owned validation/success/error messages, and PDF/XPS document property emission hooks. | In Progress |
| UI-CAT-DATA-001A | UI-CAT-DATA-001 | CSV import | Data > Get Data CSV native dialog, delimiter/encoding assumptions, cancel/error paths, resulting sheet data. Source coverage now proves Get Data uses only delimited text adapters, declares native open-dialog guardrails for existing single-file import, treats cancel as no-op, routes unsupported/empty/failed/completed diagnostics, imports through `ImportSheetCommand`, recalculates affected cells, restores focus/viewport/status, and reports adapter/import failures through owned messages. | In Progress |
| UI-CAT-INSERT-003A | UI-CAT-INSERT-003 | Picture import | Insert Picture native dialog, supported/unsupported image files, placement, selection, persistence. Source coverage now proves the native image picker is single-file and existing-file guarded, cancel is a no-op, read failures use an owned warning, accepted images flow through `InsertPictureCommand` with extension-derived content type, and focus/viewport return to the insertion anchor. | In Progress |
| UI-CAT-PAGE-001A | UI-CAT-PAGE-001 | Sheet background import | Page Layout background dialog, tiling display, replacement/clear path, persistence expectations. Source coverage now proves the native image dialog title/filter, existing single-file guardrails, cancel no-op, unsupported file warning, owned read-failure warning, worksheet background command routing, replacement semantics, clear command routing, undo restoration, and cloned worksheet background metadata. | In Progress |
| UI-CAT-CONTEXT-001A | UI-CAT-CONTEXT-001 | Worksheet context entry paths | Right-click, Shift+F10, Menu key, Escape, access-key traversal, foreground guard. | In Progress |
| UI-CAT-CONTEXT-001B | UI-CAT-CONTEXT-001 | Worksheet context targets | Cell, range, row, column, table, filter, comment/note, hyperlink, protected cell enabled/disabled matrix. | In Progress - Planner coverage proves worksheet, whole-row, and whole-column targets expose the expected Hide/Unhide, Row Height, Column Width, and AutoFit command families with target-specific access headers and enabled metadata. |
| UI-CAT-CONTEXT-001C | UI-CAT-CONTEXT-001 | Worksheet context command mutation | Clipboard, insert/delete, clear, sort/filter, note/comment, hyperlink, Format Cells, row/column size. | In Progress - Insert/delete planner and source-route coverage proves worksheet context menu insert/delete items dispatch to the existing cell/row/column mutation commands. |
| UI-CAT-CONTEXT-002A | UI-CAT-CONTEXT-002 | Sheet-tab pointer actions | Click select, double-click rename, drag reorder, overflow arrows, right-click menu. | Not Started |
| UI-CAT-CONTEXT-002B | UI-CAT-CONTEXT-002 | Sheet-tab commands | Add, rename, duplicate, delete, move, tab color, hide/unhide, select all, ungroup, active-tab F6 focus, tab-strip Left/Right/Home/End navigation, and Shift+F10/Menu-key context entry. | In Progress |
| UI-CAT-CONTEXT-003A | UI-CAT-CONTEXT-003 | Pivot contextual tabs | PivotTable Analyze/Design visibility, `JA`/`JD` keytips, active pivot target changes. | Not Started |
| UI-CAT-CONTEXT-003B | UI-CAT-CONTEXT-003 | Pivot Field List | Show/close, search, action buttons, defer/update, drag/drop row/column/value/filter areas. | Not Started |
| UI-CAT-CONTEXT-003C | UI-CAT-CONTEXT-003 | Pivot field menus | Field context menus, checked-item filter, label filter, value filter, grouping, calculated field/item. | Not Started |
| UI-CAT-INSERT-001A | UI-CAT-INSERT-001 | Pivot create/source dialogs | Source range picker with source-range default focus/select-all, new/current worksheet placement, invalid source, OK/Cancel/Escape. | In Progress |
| UI-CAT-INSERT-001B | UI-CAT-INSERT-001 | Pivot options/settings dialogs | PivotTable Options with report-layout default focus, PivotChart Options, Value Field Settings tabs, number format, empty-cell text. | In Progress |
| UI-CAT-INSERT-001C | UI-CAT-INSERT-001 | Slicer/timeline | Insert slicer/timeline dialogs with field selector default focus, connection to pivot, select/clear items, contextual disabled states. | In Progress |
| UI-CAT-INSERT-001D | UI-CAT-INSERT-001 | Table creation and Format as Table | Ctrl+T/Create Table dialog with initial focus on the range box, header checkbox, gallery sections/swatches, totals row materialization. | In Progress |
| UI-CAT-DATA-001B | UI-CAT-DATA-001 | Table/AutoFilter dropdown | Header dropdown, Alt+Down initial focus on first sort command, search/select all, blank item, number/text/date filters, clear/reapply behavior. | In Progress |
| UI-CAT-INSERT-002A | UI-CAT-INSERT-002 | Insert/change chart | Chart family menus, supported/deferred/excluded families, render and selected chart target. | Not Started |
| UI-CAT-INSERT-002B | UI-CAT-INSERT-002 | Chart data/layout dialogs | Select Data, Move Chart, labels, trendlines, error bars, axis and series formatting. | Not Started |
| UI-CAT-INSERT-002C | UI-CAT-INSERT-002 | Chart contextual behavior | Chart area/plot/series/axis/title/legend selection, context commands, persistence. | Not Started |
| UI-CAT-DRAW-001A | UI-CAT-DRAW-001 | Object selection and disabled states | No-object messages, selected picture/shape/text box/chart object enabled-state matrix. Source coverage now proves picture/object/shape/selection-pane no-target messages are shown through the owned host-message path. | In Progress |
| UI-CAT-DRAW-001B | UI-CAT-DRAW-001 | Object geometry/appearance | Size dialogs with height-box default focus/select-all, rotate, crop/reset crop, fill, outline, gradient with first RGB stop focus/select-all, effects, z-order. | In Progress |
| UI-CAT-DRAW-001C | UI-CAT-DRAW-001 | Selection Pane | Search/filter, visibility checkboxes, rename, show all/hide all, bring/send reorder. Source coverage now proves top-level and row-template Selection Pane controls expose automation names/help text for search, filter, object list, row visibility, inline rename, bulk visibility, reorder, OK, and Cancel. | In Progress |
| UI-CAT-DIALOG-001A | UI-CAT-DIALOG-001 | Data dialogs | Sort and Sort Options with default focus targets, Advanced Filter, Text to Columns, Remove Duplicates, Data Validation, Consolidate, and Data > What-If Analysis keytip routing with `Alt,A,W` exposing Goal Seek `G`, Scenario Manager `S`, and Data Table `D`. Full dialog workflow evidence for Goal Seek, Scenario Manager, and Data Table remains in progress. | In Progress |
| UI-CAT-DIALOG-001B | UI-CAT-DIALOG-001 | Formatting/page dialogs | Format Cells with active-tab first-control default focus, including Border-tab focus on the visible line-style selector rather than the hidden helper combo box, colors, Conditional Formatting manager/rules with manager focus landing on the scope selector and threshold dialogs focusing the threshold input, Theme, Page Setup, Header/Footer. | In Progress |
| UI-CAT-DIALOG-001C | UI-CAT-DIALOG-001 | Formula/review dialogs | Insert Function, Name Manager, Create from Selection, Error Checking, Evaluate Formula, Watch Window, Spell Check, Accessibility, Protection. | In Progress |
| UI-CAT-RIBBON-001A | UI-CAT-SHELL-002 | Top-level tab render/select | Home, Insert, Draw, Page Layout, Formulas, Data, Review, View, Help render after mouse click, Alt keytip, and UIA SelectionItem. | In Progress |
| UI-CAT-RIBBON-001B | UI-CAT-SHELL-002 | File/backstage tab keytip | File tab opens via mouse and `Alt+F`, shows Back/Home/Info/New/Open/Save/Save As/Print/Export/Share/Account/Options/Close keytips. | In Progress |
| UI-CAT-RIBBON-001C | UI-CAT-SHELL-002 | Contextual ribbon visibility | PivotTable Analyze and Design tabs are hidden without pivot selection, visible after pivot selection, and expose `JA`/`JD` keytips. Automated planner/source coverage now requires contextual tabs and Field List to use strict PivotTable selection instead of workbook fallback; live screenshot evidence remains. | In Progress |
| UI-CAT-RIBBON-002A | UI-CAT-SHELL-002 | Collapsed group overflow | Narrow-window collapsed Home Editing, Insert Charts, and View Window groups open menus with live checked/enabled state and input gesture text. | In Progress |
| UI-CAT-RIBBON-002B | UI-CAT-SHELL-002 | Overflow command routing | Collapsed group child commands invoke the same command route as their expanded ribbon controls and direct overflow commands return focus to the visible collapsed group button. Automated coverage now verifies cloned nested menu clicks route only to the matching source item without invoking parent menu commands. | In Progress |
| UI-CAT-RIBBON-003A | UI-CAT-SHELL-002 | Inventory reconciliation | Draw tab inventory treats Bring Forward and Send Backward as separate menu rows while command-surface inventory may count one arrangement command family. Source coverage now proves Draw and Page Layout Arrange groups expose Bring Forward and Send Backward as distinct rows with separate handlers/keytips while command-surface parity records the combined implemented family. | In Progress |
| UI-CAT-QAT-001A | UI-CAT-SHELL-001 | QAT Save | Save button/keytip `1` on unsaved workbook routes to Save As; on saved workbook writes without unexpected dialog and updates dirty state. Source coverage now proves the QAT Save keytip/button route through shared Save/Save As planning, saved-path writes, dirty-state reset, and title update paths. | In Progress |
| UI-CAT-QAT-001B | UI-CAT-SHELL-001 | QAT Undo | Undo button/keytip `2` is disabled for a fresh workbook, enabled after an undoable keyboard-routed edit, mutates the active cell style through the command stack, exits keytip mode, and hands enabled state to Redo. Selection/status screenshot evidence remains. | In Progress |
| UI-CAT-QAT-001C | UI-CAT-SHELL-001 | QAT Redo | Redo button/keytip `3` is disabled until Undo succeeds, reapplies the active cell style mutation through the command stack, exits keytip mode, and restores Undo-enabled/Redo-disabled state. Selection/status screenshot evidence remains. | In Progress |
| UI-CAT-SHEETTAB-001A | UI-CAT-CONTEXT-002 | Sheet-tab selection/grouping | Tab click selects, Ctrl/Shift click groups, grouped styling appears, Ungroup restores single-sheet targeting. | Not Started |
| UI-CAT-SHEETTAB-001B | UI-CAT-CONTEXT-002 | Sheet-tab reorder/navigation | Drag reorder, Move Left, Move Right, scroll left/right arrows, first/middle/last sheet edge behavior. | Not Started |
| UI-CAT-SHEETTAB-001C | UI-CAT-CONTEXT-002 | Sheet-tab creation/rename/delete | Add button, double-click rename, context Rename/Duplicate/Delete, protected/last-sheet disabled states. | In Progress |
| UI-CAT-SHEETTAB-001D | UI-CAT-CONTEXT-002 | Sheet-tab visibility/color | Tab Color, Hide, Unhide dialog, Select All Sheets, color persistence, hidden-sheet edge cases. | Not Started |
| UI-CAT-STATUS-001A | UI-CAT-VIEW-002 | Status mode text | Ready/input/editing status text updates during selection, entry, formula edit, modal dialog return. Existing calculator/layout coverage proves Ready, validation input prompt, and inline edit mode rendering while hiding aggregate stats. Modal dialog return and formula-edit transitions remain. | In Progress |
| UI-CAT-STATUS-001B | UI-CAT-VIEW-002 | Selection statistics | Average, Count, Sum, Min, Max update for numeric, text, mixed, blank, filtered, and multi-cell selections. | In Progress - Status calculator and host source coverage now separate Count from Numerical Count for mixed/text/blank selections. |
| UI-CAT-STATUS-001C | UI-CAT-VIEW-002 | Zoom buttons/text | Zoom out/in buttons and 100% text update model, status text, and rendered grid scale with min/max clamping. | In Progress |
| UI-CAT-STATUS-001D | UI-CAT-VIEW-002 | Zoom slider/wheel | Slider drag, UIA range value, Ctrl+wheel zoom, and keyboard focus leave no stale status text. Existing source/UIA/layout coverage proves the Zoom slider exposes range metadata/patterns, F6 starts at Zoom Out, Tab stays within the zoom controls through slider/Zoom In/percentage, and zoom controls share a stable visual center; live slider drag and Ctrl+wheel remain. | In Progress |

## Command-Level Coverage Backlog

This backlog is the next layer below `Catalog Row Index`: each row should eventually become one or more executed records using the `Per-Command Record Template`. Keep these rows compact, but do not remove a command from the backlog until it has passed or has an explicit Excluded/Deferred rationale.

### Backstage, QAT, Shell, Status

| Backlog ID | Parent | Commands / surface | Required targets and proof | Status |
|---|---|---|---|---|
| UI-CMD-FILE-001 | UI-CAT-FILE-001 | New, Open, Save, Save As, Close | Unsaved/saved workbook, dirty prompt behavior, shortcut/keytip/mouse/UIA, focus return. Source coverage now proves New and Close route through the shared dirty-save prompt, Save reuses an existing supported path before falling back to Save As, Save As always opens the save dialog, save failures use owned messages, and New/Save/Save As/Close shortcuts are registered. | In Progress |
| UI-CMD-FILE-002 | UI-CAT-FILE-001 | Info panel and unsupported-feature warnings | Clean workbook, workbook with formulas/accessibility issues, unsupported XLSX warnings, properties/stat summaries. Planner and XAML coverage now prove workbook statistics, accessibility/formula-error summaries, saved/unsaved file state, and visible unsupported-feature warning copy on the Info page. | In Progress |
| UI-CMD-FILE-003 | UI-CAT-FILE-001 | Recent Files and pinned items | Open existing recent, missing file, pin/unpin, remove, keyboard access and UIA names. Planner coverage now proves Recent and Pinned lists sort newest-first after filtering, missing paths are omitted from both sections, and source tests cover visible pin/unpin buttons, context-menu access keytips, and stable UIA names/help text for recent/pinned file actions. | In Progress |
| UI-CMD-FILE-004 | UI-CAT-FILE-001 | Share | Unsaved file routes through Save As, saved local file opens Windows Share, cloud exclusions are visibly scoped. Source coverage now proves the shared Share workflow plans unsaved/missing files through Save As, saves existing files before invoking Windows Share, and uses the shared share service. | In Progress |
| UI-CMD-FILE-005 | UI-CAT-FILE-001 | Options and Account | Mouse/keytip/UIA invoke, Options category-list default focus, category navigation, OK/Cancel/Escape, focus return, excluded account messaging. Options source coverage now proves the category list and OK/Cancel actions expose stable automation names/IDs/help text while retaining category-list default focus and input-refocus guardrails. | In Progress |
| UI-CMD-FILE-006 | UI-CAT-FILE-002 | Print Preview and native Print | Ctrl+P, File > Print, preview toolbar, native print dialog guard, page settings summary. | In Progress - Backstage Print source/XAML coverage now proves Ctrl+P routes through the File backstage Print entry, the entry exposes stable UIA metadata, and the Print workflow opens Print Preview with settings summary plus the native Print command path. |
| UI-CMD-FILE-007 | UI-CAT-FILE-002 | Export to PDF/XPS | Scope with active-sheet default focus, page range, quality, extension inference, metadata, overwrite/cancel, open-after-publish. | In Progress |
| UI-CMD-QAT-001 | UI-CAT-SHELL-001 | Save, Undo, Redo | Enabled/disabled states, keytips `1/2/3`, dirty stack, saved file and grid mutation proof. Source and STA coverage now prove QAT Save/Undo/Redo keytips, disabled-state guarded keytip invocation, shared Save/Save As routing, saved-file dirty/title updates, and command-stack Undo/Redo grid mutation flow. Screenshot/live native-dialog evidence remains. | In Progress |
| UI-CMD-SHELL-001 | UI-CAT-SHELL-001 | Window chrome and title bar | Minimize/maximize/restore/close, Alt+Space, drag window, title dirty/saved path update. Formatter/source coverage now proves custom chrome button routing, dirty/grouped title markers, and Save/Save As title renaming from the saved file path. Alt+Space, drag-window, and live mouse evidence remain. | In Progress |
| UI-CMD-STATUS-001 | UI-CAT-VIEW-002 | Ready/edit/input status | Mode text changes during selection, edit, formula edit, dialogs, and errors. Existing status calculator/layout tests cover Ready, validation input prompts, and inline Edit mode; formula-edit, dialog return, and error status transitions remain. | In Progress |
| UI-CMD-STATUS-002 | UI-CAT-VIEW-002 | Selection stats | Average, Count, Numerical Count, Min, Max, Sum for numeric/text/mixed/filtered selections. | In Progress - `StatusBarCalculatorTests` cover text/mixed/blank Count vs Numerical Count, and `MainWindowSourceHygieneTests.StatusBarSelectionStatistics_SurfaceSeparatesCountAndNumericalCount` guards the rendered status labels. |
| UI-CMD-STATUS-003 | UI-CAT-VIEW-002 | Zoom out/in/slider/text | Button, slider, Ctrl+wheel, Ctrl+Alt+=/-, min/max clamp, status and grid scale proof. | In Progress |

### Home Tab

| Backlog ID | Parent | Commands / surface | Required targets and proof | Status |
|---|---|---|---|---|
| UI-CMD-HOME-CLIP-001 | UI-CAT-HOME-001 | Cut, Copy, Paste | Values, formulas, formats, notes/comments, validation, overlapping cut/paste, external text. | In Progress |
| UI-CMD-HOME-CLIP-002 | UI-CAT-HOME-001 | Paste dropdown and Paste Special | All supported paste modes, arithmetic options, skip blanks, transpose, paste link, pictures, access keys. Dialog/planner/source coverage now proves Excel-style Paste Special choices, operation radio buttons, skip blanks, transpose, keep source column widths, paste link, picture/linked-picture, external text routes, default focus on All, OK/Cancel access keys, Home paste dropdown keytips, Ctrl+Alt+V recognition, and command routing through the shared Paste Special planner. Core command coverage proves transpose, arithmetic operations, skip blanks, content-kind variants, column widths, picture insertion, undo, and invalid-operation rejection. | In Progress |
| UI-CMD-HOME-CLIP-003 | UI-CAT-HOME-001 | Format Painter | Single-use and persistent double-click painter modes are implemented; Escape cancels through the shared transient-mode path; style-only mutation and undo behavior have command coverage. Remaining work is live UI screenshot evidence for pointer cursor/selection visuals. | In Progress |
| UI-CMD-HOME-FONT-001 | UI-CAT-HOME-002 | Font family/size/grow/shrink | Font family and font size dropdowns now support typed Enter and Tab-away keyboard commits through the same style application paths used by selection changes, including positive-size parsing for typed sizes; deterministic Home font-family dropdown proof now verifies the selected cell model style and grid typeface update. Broader mouse dropdown traversal, save/reload, and grow/shrink evidence remain to be closed out. | In Progress |
| UI-CMD-HOME-FONT-002 | UI-CAT-HOME-002 | Bold, Italic, Underline, Double Underline, Strikethrough | Ribbon, shortcuts, mixed selection, undo/redo, saved reload. | In Progress |
| UI-CMD-HOME-FONT-003 | UI-CAT-HOME-002 | Font Color, Fill Color, Theme Colors | Standard/custom color picker, theme slots, cancel/apply, render and persistence. Source coverage now proves Home Font Color/Fill Color expose stable automation names/IDs/help text and route through the shared color picker/style-diff path, including fill clear via No Color. | In Progress |
| UI-CMD-HOME-FONT-004 | UI-CAT-HOME-002 | Borders gallery | Outline/no border, full preset gallery, remembered line color/style, edge-specific render. | Not Started |
| UI-CMD-HOME-ALIGN-001 | UI-CAT-HOME-002 | Horizontal/vertical align, indent, rotation | Blank/value/formula/range targets, Format Cells parity, render and persistence. | Not Started |
| UI-CMD-HOME-ALIGN-002 | UI-CAT-HOME-002 | Wrap Text, Merge & Center, Distributed/Justify, Shrink to Fit | Single/range/table/protected targets, disabled states, undo/repeat, save/load. | In Progress |
| UI-CMD-HOME-NUM-001 | UI-CAT-HOME-002 | Number format dropdown and common styles | General, Number, Currency, Accounting, Date, Time, Percent, Fraction, Scientific, Text; Home keytip `Alt,H,N` opens the number-format dropdown and explicitly focuses the combo box for continued keyboard navigation. | In Progress |
| UI-CMD-HOME-NUM-002 | UI-CAT-HOME-002 | Custom/locale number formats | LCID catalog, color sections, elapsed time, date/time tokens, accounting partials, save/load. | Not Started |
| UI-CMD-HOME-NUM-003 | UI-CAT-HOME-002 | Increase/Decrease Decimal, Comma, Currency, Percent | Deterministic command-source proof now guards the Accounting, Percent, Comma, Increase Decimal, and Decrease Decimal button handlers/keytips, exact number-format diffs, decimal adjuster routing, and repeatable shared style application path. Remaining work is live value/formula/date/error cell execution, visual rounding, stored value proof, and save/load evidence. | In Progress |
| UI-CMD-HOME-STYLE-001 | UI-CAT-HOME-003 | Conditional Formatting menus | Highlight rules, top/bottom, data bars, color scales, icon sets, More Rules, rule dialogs with first-editor default focus/select-all, manager with scope-selector default focus. | In Progress |
| UI-CMD-HOME-STYLE-002 | UI-CAT-HOME-003 | Format as Table and table styles | Gallery swatches, create table dialog, header/totals, undo, filter behavior, persistence. | In Progress |
| UI-CMD-HOME-STYLE-003 | UI-CAT-HOME-003 | Cell Styles | Deterministic command-source proof now guards the Cell Styles ribbon button/keytip, every enum-backed menu route from Normal through 20% Accent 6, status/text preset diff semantics, theme-aware preset diff routing, and repeatable shared style application path. Remaining work is live gallery interaction, rendered grid proof, undo/repeat, and save/load evidence. | In Progress |
| UI-CMD-HOME-CELLS-001 | UI-CAT-HOME-004 | Insert cells/rows/columns/sheets | Ribbon, shortcut, context menu, modal shift choices with default keyboard focus, row/column/table targets. | In Progress |
| UI-CMD-HOME-CELLS-002 | UI-CAT-HOME-004 | Delete cells/rows/columns/sheets | Ribbon, shortcut, context menu, modal shift choices with default keyboard focus, notes/comments preserved or removed correctly, undo. | In Progress |
| UI-CMD-HOME-CELLS-003 | UI-CAT-HOME-004 | Row Height, Column Width, AutoFit | Home > Format keytip path `Alt,H,O` exposes Row Height, AutoFit Row Height, Column Width, and AutoFit Column Width leaf keytips; Row Height/Column Width dialogs open with keyboard-focused selected input, seed from the first selected row/column override or sheet default, validate positive finite input, apply repeatable grouped-sheet commands against the current selection for F4, and refocus invalid input after owned warnings. Double-click headers, hidden/protected targets, and render measurement remain. | In Progress |
| UI-CMD-HOME-CELLS-004 | UI-CAT-HOME-004 | Hide/Unhide rows, columns, sheets | Ribbon/shortcut/context/sheet-tab paths, grouped sheets, protected-state disabled behavior; sheet-tab keyboard context menus now open with initial focus on the first enabled item. | In Progress |
| UI-CMD-HOME-EDIT-001 | UI-CAT-HOME-004 | AutoSum and Fill Down/Right/Up/Left/Series | Formula adjustment, selected range variants, Series dialog direction default focus, F4 repeat, undo/redo. | In Progress |
| UI-CMD-HOME-EDIT-002 | UI-CAT-HOME-004 | Flash Fill | Contact-name/email inference variants, partial limitations, undo/repeat, blocked ambiguous cases. | Not Started |
| UI-CMD-HOME-EDIT-003 | UI-CAT-HOME-004 | Clear All/Formats/Contents/Comments/Hyperlinks | Notes/threaded comments, hyperlinks, formats, tables, undo and context-menu parity. Source coverage now proves Home Clear menu keytips for All/Formats/Contents/Comments/Hyperlinks, Clear All routing through a repeatable grouped composite that clears contents, formats, comments, and hyperlinks, recalculation after affected cells, and dedicated Clear Comments/Clear Hyperlinks command routing. | In Progress |
| UI-CMD-HOME-EDIT-004 | UI-CAT-HOME-004 | Sort, Filter, Find, Replace, Go To, Go To Special | Dialog options, access keys, Find/Replace search-box default focus/select-all, filtered data, hidden rows, selection targets. | In Progress |

### Insert, Draw, Contextual Objects

| Backlog ID | Parent | Commands / surface | Required targets and proof | Status |
|---|---|---|---|---|
| UI-CMD-INSERT-001 | UI-CAT-INSERT-001 | PivotTable create | Source picker with source-range default focus/select-all, placement, invalid source, new/current worksheet, undo, contextual tabs. | In Progress |
| UI-CMD-INSERT-002 | UI-CAT-INSERT-001 | Pivot Field List and settings | Search, drag areas, action buttons, defer/update, Value Field Settings tabs, number formats. | Not Started |
| UI-CMD-INSERT-003 | UI-CAT-INSERT-001 | Pivot filters/grouping/options | Checked-item filters with search-box default focus, label/value filters with operator default focus, Value Field Settings with custom-name default focus/select-all, grouping dialog with field selector default focus, calculated field/item with name-box default focus/select-all, PivotTable Options, empty display. | In Progress |
| UI-CMD-INSERT-004 | UI-CAT-INSERT-001 | Table creation | Ctrl+T, Insert > Table, Format as Table shared flow, range-box default focus, header checkbox, totals, AutoFilter. | In Progress |
| UI-CMD-INSERT-005 | UI-CAT-INSERT-002 | Charts | Embedded/chart sheet, supported families, collapsed Insert > Charts keytip overflow routing (`Alt,N,CH`) with Recommended Charts and Column Chart child keytips, Insert Chart recommended-gallery default focus, Change Chart Type subtype-gallery default focus, Chart Titles title-box default focus, Chart Styles gallery default focus, Move Chart target-choice default focus, Select Data range-box default focus, Chart Area fill-box default focus/select-all, Data Labels show-choice default focus, Series selector default focus, Trendline show-choice default focus, Error Bars show-choice default focus, Axis minimum-box default focus/select-all, axes, series, trendlines, error bars. | In Progress |
| UI-CMD-INSERT-006 | UI-CAT-INSERT-002 | Deferred/excluded chart families | Surface/treemap/sunburst/histogram/waterfall/funnel/map/3D disabled or blocked with clear rationale. | Not Started |
| UI-CMD-INSERT-007 | UI-CAT-INSERT-002 | Sparklines | Line/column/win-loss, Insert Sparkline default data-range focus/select-all, group selection, hidden row/column interactions, persistence. Host source coverage now proves invalid dialog result fallbacks use owned warnings, the initial insert honors the dialog location before repeat routing falls back to the current selection, and sparkline value planning skips manual, filter, and outline hidden rows plus hidden/group-hidden columns. | In Progress |
| UI-CMD-INSERT-008 | UI-CAT-INSERT-003 | Picture, shapes, text box | File import, Insert > Shapes keytip menu routing (`Alt,N,SH`) with Rectangle/Ellipse/Line child keytips and real rectangle insertion at the selected cell, text editing, selection handles, save/load. | In Progress |
| UI-CMD-INSERT-009 | UI-CAT-INSERT-003 | Header & Footer, Symbol, Hyperlink | Dialog access keys, token buttons, Ctrl+K, cancel/apply, persistence. Symbol picker source coverage now proves access keys, symbol/special-character tabs, initial grid focus, UIA names/help text for font, subset, code, preview, symbol grid/list/items, and Insert/Cancel/Go actions, Unicode character-code parsing/rejection, recent-symbol promotion, double-click/Insert acceptance, cancel, and host insertion of the selected symbol string into the active cell. Hyperlink source coverage proves Ctrl+K dialog routing, Ctrl+click navigation planning, workbook-reference navigation, and owned warning messages for missing workbook targets or failed external launches. | In Progress |
| UI-CMD-INSERT-010 | UI-CAT-INSERT-003 | Comment/Note | Insert tab comment/note paths, Review parity, threaded-comment limitation, navigation. | In Progress |
| UI-CMD-DRAW-001 | UI-CAT-DRAW-001 | Rectangle, Ellipse, Line | Insert, select, move, resize where supported, z-order, save/load. | Not Started |
| UI-CMD-DRAW-002 | UI-CAT-DRAW-001 | Bring Forward, Send Backward | Multiple objects, Selection Pane order, grid overlap visual proof, undo. | Not Started |
| UI-CMD-DRAW-003 | UI-CAT-DRAW-001 | Object size/rotation, fill, outline, alt text | Shape/picture/text box targets, dialogs, render and persistence. Source coverage now proves size, rotation, fill/outline, gradient/effects, crop/reset-crop, and selection-pane empty-target paths use owned no-target messages. | In Progress |
| UI-CMD-DRAW-004 | UI-CAT-DRAW-001 | Crop, gradients, effects | Picture crop/reset, shape gradient/shadow, no-object disabled state, persistence. Source coverage now proves Crop/Reset Crop, Shape Gradient, and Shape Effects expose stable automation names/IDs/help text and continue routing through owned no-target warnings and existing crop/gradient/effect commands. | In Progress |
| UI-CMD-DRAW-005 | UI-CAT-DRAW-001 | Selection Pane | Search/filter with search-box default focus, rename, visibility, show all/hide all, reorder buttons, keyboard traversal. Source coverage now proves top-level command buttons and row-template controls expose automation names/help text alongside existing keyboard, bulk visibility, inline rename, and drag/drop reorder guardrails. | In Progress |
| UI-CMD-CTXOBJ-001 | UI-CAT-CONTEXT-003 | Pivot/PivotChart field buttons and menus | Field button visibility, dropdowns, checked/filter state, active chart/pivot targets. | Not Started |
| UI-CMD-CTXOBJ-002 | UI-CAT-CONTEXT-003 | Chart/object/table/sparkline contextual states | Correct contextual commands appear, target-specific disabled states, focus return. | Not Started |

### Page Layout, Formulas, Data

| Backlog ID | Parent | Commands / surface | Required targets and proof | Status |
|---|---|---|---|---|
| UI-CMD-PAGE-001 | UI-CAT-PAGE-001 | Margins, Orientation, Size, Print Area, Breaks | Page Setup menu keytip coverage proves `Alt,P,M,W`, `Alt,P,OR,L`, `Alt,P,SZ,G`, and `Alt,P,PA,S/C` mutate margins, orientation, paper size, and print area; Breaks menu keytip coverage proves `Alt,P,BK,I/R/A` inserts, removes, and resets selected-cell row/column page breaks from the model. Remaining work includes the rest of the menu matrix, page views, print preview/export output, save/load, and invalid ranges. | In Progress |
| UI-CMD-PAGE-002 | UI-CAT-PAGE-001 | Background, Print Titles, Scale to Fit | Print Titles opens Page Setup directly on the Sheet tab with keyboard focus/select-all on Rows to repeat at top; Scale to Fit opens Page Setup on the Page tab with keyboard focus/select-all on the active scaling input. Remaining work includes native image dialog guard, broader range picker execution, page-layout render, and persistence expectations. | In Progress |
| UI-CMD-PAGE-003 | UI-CAT-PAGE-001 | Gridlines/Headings print/show, Center on page, Page Order | Live ribbon keytip coverage proves Page Layout `Alt,P,PG` toggles Print Gridlines and `Alt,P,PH` toggles Print Headings through the real dispatcher; View tab `Alt,W,VG/VH` coverage proves worksheet display toggles. Center on Page and Page Order dialog choices flow through the command builder into the worksheet model. Remaining work is broader page setup dialog variants and preview/export proof. | In Progress |
| UI-CMD-PAGE-004 | UI-CAT-PAGE-001 | Themes, Colors, Fonts, Effects | Preset menus, custom theme dialog, access keys, theme-dependent style render. Theme buttons and preset/customize menu items now expose stable UIA names, automation IDs, help text, and source coverage across Themes, Colors, Fonts, and Effects. | In Progress |
| UI-CMD-PAGE-005 | UI-CAT-PAGE-001 | Header/Footer and Page Setup dialog | Presets, Page Setup orientation-box default focus, section fields with center-header default focus/select-all, picture format size dialog with width focus/select-all, token buttons, tabs, OK/Cancel/Escape, output proof. | In Progress |
| UI-CMD-FORM-001 | UI-CAT-FORMULAS-001 | Insert Function and function category menus | Search-box default focus/select-all, category/list/help/OK/cancel, formula insertion, shortcut Shift+F3. | In Progress |
| UI-CMD-FORM-002 | UI-CAT-FORMULAS-001 | Names | Name Manager with names-list/New-button default focus, Define Name name-box default focus/select-all, Use in Formula, Create from Selection with default focus on Top row, invalid ranges, save/load. | In Progress |
| UI-CMD-FORM-003 | UI-CAT-FORMULAS-002 | Formula auditing | Trace precedents/dependents, remove arrows, direct/all refs across sheets, visual arrows. | Not Started |
| UI-CMD-FORM-004 | UI-CAT-FORMULAS-002 | Show Formulas and calculation | Formula menu keytip coverage proves `Alt,M,U,A` inserts an AVERAGE formula from adjacent numeric cells and `Alt,M,O,M/A` toggles Manual/Automatic calculation modes. Remaining work includes Ctrl+`, R1C1, Calculate Now, Calculate Sheet, formula/value render, and broader AutoSum variants. | In Progress |
| UI-CMD-FORM-005 | UI-CAT-FORMULAS-002 | Error Checking with issue-list default focus, Evaluate Formula with Evaluate-button default focus, Watch Window | Issue taxonomy, step controls, add/delete/refresh watch, modeless focus. | In Progress |
| UI-CMD-DATA-001 | UI-CAT-DATA-001 | Get Data CSV and Refresh All | Native file dialog guard, invalid/cancel, imported data, recalculation proof. | In Progress - source coverage proves Get Data limits native import to delimited text adapters, builds the native open-file filter, treats cancel as a no-op, records unsupported/empty/failed/completed import diagnostics, imports through `ImportSheetCommand`, recalculates affected imported cells, returns focus/visibility to the destination, and routes Refresh All to Calculate Now; core/IO tests cover CSV adapter behavior and import-command undo/protection. |
| UI-CMD-DATA-002 | UI-CAT-DATA-001 | Sort and Filter | Single/multi-key sort with Custom Sort focus landing on the first sort level, AutoFilter dropdown, Alt+Down, color/text/number/date filters, clear/reapply. | In Progress |
| UI-CMD-DATA-003 | UI-CAT-DATA-001 | Advanced Filter | Action/options/reference controls with initial focus on the in-place action choice, range picker, criteria/copy targets, invalid input. | In Progress |
| UI-CMD-DATA-004 | UI-CAT-DATA-002 | Text to Columns | Wizard modes with initial focus on the source type choice, delimiter/qualifier, destination picker, fixed-width, cancel/finish, undo. | In Progress |
| UI-CMD-DATA-005 | UI-CAT-DATA-002 | Remove Duplicates and Data Validation | Header choice with default focus, column selection, validation allow-type default focus, validation list/input/error tabs, dropdown behavior. Source coverage now proves Remove Duplicates header/default-focus/column-list/bulk-selection paths, invalid column-selection focus recovery, owned completion message routing, Data Validation allow-type default focus, settings/input/error tabs, validation error focus recovery, range-picker wiring, apply-to-same-settings command composition, and owned no-selection warning. | In Progress |
| UI-CMD-DATA-006 | UI-CAT-DATA-002 | Consolidate, Goal Seek, Scenario Manager, Data Table, Forecast Sheet | Dialog access keys, status dialogs, default focus including Consolidate function, passive Consolidate labels-group text with actionable Top row/Left column access keys, Goal Seek set-cell entry, Scenario Manager list/name-field, and Data Table row-input entry, results, invalid input, undo where supported. | In Progress |
| UI-CMD-DATA-007 | UI-CAT-DATA-003 | Subtotal, Group, Ungroup, Show/Hide Detail | Subtotal dialog initial focus on the group-column choice, rows/columns, nested groups, outline buttons, filtered ranges, persistence. | In Progress |

### Review, View, Help, Context Menus

| Backlog ID | Parent | Commands / surface | Required targets and proof | Status |
|---|---|---|---|---|
| UI-CMD-REVIEW-001 | UI-CAT-REVIEW-001 | Spell Check | Corrections, default suggestion-list focus with replacement fallback, replace/replace-all/ignore, skipped URLs/emails/files, casing preservation. | In Progress |
| UI-CMD-REVIEW-002 | UI-CAT-REVIEW-001 | Accessibility Checker and Statistics | Issue list, focus target action, low-contrast cell-text issues, chart alt/title issues, hidden content, comment counts. Ribbon entrypoints and dialog result/list fields now expose stable automation metadata for the checker issue list, clean result text, Go To action, and statistics summary. | In Progress |
| UI-CMD-REVIEW-003 | UI-CAT-REVIEW-002 | Notes and threaded comments | New/edit/delete/previous/next/show, Shift+F2/Ctrl+Shift+F2, persistence limits; live host keytip coverage now proves `Alt,R,N` and `Alt,R,PN` navigate across plain notes and threaded comments, and source coverage guards unique threaded-comment dialog access keys in new-comment and reply scopes. | In Progress |
| UI-CMD-REVIEW-004 | UI-CAT-REVIEW-002 | Protection and Allow Edit Ranges | Protect sheet/workbook, allowed ranges, locked/unlocked cells, disabled command matrix. Dialog/workflow coverage now proves Protect Sheet/Workbook protect and unprotect planning, sheet permission mapping/defaults, password confirmation mismatch handling, Allow Edit Ranges add/remove/clear command routing, range picker focus/selection behavior, and protected-sheet disabling of Allow Edit Ranges through the live Review keytip route. Core command coverage proves sheet/workbook protection, allowed ranges, locked/unlocked edit behavior, and permission-gated row/column/sort/filter/object commands. | In Progress |
| UI-CMD-REVIEW-005 | UI-CAT-REVIEW-002 | Share | Saved and unsaved file paths, Windows Share guard, cloud exclusions. Source coverage now proves the Review Share button delegates to the shared planner/service workflow used by Backstage Share. | In Progress |
| UI-CMD-VIEW-001 | UI-CAT-VIEW-001 | Workbook views and show toggles | Workbook view keytip coverage proves Excel's `Alt,W,L`, `Alt,W,I`, and `Alt,W,P` switch Normal/Page Break Preview/Page Layout modes. View Show keytip coverage proves Excel-style `Alt,W,VG`, `Alt,W,VH`, and `Alt,W,VF` mutate gridline/heading/formula-bar state, with `V` waiting as a shared Show prefix, and `Alt,W,RU` toggles Ruler. Remaining work includes persistence and broader render proof. | In Progress |
| UI-CMD-VIEW-002 | UI-CAT-VIEW-001 | Custom Views | Add/show/delete, list default focus, Add View name-box focus/select-all, invalid names, hidden UI state, OK/Cancel/Escape. Source coverage now proves the Custom Views list accessible name/help text, default Show action, double-click Show command routing, list default focus, no-selection/error focus recovery, owned command-failure messages, Add View name focus/select-all and blank-name warning, include-options command wiring/list indicators, and host refresh/status/focus return after applying a saved view. | In Progress |
| UI-CMD-VIEW-003 | UI-CAT-VIEW-002 | Freeze Panes and Split | View > Freeze Panes keytip coverage proves Freeze Top Row, Freeze First Column, Freeze Panes at a B2 selection, and Unfreeze All mutate active-sheet frozen rows/columns and exit menu keytip mode. View > Split keytip coverage proves `Alt,W,S` remains a prefix for `SP`/`SS`, then `Alt,W,SP` toggles split panes at a B2 selection and removes them on repeat. Drag dividers, pane scrollbars, active pane, frozen/split interactions, and visual geometry remain. | In Progress |
| UI-CMD-VIEW-004 | UI-CAT-VIEW-002 | Zoom, Zoom to Selection, 100%, Arrange All | View > Zoom preset keytips, View > 100% Zoom, View > Zoom to Selection, and View > Arrange All keytips mutate model/status state and exit keytip mode, including checked arrangement state refresh and `Z` prefix routing across Zoom commands. Zoom dialog live host coverage proves custom-percent openings check Custom, focus the percent box, select the current value, and return focus to the worksheet after canceling; the custom Zoom command returns focus after accept or cancel. Remaining work includes status/ribbon shortcut breadth. | In Progress |
| UI-CMD-HELP-001 | UI-CAT-HELP-001 | Help, Send Feedback, About, Legal Notices | External process guard, About modal, Legal Notices modal, UIA invoke, keyboard close, excluded Microsoft services. | In Progress - Help Online, Check for Updates, and Feedback now expose stable UIA invoke metadata and route external browser launches through a guarded helper that reports failures with an owned message; About remains covered by owned-message/UIA source tests; Legal Notices is an owned copyable dialog backed by embedded project, privacy, and third-party notice resources. |
| UI-CMD-WCM-001 | UI-CAT-CONTEXT-001 | Worksheet context clipboard group | Live host keyboard-menu coverage proves the worksheet context menu opens on the grid, focuses Cut as the first enabled item, and exposes clipboard access headers `Cu_t`, `_Copy`, `_Paste`, and `Paste _Special...`. Remaining work includes right-click/Menu/Shift+F10 command invocation for every clipboard item and richer clipboard payload variants. | In Progress |
| UI-CMD-WCM-002 | UI-CAT-CONTEXT-001 | Worksheet context insert/delete group | Planner coverage proves access-key headers and Excel-like order for Insert/Delete cells, row-above/below, column-left/right, and delete row/column commands; source-route coverage proves each item dispatches to the existing mutation command path. Remaining work is live right-click/Menu/Shift+F10 invocation and shift-dialog variants. | In Progress |
| UI-CMD-WCM-003 | UI-CAT-CONTEXT-001 | Worksheet context sort/filter/data group | Sort, Custom Sort, Filter, Clear/Reapply, Pick From Drop-down, Quick Analysis, including planner disabled-state coverage for clear/reapply filter and pick-from-drop-down targets plus live host coverage that keyboard-opened Quick Analysis focuses Data Bars, targets the selected range on the grid, activates data-bars, color-scale, icon-set, column-chart, stacked-column-chart, line-chart, bar-chart, pie/doughnut, area, scatter/bubble, adjacent-column totals, and adjacent-column sparkline previews, and reports the unsupported range status without leaving stale preview state when no selection is available. | In Progress |
| UI-CMD-WCM-004 | UI-CAT-CONTEXT-001 | Worksheet context row/column group | Row/column-selection context menus include access-keyed Hide/Unhide, Row Height, Column Width, AutoFit, Group, and Ungroup commands, with Group/Ungroup routed through the existing outline workflow; live keyboard coverage now proves Shift+F10/Menu opens the row-scoped and column-scoped menus from whole-row/whole-column selections. Remaining work is broader live keyboard command mutation and target-specific disabled states. | In Progress |
| UI-CMD-WCM-005 | UI-CAT-CONTEXT-001 | Worksheet context comment/link/format/clear group | New Comment/Note, Edit/Delete/Resolve/Unresolve threaded comments, Show Notes, Hyperlink, Format Cells, clear commands. | In Progress |
| UI-CMD-SHEET-001 | UI-CAT-CONTEXT-002 | Sheet-tab context commands | Add, rename, duplicate, delete, move left/right, color, hide/unhide, select all, ungroup. | In Progress |
| UI-CMD-SHEET-002 | UI-CAT-CONTEXT-002 | Sheet-tab pointer/keyboard operations | Click, Ctrl/Shift group, drag reorder, double-click rename, scroll arrows, Ctrl+PageUp/PageDown, F6 active-tab focus, tab-strip Left/Right/Home/End, Shift+F10/Menu key with live focused-tab menu routing, placement-target, and access-key coverage. | In Progress |
| UI-CMD-SHORTCUT-001 | UI-CAT-SHELL-002 | All shortcut parity rows | Each shortcut row gets exact-modifier, target-state, visible result, undo/repeat evidence including Scenario Manager Show through F4, and focus evidence. | In Progress |
| UI-CMD-KEYTIP-001 | UI-CAT-SHELL-002 | Ribbon keytips | Top-level, QAT, command-scope, dropdown, nested Conditional Formatting, Escape cancellation, pixel placement; narrow collapsed-group routing now ignores hidden source controls so visible overflow group keytips win, and generated collapsed group keytips are unique within each selected tab. | In Progress |

## Leaf Row Split Queue

These are the next exact leaf IDs to materialize as testing reaches each area. The `Commands to split` column is intentionally explicit: every named command needs its own evidence row or an explicit Excluded/Deferred row.

| Leaf ID range | Parent | Commands to split | Status |
|---|---|---|---|
| UI-CAT-FILE-001D-L | UI-CAT-FILE-001 | New; Save; Close; Backstage Back/Escape return; Info panel; Share; Account; Options; visible excluded/unsupported backstage entries such as Check In/Out and Online Templates. | In Progress - Online Templates excluded source/XAML coverage now proves visible excluded copy, stable UIA metadata/help text, normal button routing, and owned-message disclosure for the external Microsoft template-service dependency. |
| UI-CAT-QAT-001D | UI-CAT-SHELL-001 | Customize QAT excluded/disabled affordance if visible. | In Progress - Options dialog source/XAML coverage proves the Quick Access Toolbar category, below-ribbon affordance, reset deferred route, and non-persistence disclosure. |
| UI-CAT-SHELL-001A-C | UI-CAT-SHELL-001 | Minimize; maximize/restore; close window. Source/XAML coverage now proves the custom title-bar buttons expose Minimize, Maximize or Restore, and Close automation names, render the matching window icons, and route to WPF `SystemCommands`. | In Progress |
| UI-CAT-HOME-001A-E | UI-CAT-HOME-001 | Cut; Copy; Paste; Paste Special; Format Painter. | In Progress |
| UI-CAT-HOME-002A-M | UI-CAT-HOME-002 | Font family; font size; grow/shrink font; bold; italic; underline; double underline; strikethrough; font color; fill color; border presets; full border gallery; theme colors. | Not Started |
| UI-CAT-HOME-002N-V | UI-CAT-HOME-002 | Horizontal align; vertical align; wrap text; merge and center; indent increase/decrease; text rotation; justify/distributed; shrink to fit; Format Cells alignment. | Not Started |
| UI-CAT-HOME-002W-AF | UI-CAT-HOME-002 | Number format dropdown; built-in formats; custom format; decimal increase/decrease; comma; currency; percentage; locale/accounting partials. Number-format dropdown keytip focus and decimal/comma/currency/percent command-source routing are covered; live matrix execution and persistence remain. | In Progress |
| UI-CAT-HOME-003A-C | UI-CAT-HOME-003 | Conditional Formatting; Format as Table; Cell Styles. | In Progress |
| UI-CAT-HOME-004A-M | UI-CAT-HOME-004 | Insert cells/rows/columns/sheets; Delete cells/rows/columns/sheets; Row Height; Column Width; AutoFit; Hide/Unhide rows/columns/sheets; Format Cells; AutoSum; Fill; Fill Series; Flash Fill; Clear variants; Sort; Filter; Find; Replace; Go To; Go To Special. | In Progress |
| UI-CAT-INSERT-001E-H | UI-CAT-INSERT-001 | PivotTable refresh/layout/options; PivotChart; Recommended PivotTables excluded; Table distinct from Format as Table. | Not Started |
| UI-CAT-INSERT-002D-H | UI-CAT-INSERT-002 | Supported chart families; stock/radar; deferred advanced chart families; Recommended Charts excluded; sparklines. | Not Started |
| UI-CAT-INSERT-003B-K | UI-CAT-INSERT-003 | Shapes; Text Box; Header/Footer; Symbols; Hyperlink; Comment/Note; Online Pictures excluded; Icons excluded; 3D Models excluded; SmartArt excluded; Screenshot excluded; WordArt excluded; Equation excluded. Shapes now have keytip menu coverage for Rectangle/Ellipse/Line with a real rectangle insertion proof; remaining text box/header/symbol/hyperlink/comment surfaces need fuller interaction coverage. | In Progress |
| UI-CAT-DRAW-001D-Q | UI-CAT-DRAW-001 | Rectangle; Ellipse; Line; Bring Forward; Send Backward; Size/Rotation; Fill Color; Outline Color; Alt Text; Crop; Gradients/Effects; Selection Pane; Freehand Ink excluded; interactive drag handles deferred. Insert > Shapes now proves Rectangle menu insertion through keyboard keytips; ellipse/line insertion, draw-tab formatting, z-order, persistence, and visual rendering proof remain. | In Progress |
| UI-CAT-PAGE-001B-R | UI-CAT-PAGE-001 | Margins; Orientation; Paper Size; Print Area set/clear; Breaks; Background; Print Titles; Scale to Fit; Print Gridlines; Print Headings; Sheet Options display toggles; Themes with name-box default focus, Colors; Fonts; Effects; Header/Footer editing; Page Setup; Center on Page; Page Order. | In Progress |
| UI-CAT-FORMULAS-001A-H | UI-CAT-FORMULAS-001 | Insert Function; AutoSum variants; Logical; Text; Date & Time; Lookup & Reference; Math & Trig; Name Manager; Define Name; Use in Formula; Create from Selection. | In Progress |
| UI-CAT-FORMULAS-002A-I | UI-CAT-FORMULAS-002 | Trace Precedents; Trace Dependents; Remove Arrows; Show Formulas; Error Checking; Evaluate Formula; Watch Window; R1C1 Reference Style; Calculation Options; Calculate Now; Calculate Sheet. | In Progress |
| UI-CAT-DATA-001C-H | UI-CAT-DATA-001 | Refresh All; Sort; Filter; Advanced Filter; AutoFilter dropdown; Power Query connectors excluded. | In Progress |
| UI-CAT-DATA-002A-I | UI-CAT-DATA-002 | Text to Columns; Remove Duplicates; Data Validation; Consolidate; Goal Seek; Scenario Manager; Data Table; Forecast Sheet; Flash Fill. | In Progress |
| UI-CAT-DATA-003A-E | UI-CAT-DATA-003 | Subtotal; Group/Outline; Ungroup; Show Detail; Hide Detail; Data Model/Power Pivot excluded. | In Progress |
| UI-CAT-REVIEW-001A-C | UI-CAT-REVIEW-001 | Spell Check; Accessibility Checker; Statistics. | In Progress |
| UI-CAT-REVIEW-002A-Q | UI-CAT-REVIEW-002 | New Comment; Delete Comment; Previous Comment; Next Comment; Show Comments; threaded comment workflow; New Note; Edit Note; Delete Note; Previous Note; Next Note; Show Notes; Protect Sheet; Allow Edit Ranges; Protect Workbook; Share; Thesaurus excluded; Smart Lookup excluded; Translate excluded; Share Workbook legacy excluded; Track Changes excluded. | In Progress |
| UI-CAT-VIEW-001A-H | UI-CAT-VIEW-001 | Normal; Page Break Preview; Page Layout; Custom Views; Show Gridlines; Show Headings; Show Ruler; Show Formula Bar. | In Progress |
| UI-CAT-VIEW-002A-H | UI-CAT-VIEW-002 | Freeze Panes; Split; Zoom; Zoom to Selection; 100% Zoom; Arrange All; New Window, Hide, Unhide, View Side by Side, Synchronous Scrolling, Reset Window Position, and Switch Windows now have planner-backed single-window state. Freeze Panes menu keytips now execute top-row, first-column, selection-based, and unfreeze commands against model state; Split keytips toggle selected-cell split state. Source and live keytip coverage prove New Window stays invokable through the owned deferred-message path while unsafe dependent window commands are disabled with runtime help text until multi-window hosting exists. | In Progress |
| UI-CAT-SHEETTAB-002A-J | UI-CAT-CONTEXT-002 | Add Sheet; Rename with default name-box focus/select-all; Delete; Duplicate; Move Left; Move Right; Tab Color; Hide Sheet; Unhide Sheet; Select All Sheets; Ungroup Sheets. | In Progress |
| UI-CAT-SHEETTAB-003A-C | UI-CAT-CONTEXT-002 | Tab click selection; double-click rename; drag reorder and overflow arrows. | Not Started |
| UI-CAT-STATUS-002A-F | UI-CAT-VIEW-002 | Ready/Edit/Input mode text; Average; Count; Sum; Min; Max. Status calculator coverage proves Ready/input prompt and numeric Average/Count/Sum/Min/Max semantics; host layout coverage now verifies a numeric worksheet selection renders aggregate labels, separates Count from Numerical Count, and entering inline edit mode renders `Edit` while hiding aggregate text. | In Progress |
| UI-CAT-STATUS-003A-E | UI-CAT-VIEW-002 | Normal view button; Page Layout view button; Page Break Preview button; Zoom Out; Zoom In; Zoom percentage/dialog; Zoom slider; F6 shell focus now has live host coverage proving the forward worksheet/ribbon/formula-bar/sheet-tab/status/worksheet cycle, reverse F6 landing on Zoom Out, Tab staying in the zoom controls by moving to the slider, keyboard traversal through the zoom percentage, and Escape returning status-bar focus to the worksheet. View > Zoom keytip coverage proves `Alt,W,Q,2`, `Alt,W,Z1`, and `Alt,W,ZS` update status text, close menus/overlays, and exit keytip mode. | In Progress |

## 2026-05-22 Expansion Rows

These rows were appended after syncing from latest `origin/main` so newly merged or heavily refreshed UI surfaces are not lost while the catalog is expanded into executable leaf cases. Each row must eventually record mouse, keyboard/keytip/access-key, UIA, command-route, target-matrix, undo/focus, and persistence/output proof where applicable.

| Row ID | Parent | Current surface to cover | Required UI proof | Status |
|---|---|---|---|---|
| UI-CMD-FILE-008 | UI-CAT-FILE-002 | PDF/XPS publish options depth | Export active sheet, selection, and visible workbook to `.pdf`, explicit `.xps`, and extensionless paths; cover page range, standard/minimum quality, ignore print areas, open-after-publish on/off, overwrite/cancel, PDF sheet-name bookmarks with page filtering, XPS core properties, and visible option summaries. | Not Started |
| UI-CMD-FILE-009 | UI-CAT-FILE-002 | Print Preview toolbar and navigation | Open from Ctrl+P and File > Print; verify next/previous/first/last page controls, page-count labels, zoom controls, margins/orientation/paper summary, disabled states at boundaries, Escape/back return, and foreground-safe screenshot evidence. | In Progress - Print Preview toolbar planner coverage now normalizes first/previous/next/last navigation states and `Page X of Y` labels for first, middle, last, and invalid page-count inputs; toolbar source coverage also proves stable UIA metadata for print, page navigation, page entry/status, zoom, margins, page setup, close, and settings summary controls. |
| UI-CMD-IO-001 | UI-CAT-FILE-001 | XLSX/native persistence warnings tied to UI actions | From UI-created workbook content, save/reopen and verify visible warnings or preserved state for pivot XML refs, drawing refs, sheet refs, external links, unsupported sheet refs, advanced conditional formatting, comments, shared strings, printer settings, chart design metadata, and unsupported feature messaging. | Not Started |
| UI-CMD-GRID-004 | UI-CAT-GRID-002 | Inline formula editing and formula bar parity | Edit with F2, double-click, formula bar, Ctrl+F2, Enter/Tab/Escape; verify reference coloring, overlay text, absolute/relative F4 conversion, range selection while editing, structured-reference insertion, caret movement, and focus return. | Not Started |
| UI-CMD-HOME-EDIT-005 | UI-CAT-HOME-004 | Go To dialog history and navigation targets | Cover Ctrl+G/F5, Home > Find & Select > Go To, reference-box default focus/select-all, named ranges, sheet-qualified refs, invalid refs, Go To Special first-choice focus, history persistence in-session, OK/Cancel/Escape, and active selection/focus proof. | In Progress |
| UI-CMD-HOME-EDIT-006 | UI-CAT-HOME-004 | Find/Replace with format criteria | Cover find-only and replace flows with text, formulas, values, workbook/sheet scope, match case, entire cell, direction, format picker/clear format, all results list, no-match state, access keys, search-box default focus/select-all, and focus restoration. | In Progress |
| UI-CMD-HOME-STYLE-004 | UI-CAT-HOME-003 | Structured-reference formula UI in tables | Core formula/dependency coverage verifies data-body column refs, `#Headers`, `#Data`, `#All`, `#Totals`, current-row, `#This Row`, unqualified row refs, multi-column ranges, dependency tracking, and recalculation. UI formula-edit coloring now resolves table column refs, `#Headers`, current-row, `#This Row`, and multi-column ranges through the shared structured-reference resolver while preserving normal grid-reference coloring afterward. Remaining work is live table creation/editing, rendered formula edit coloring, and save/load evidence. | In Progress |
| UI-CMD-INSERT-011 | UI-CAT-INSERT-001 | PivotTable style gallery and style options | Deterministic UI/model coverage now guards built-in Light/Medium/Dark style cataloging, custom/current style preservation, lightweight gallery routing, style option button routing, and row/column header plus banded row/column toggles preserving the active style. Remaining work is live activation, explicit rendered style proof for `PivotStyleMedium2`, undo/repeat, and save/load evidence from UI workflows. | In Progress |
| UI-CMD-INSERT-012 | UI-CAT-INSERT-001 | PivotTable Show Details drill-down | Core command coverage now verifies detail-sheet creation, affected-cell targeting, extracted source rows, undo removal, disabled-state rejection, workbook-structure protection, and unique detail sheet naming; host planner/source coverage guards ribbon entry point, double-click-before-edit gesture routing, no fallback outside a PivotTable, undoable `DrillDownPivotTableCommand` use, affected-cell detail-sheet activation, tab refresh, and viewport refresh. Remaining work is live item/subtotal/grand-total/matrix/filtered-cell execution, focus proof, and save/load behavior. | In Progress |
| UI-CMD-INSERT-013 | UI-CAT-INSERT-001 | Pivot slicer and timeline authoring | Insert slicers/timelines with field selector default focus for connected worksheet-range PivotTables, use pane controls and keyboard selection, verify filter state, clear/filter buttons, cross-sheet source data, cache relationships, persistence, and partial/excluded native floating-object fidelity notes. | In Progress |
| UI-CMD-INSERT-014 | UI-CAT-INSERT-001 | PivotChart field buttons and options | Insert bound PivotChart with recommended-gallery default focus, PivotChart options with style-gallery default focus, toggle master/report-filter/axis-field/value-field buttons, open field-button menus, verify sort/filter/value-settings routes, native JSON persistence, binding refresh after PivotTable layout changes, and chart selection focus. | In Progress |
| UI-CMD-INSERT-015 | UI-CAT-INSERT-001 | GETPIVOTDATA UI/formula behavior | With PivotTable selection active, create `GETPIVOTDATA` formulas by cell selection and manual edit; verify lookup results, invalid field/item handling, recalculation after pivot filters/layout changes, formula bar display, and save/load. | In Progress - core GETPIVOTDATA evaluation is covered by `PhaseA2FunctionTests`; Insert Function categorizes/searches `GETPIVOTDATA`; formula point-mode cell selection now plans `GETPIVOTDATA(...)` for PivotTable value cells with row, column, page-filter, subtotal, grand-total, cross-sheet quoting, and string-escaping coverage in `GetPivotDataFormulaPlannerTests`. |
| UI-CMD-INSERT-016 | UI-CAT-INSERT-002 | Chart design metadata and Select Data deferred controls | Create chart, change type/style/title/legend/data source through visible dialogs, verify design metadata persisted to native JSON, Select Data helper/deferred controls are labeled honestly, and chart commands enable only for chart targets. | Not Started |
| UI-CMD-PAGE-006 | UI-CAT-PAGE-001 | Page Setup and Header/Footer dialog fidelity | Page Setup has tab/access-key coverage, normal Page Setup orientation default focus, Print Titles Sheet-tab repeat-rows default focus, and Scale to Fit active scaling-input focus; remaining work includes first/odd/even header/footer variants, presets, section fields, token buttons, center on page, page order, OK/Cancel/Escape, print preview reflection, and persistence. | In Progress |
| UI-CMD-FORM-006 | UI-CAT-FORMULAS-001 | Insert Function category breadth | Through Insert Function and formula bar, cover recently surfaced function families including dynamic arrays, database, engineering, financial, statistical, lookup/reference, text, date/time, logical, math/trig, higher-order/lambda-adjacent, and pivot functions; verify search, MRU, argument help, invalid arguments, and formula insertion. | In Progress - Insert Function catalog now categorizes representative database, engineering, expanded dynamic-array, higher-order/lambda-adjacent, and PivotTable functions; argument-help metadata covers representative dynamic array, database, engineering, higher-order, and `GETPIVOTDATA` entries through `InsertFunctionDialogTests` and `InsertFunctionCatalogPlannerTests`. |
| UI-CMD-DATA-008 | UI-CAT-DATA-001 | AutoFilter typed criteria and ribbon/keytip routes | AutoFilter dialog now supports the Excel `Alt+Down,F` continuation key by opening the visible text/number/date filter submenu and focusing its first command without hijacking literal `f` typed into search or criteria fields; nested text/number/date filter submenu commands now receive unique scoped access keys, filter-by-color swatches are keyboardable with Tab/Enter/Space plus Arrow/Home/End navigation, the value checklist exposes a named keyboard target with Space toggle plus Home/End boundary navigation, blank filter headers fall back to the absolute worksheet column label, Reapply Filter reruns the remembered AutoFilter command without reopening the dialog, live host coverage proves Reapply refreshes filter-hidden rows after data changes and Clear Filter removes filter-hidden rows after a live filter application, and typed criteria now has dialog-to-filter-command row visibility proof. Remaining work includes full mouse/Alt keytip dropdown creation from headers. | In Progress |
| UI-CMD-DATA-009 | UI-CAT-DATA-001 | Advanced Filter dialog safety and criteria defaults | Cover list range, criteria range, copy-to range, unique records, invalid/missing criteria, no-risk defaults, OK/Cancel/Escape, range picker focus, and resulting filtered/copied output. | In Progress - dialog planner rejects missing/unsafe list and criteria ranges before command execution, copy-to controls stay disabled in no-risk in-place mode, criteria defaults remain blank until explicitly supplied, action/range controls have unique access keys, range pickers refocus the requested input, host source coverage proves repeatable `AdvancedFilterCommand` execution plus copy destination focus, and core command tests cover in-place, copy-to, unique, cross-sheet criteria, protected-sheet, invalid-header, undo, and stale-output behavior. |
| UI-CMD-DATA-010 | UI-CAT-DATA-003 | Subtotal dialog Excel-like flow | Cover At each change in, Use function, Add subtotal to, Replace current, Page break, Summary below, Remove All, grouped outline levels, invalid source, access keys, undo, and save/load. | In Progress - dialog coverage proves Excel-like defaults for group column, Sum function, subtotal-column checks, Replace current, Page break, Summary below, OK/Cancel/Remove All buttons, invalid no-column apply, access-keyed/static control order, Remove All routing, Replace-current composite command routing, and option propagation; core command tests cover inserted subtotal/grand-total rows, multiple value columns, page breaks, summary-above/below, invalid source, protected sheets, remove-all undo, and undo restoration. |
| UI-CMD-REVIEW-006 | UI-CAT-REVIEW-002 | Protection permissions and command disabled-state matrix | Protect sheet/workbook with selected permissions, Allow Edit Ranges disabled while the active sheet is protected and blocked from Review keytip invocation, locked/unlocked cells, password/cancel/invalid flows, ribbon/context/menu disabled states, edit attempts by target type, unprotect, undo limits, and persistence. Existing coverage proves selected permission labels map to sheet protection permissions, Allow Edit Ranges is disabled and not keytip-routable while the active sheet is protected, command guards enforce row/column formatting and mutation permissions, and undo restores protection state. Remaining work is broader live UI target-matrix evidence and persistence round trips. | In Progress |
| UI-CMD-RIBBON-004 | UI-CAT-SHELL-001 | Ribbon SVG icon visual coverage | Sweep all visible large/small generated icons across File/QAT/ribbon/contextual tabs; verify no missing keys, correct icon-only/icon+label layout, high-DPI scaling, disabled state tint, tooltip/name parity, and no clipping across tabs. Automated coverage now asserts visible main ribbon tooltip titles resolve to semantic icons instead of the generic fallback, and the Data Sort/Filter group uses vector `RibbonIcon` controls instead of text placeholder icons; File/QAT/contextual visual screenshot breadth remains. | In Progress |
| UI-CMD-HARNESS-001 | UI-CAT-SHELL-001 | Screenshot and visual evidence harness | Use `tools/screenshot_excel.ps1` and `tools/screenshot_ribbon.ps1` against latest build; verify foreground guard, captured window bounds, ribbon-tab screenshots, popup/dropdown limitations, output naming, and catalog evidence attachment. By default both scripts sweep the same max/1100/900/750 by tab matrix (36 captures each), emit width-aware `excel_<WidthLabel>_<RibbonTab>.png` / `ribbon_<WidthLabel>_<RibbonTab>.png` files, and write pairable `PairKey` metadata (`ribbon:<WidthLabel>:<TabFileName>`) plus counterpart file names into `screenshot_manifest.json`. Use the in-app no-live-Excel ribbon tour with `FREEX_SS_TOUR=1`, optional `FREEX_SS_TOUR_TABS` and `FREEX_SS_TOUR_WIDTHS`, for the default 36 planned captures across the catalog-backed ribbon tab set. Use `FREEX_SS_TOUR_BURST=1` to expand the same tour into 108 burst-phase captures named with `immediate`, `first_render`, and `settled` suffixes so resize/tab-switch flashes can be inspected without foreground automation; the tour manifest calls out the max/1100/900/750 resize breakpoint purpose for each width. The in-app tour emits `ribbon_screenshot_tour_manifest.json` with the requested tabs, widths, phases, and expected file list, exposes phase-grouped expected PNG names for immediate/first-render/settled review, and deletes only the currently requested plan's expected PNG files before capture so filtered reruns cannot reuse stale same-plan evidence. Source tests now prove both scripts declare the guarded ribbon tab set, missing planned tabs abort instead of producing partial evidence, the FreeX script matches the CI-safe tour planner, the tour planner matches the XAML catalog snapshot, normal captures are uniquely named, burst captures cover immediate/first-render/settled phases, scripts capture from window bounds, write deterministic width-aware `excel_*`/`ribbon_*` output names, and emit `screenshot_manifest.json` metadata for catalog evidence, pairable Excel/FreeX comparison, plus popup/dropdown limitations. | In Progress |
| UI-CMD-CONTEXT-006 | UI-CAT-CONTEXT-001 | Target-specific worksheet context coverage | Planner coverage now verifies worksheet, row, column, picture, shape, and text-box context menus expose only their expected command families. Live Shift+F10/Menu host coverage now proves worksheet, whole-row, whole-column, picture, shape, and text-box scoped routing with target-specific first focus and access headers. Remaining work includes live right-click/Menu routing for table, filtered range, chart, PivotTable, protected sheet, and edit-mode enabled states. | In Progress |
| UI-CMD-DIALOG-001 | UI-CAT-SHELL-002 | Dialog keyboard/accessibility sweep | For every modal/modeless dialog reached from command rows, record default focus, Tab order, access-key collisions, Enter/Space/Escape behavior, OK/Cancel equivalence, validation messages, UIA names/patterns, and focus return target; Advanced Filter, Consolidate, Go To Special, Scenario Manager, Subtotal, and Data Table now record default-focus coverage. | In Progress |
| UI-CMD-TARGET-001 | UI-CAT-GRID-001 | Cross-target command matrix execution | Re-run each command class against single cell, multi-cell range, whole row, whole column, non-contiguous selection, table body/header/totals, filtered selection, chart, drawing, PivotTable, protected sheet, hidden row/column, and multi-sheet group targets; record unsupported targets explicitly. | Not Started |

## First-Pass Test Queue

1. Launch latest Debug build and capture process/window state.
2. Exercise File/backstage: create blank workbook, Options, Account, Print/Export messages, return to workbook.
3. Exercise worksheet grid: type values/formulas, edit with F2/formula bar, navigate with Enter/Tab/arrows, undo/redo.
4. Exercise Home ribbon: bold/italic/underline, fill/font color prompts, borders menu, number format, merge, Find/Replace, Format Cells.
5. Exercise keyboard/keytips: Alt/F10 top-level tabs, Home command keytips, Escape, Shift+F10 worksheet menu, Ctrl+1.
6. Exercise sheet tabs/status: add/rename/duplicate/move/color/hide/unhide sheets, zoom controls.
7. Record findings immediately with reproduction, expected behavior, actual behavior, severity, and evidence.

## Execution Waves

| Wave | Goal | Exit criteria |
|---|---|---|
| 0. Inventory guard | Keep catalog in sync with code. | Counts for XAML click handlers, shortcuts, context menu commands, command inventory, and docs are updated. |
| 1. Launch/shell/backstage | Prove app starts and global surfaces work. | Latest build launches, shell renders, File/QAT/title/status basics pass by mouse and keyboard. |
| 2. Keyboard/keytips | Prove command access without mouse. | All shortcut matrix rows and top-level/keyed ribbon paths are either passed, partial with finding, or explicitly blocked. |
| 3. Home/grid/core editing | Prove common spreadsheet work. | Cell/range/row/column/sheet targets pass for selection, editing, formatting, clipboard, insert/delete, undo/redo, F4. |
| 4. Ribbon tab sweep | Exercise every visible command by tab. | Every in-scope command row has at least one mouse activation, one keyboard/keytip/access-key path where applicable, and state proof. |
| 5. Contextual/object surfaces | Cover targets that appear only after selection. | PivotTable, chart, drawing, table, slicer/timeline, sparkline, and sheet-tab contextual surfaces are covered. |
| 6. Dialog catalog | Cover every modal/modeless dialog. | Each dialog has default, changed, invalid, OK, Cancel/Escape, access-key, focus-order, and UIA evidence. |
| 7. Persistence/output | Prove command effects survive IO. | Relevant actions are verified through save/load, CSV/XLSX/native JSON, PDF/XPS, print preview, or screenshot evidence. |
| 8. Regression closure | Convert findings into automated guards. | Each fixed bug has a focused unit/source/UIA test and a retest entry in this catalog. |

## Per-Command Record Template

Use this table shape in follow-up passes when recording detailed rows:

| Field | Value |
|---|---|
| Catalog ID | `UI-CAT-AREA-NNN` |
| Command | Visible command name and source doc row. |
| Surfaces | Mouse, shortcut, keytip, access key, context menu, UIA. |
| Targets | Applicable target-matrix entries. |
| Expected command route | Host handler and model command/planner where known. |
| Expected result | State mutation, visual change, dialog, output, or persisted package change. |
| Evidence | Screenshot, test command, model assertion, saved file path, or finding ID. |
| Status | Not Started, In Progress, Passed, Partial, Finding, Blocked, Excluded. |

## Catalog Maintenance Rules

- Keep this file date-free and canonical at `docs/UI_TEST_CATALOG.md`.
- Append new coverage rows, finding IDs, smoke checks, and session notes here only.
- Update the row status in `Catalog Row Index` whenever evidence changes a row from Not Started to In Progress, Passed, Finding, Blocked, or Excluded.
- Preserve historical findings; add retest notes instead of rewriting old observations away.
- After each sync from `main`, refresh inventory counts when command docs or `MainWindow.xaml` changed.

## Findings Log

### UI-2026-05-19-001: File backstage does not close with Escape

Severity: P2
Status: Fixed
Evidence: Historical screenshot artifact removed during documentation cleanup; verification is retained below.
Fix: `MainWindow` handles bare Escape while Backstage is visible and returns focus to the workbook before normal transient-mode cancellation.
Verification: `MainWindowXamlKeyTipTests.EscapeFromVisibleBackstage_ReturnsToWorkbookBeforeTransientCancellation`.

Repro:

1. Launch FreeX.
2. Open File backstage with `Alt+F`.
3. Press `Escape`.
4. Press `Escape` again.

Expected: Backstage returns to the workbook, matching the normal keyboard escape route from a temporary full-window command surface.

Actual: The keytip badges clear after the first Escape, but the File backstage remains visible after a second Escape. The only observed visual route back is the back arrow.

### UI-2026-05-19-002: F10 does not visibly enter ribbon keytip mode from the worksheet

Severity: P2
Status: Fixed
Evidence: Historical screenshot artifact removed during documentation cleanup; verification is retained below.
Fix: `MainWindow` handles `F10` during `PreviewKeyDown`, before worksheet focus can consume it, and enters top-level ribbon keytip mode.
Verification: `MainWindowXamlKeyTipTests.MainWindowPreviewKeys_HandleWorksheetKeytipAndContextMenuEntryPoints` plus existing shortcut/keytip tests.

Repro:

1. Launch FreeX and keep focus on the worksheet.
2. Press `F10`.

Expected: Ribbon keytip badges appear for the top-level tabs and QAT, as documented in `docs/SHORTCUT_PARITY_MATRIX.md`.

Actual: No keytip badges appeared in the captured worksheet view. `Alt+F` did open File backstage with keytip badges, so the keytip system was present but this entry path needed a focused retest/fix.

### UI-2026-05-19-003: Shift+F10 did not open the worksheet context menu in the initial pass

Severity: P2
Status: Fixed after recheck
Evidence: Historical screenshot artifact removed during documentation cleanup; verification is retained below.
Fix: `MainWindow` handles `Shift+F10` during `PreviewKeyDown` and routes it through the existing worksheet context menu command path.
Verification: `MainWindowXamlKeyTipTests.MainWindowPreviewKeys_HandleWorksheetKeytipAndContextMenuEntryPoints`, `KeyboardShortcutMatcherTests`, and `WorksheetContextMenuPlannerTests`.

Repro:

1. Select a worksheet cell.
2. Press `Shift+F10`.

Expected: Worksheet context menu opens from the active cell.

Actual: No context menu appeared in the captured worksheet view. This needed a focused recheck using a verified foreground FreeX window before filing as a product bug.

### UI-2026-05-19-004: Backstage Options is visible but not UI Automation invokable

Severity: P2
Status: Fixed
Evidence: Historical screenshot artifact removed during documentation cleanup; verification is retained below.
Fix: The Backstage Options command has explicit `x:Name`, `AutomationProperties.Name`, `AutomationProperties.AutomationId`, help text, and tab-stop metadata while retaining the normal button `Click` handler.
Verification: `MainWindowXamlKeyTipTests.BackstageOptionsEntryPoint_IsNamedCommandForUiAutomation`.

Repro:

1. Launch FreeX.
2. Open File backstage.
3. Inspect or activate the visible `Options` item through UI Automation.

Expected: The visible `Options` command exposes an activation pattern, such as `InvokePattern`, matching its role as a clickable command and supporting accessibility/test automation.

Actual: The visible `Options` element was found by name, but it exposed no Invoke, Select, or ExpandCollapse pattern. A UIA activation attempt failed with `No invoke/select/expand pattern for Options`.

### UI-2026-05-19-005: Backstage Account is visible but not UI Automation invokable

Severity: P2
Status: Fixed
Evidence: Historical screenshot artifact removed during documentation cleanup; verification is retained below.
Fix: Backstage Account now uses `AutomationInvokeButton` with stable `AutomationProperties.Name`, `AutomationProperties.AutomationId`, help text, tab-stop metadata, and an owned activated message route.
Verification: `MainWindowXamlKeyTipTests.BackstageAccountEntryPoint_DisclosesLocalAccountDecision` and `MainWindowXamlKeyTipTests.DialogEntryPointButtons_HaveStableAutomationIds`.

Repro:

1. Launch FreeX.
2. Open File backstage.
3. Inspect or activate the visible `Account` item through UI Automation.

Expected: The visible `Account` command exposes an activation pattern, such as `InvokePattern`, matching its role as a clickable backstage navigation command.

Actual: The visible `Account` element exposed only `SynchronizedInputPattern` and no Invoke, Select, or ExpandCollapse pattern in the UIA pass. A guarded foreground mouse click did open the Account informational dialog, so this was scoped to accessibility/test automation rather than the visual click path.

### UI-2026-05-19-006: UIA Invoke on dialog entry points returns without opening dialogs

Severity: P2
Status: Fixed
Evidence: Historical screenshot artifact removed during documentation cleanup; verification is retained below.
Fix: Insert Function, About FreeX, Account, and Options now use an explicit `IInvokeProvider` button peer that dispatches the click to the WPF dispatcher; dialog/message entry points are shown as owned, activated windows/messages.
Verification: `MainWindowXamlKeyTipTests.DialogEntryPointButtons_HaveStableAutomationIds`, `MainWindowXamlKeyTipTests.DialogEntryPointHandlers_UseOwnedActivatedDialogs`, and focused `MainWindowXamlKeyTipTests` run passed 74 tests.

Repro:

1. Launch FreeX.
2. Invoke `Insert Function` through UI Automation.
3. Select Help through UI Automation and invoke `About FreeX`.
4. Inspect top-level windows for the FreeX process after each invocation.

Expected: Each dialog entry point opens its corresponding dialog, and the dialog appears as a top-level owned window in the FreeX process.

Actual: `Insert Function` and `About FreeX` both exposed activation patterns and returned from UIA activation, but no additional FreeX top-level dialog appeared. Later mouse checks proved the visual click path worked, while UI Automation activation needed the fix above.

## Passed Smoke Checks

| Check | Evidence | Notes |
|---|---|---|
| App launch renders main shell | Historical screenshot artifact removed during documentation cleanup. | Title bar, QAT, Home ribbon, formula bar, grid, sheet tab strip, and status bar visible. |
| Grid accepts typed numeric input | Historical screenshot artifact removed during documentation cleanup. | Initial coordinate calibration clicked B7 instead of A1, but keyboard data entry and Enter navigation worked. |
| `Ctrl+1` opens Format Cells | Historical screenshot artifact removed during documentation cleanup. | Dialog opens on Number tab and shows tab strip through Protection. |
| File backstage opens via `Alt+F` | Historical screenshot artifact removed during documentation cleanup. | Backstage displays Home/New/Recent/Pinned and keytip badges. |
| File backstage Back returns to workbook | Historical screenshot artifact removed during documentation cleanup. | UIA found and invoked the `Back` control successfully. |
| Sheet insertion works from UIA | Historical screenshot artifact removed during documentation cleanup. | Invoking `Insert Sheet` created and selected `Sheet2`. |
| Zoom buttons work from UIA | Historical screenshot artifact removed during documentation cleanup. | Zoom changed through the status bar controls and returned near baseline. |
| Data ribbon renders | Historical screenshot artifact removed during documentation cleanup. | Top-level Data commands visible; several detailed commands are under collapsed dropdown groups at this width. |
| Insert ribbon renders | Historical screenshot artifact removed during documentation cleanup. | PivotTable, Table, Pivot refresh, Charts, Sparklines, Links & Objects visible. |
| View ribbon renders | Historical screenshot artifact removed during documentation cleanup. | View controls captured for follow-up interaction testing. |
| Review ribbon renders | Historical screenshot artifact removed during documentation cleanup. | Review controls captured for follow-up interaction testing. |
| Backstage Account opens by mouse | Historical screenshot artifact removed during documentation cleanup. | Foreground-confirmed mouse click opened the Account informational dialog. |
| Help tab renders and About opens by mouse | Historical screenshot artifact removed during documentation cleanup. | Foreground-confirmed mouse click opened the About FreeX dialog. |
| Help tab selects by UI Automation | Historical screenshot artifact removed during documentation cleanup. | `SelectionItemPattern.Select` switched to the Help tab on the latest clean build. |
| Draw ribbon renders on latest build | Historical screenshot artifact removed during documentation cleanup. | UIA selected the Draw tab and captured the command surface. |
| Page Layout ribbon renders on latest build | Historical screenshot artifact removed during documentation cleanup. | UIA selected the Page Layout tab and captured the command surface. |
| Formulas ribbon renders on latest build | Historical screenshot artifact removed during documentation cleanup. | UIA selected the Formulas tab and captured the command surface. |
| Data/Review/View ribbons render on latest build | Historical screenshot artifact removed during documentation cleanup. | UIA selected each tab and captured the command surface. |
| Help ribbon renders on latest build | Historical screenshot artifact removed during documentation cleanup. | UIA selected the Help tab and captured the command surface. |
| Catalog branch build baseline | No screenshot | `codex/ui-test-catalog` built successfully on 2026-05-21 from latest fetched `origin/main` with `dotnet build FreeX.slnx -m:1 /nodeReuse:false -p:UseSharedCompilation=false`. |
| External paste OS clipboard guard | Automated test | `ClipboardPastePlannerTests.ExternalPaste_UsesRealWindowsClipboardTextAndRejectsStaleInternalCopy` sets the real Windows clipboard on an STA thread, verifies stale internal-copy rejection, and deserializes a 2x2 tab-delimited paste payload. Live Ctrl+V UIE2E is still pending. |
| Comment marker pixel assertion | Automated test | `GridViewDrawingObjectThemeTests.CommentMarkerRenderer_PaintsRedTriangleAtCellTopRight` renders the comment indicator path and samples red-dominant pixels at the top-right marker location. |
| Picture body/handle hit testing | Automated test | `GridViewDrawingObjectThemeTests.PictureHitTesting_MapsPictureBodyAndResizeHandleToObjectCommands` verifies a visible picture maps to `ObjectKind.Picture`, body move hit testing, and the SE resize handle path. Full live drag/resize persistence remains pending. |
| Touchpad wheel delta normalization | Automated tests | `ViewportScrollCalculatorTests.CalculateWheelScroll_UsesNormalizedTouchpadDeltaForSmallVerticalMovement` and `MainWindowWheelHandler_NormalizesRawMouseWheelDeltaBeforeScrolling` verify sub-120 wheel deltas feed the scroll calculator. Live wheel/Shift+wheel/Ctrl+wheel input remains pending. |
| Chart, hyperlink, and font command route guards | Automated tests | `MainWindowSourceHygieneTests.RibbonChartButtons_RouteThroughRenderableChartInsertionCommandPath`, `HyperlinkDialogAndCtrlClick_RouteThroughSetAndNavigatePlans`, `FontDropdownSelection_SyncsThroughStyleDiffToolbarStateAndGridTypeface`, and `MainWindowFontFormattingTests.FontFamilyDropdown_AppliesModelStyleAndGridTypeface` guard the latest source routing plus deterministic font dropdown model/typeface flow. Live mouse/key/dialog/render persistence remains pending. |
| UIE2E input harness expansion | Test harness | `FreeXUiRun` now has foreground-gated `HoldControlAndPress` and `WheelAtCell` helpers plus Win32 `MOUSEEVENTF_WHEEL` support for future Ctrl+V/Ctrl+C, Ctrl+K, wheel, Shift+wheel, and Ctrl+wheel live tests. A direct formula UIE2E rerun timed out in this desktop session, so new foreground-dependent scenarios remain gated instead of added as always-on assertions. |
| Shared UIE2E app instance | Test harness | The live UIE2E suite now has a single `FreeXUiE2eTests.SharedAppInstance_CoversLiveUiScenarios` fact. It starts one `FreeXUiRun`, executes the cell-overflow and formula-editing harnesses against that same FreeX process, then closes the app once at the end. |
| Shared UIE2E launch guard | Automated source guard | `MainWindowSourceHygieneTests.LiveUiE2eAppProcessLaunch_IsCentralizedInSharedHarness` scans the host test sources and fails if another test file starts `FreeX.App.Host.exe` or calls `FreeXUiRun.Start()`. In-process `new MainWindow(...)` layout tests remain model/window construction tests and do not launch the app executable. |
| Shared in-process MainWindow harnesses | Test harness | `MainWindowAdaptiveRibbonTests` and `MainWindowRibbonKeyTipTests` now keep one WPF `MainWindow` alive per harness class, reset workbook/menu/keytip/dropdown/layout state before each assertion, and avoid per-test `Show()`/`Close()` churn. Focused verification passed 47 WPF tests. |
| Real WPF file-drop command route | Automated source guard | `MainWindowSourceHygieneTests.MainWindowFileDrop_WiresWindowDropToWorkbookPlannerAndOpenFile` verifies the window `AllowDrop`/`DragOver`/`Drop` wiring still flows through `WorkbookDropPlanner.SelectOpenableFile` and `OpenFileAsync`. Live `DragDrop.DoDragDrop` evidence remains pending. |

## Blocked / Invalidated Smoke Attempts

| Attempt | Status | Notes |
|---|---|---|
| 2026-05-21 catalog Wave 1 guarded live input | Blocked | FreeX launched, but global keyboard/mouse focus was captured by an unrelated Microsoft Excel window. The generated screenshots were invalid and deleted. Future live input passes must verify foreground process/window title immediately before every global mouse or keyboard action, or use process-scoped UI Automation patterns only. |

## Session Notes

- Subagent coverage inventory found strong planner, parser, formatter, XAML, and command-status tests, but limited end-to-end WPF workflow coverage.
- High-risk manual gaps: keytip placement/routing, real WPF focus transitions, partial shortcut paths, dialog workflows, file picker/print/export flows, pivot UI, and visual fidelity.
- Test harness incident: a later automation pass failed to bring FreeX above OneNote before sending input. Accidental OneNote input was immediately undone, and invalid OneNote screenshots were deleted from the UI evidence artifact directory. Future passes must verify the foreground window title is `Book1 - FreeX` before sending global keyboard input.
- Harness adjustment: subsequent passes use UI Automation invocation plus `PrintWindow` screenshots so FreeX can be tested without stealing foreground focus. This works well for normal buttons/tabs, but popup/dropdown flyouts need a separate foreground-safe mouse-input strategy because they are not reliably captured through the owner window.
- Foreground-safe mouse limitation: Windows foreground locking later kept Codex in front, and the harness correctly aborted before sending mouse input. Further visual click testing should be done only when the foreground guard confirms a FreeX-owned window title, or through a dedicated interactive runner.
- Harness targeting note: a name-only UIA lookup for `Insert` can hit the Home-ribbon Insert button before the top-level Insert tab. Future tab sweeps should filter for `ControlType.TabItem` plus name.
- 2026-05-26 targeted gap pass: subagents re-inspected external paste, WPF drag/drop, picture manipulation, touchpad wheel, chart insertion, hyperlink/Ctrl+click, and font dropdown/render sync on the latest synced branch. Stable automated guards were added for real OS clipboard text, comment-marker pixel rendering, picture object hit testing, high-resolution wheel normalization, chart/hyperlink/font command routing, and deterministic Home font dropdown model/typeface flow. Real WPF drag/drop, chart insertion by actual ribbon click, hyperlink dialog plus Ctrl+click navigation, picture body/resize dragging, and touchpad wheel gestures still need foreground-gated live UIE2E evidence.
- 2026-05-26 continuation: after resyncing from `origin/main`, subagents scoped the next live UIE2E seams. The live harness gained Ctrl-key and wheel helpers with foreground process checks, and file-drop source routing now has a stable guard. The direct `FormulaEditingUiE2eTests` run timed out in this session, so no new live interaction pass is marked Passed from that attempt.
- 2026-05-26 shared-instance update: the separate live UIE2E facts were combined into one `FreeXUiE2eTests` fact so the app launches once, runs all current live UI scenarios in sequence, and closes once. Scenario-specific code remains in reusable harness classes.
- 2026-05-26 launch-surface audit: all test sources were reviewed for process launches. The only checked-in `FreeX.App.Host.exe` launch path is now `FreeXUiRun.Start()` inside the shared UIE2E harness, and a source guard enforces that future UIE2E scenarios append to the shared harness instead of creating their own app process.
- 2026-05-26 in-process MainWindow reuse: the repeated adaptive-ribbon and keytip WPF harnesses were converted from close/recreate-per-test windows to shared windows with per-test state reset. `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Debug --filter "FullyQualifiedName~MainWindowAdaptiveRibbonTests|FullyQualifiedName~MainWindowRibbonKeyTipTests|FullyQualifiedName~StatusBarLayoutTests" -m:1 /nodeReuse:false -p:UseSharedCompilation=false -v:minimal` passed 47/47.
- 2026-05-26 dirty-close harness fix: after workbook dirty tracking added a close-time save prompt, WPF `MainWindow` tests that mutate a workbook can hang during teardown. MainWindow-hosted tests now close through `MainWindowTestCleanup.CloseWithoutSavePrompt`, preserving the production prompt while preventing modal save prompts from blocking automated runs.
- 2026-05-26 user feedback batch 3: added automated coverage for legacy Data filter keytips (`Alt+D,F,F`), autofill edge-scroll intent/calculation, Save As backstage return routing, inline formula point-mode/focus guards, and existing `COUNTA` evaluator support. Focused verification passed `GridViewAutofillTests` 4/4, Host source/keytip/viewport tests 154/154, formula/keytip focused Host tests 35/35, and Core formula `COUNTA`/coercion tests 33/33; full solution build passed.
- 2026-05-27 user feedback batch 3 follow-up: added formula range-entry shortcut parity coverage for selection-moving keys while a formula editor is active. `Ctrl+Shift+Arrow` now routes through worksheet data-boundary selection planning and updates the live formula reference range instead of being swallowed by the text editor. Focused verification passed Host formula range/edit-key/source tests 43/43.

## Current High-Risk Gaps

| Gap | Why it matters |
|---|---|
| Real WPF end-to-end coverage is still thinner than planner/parser coverage. | Unit tests prove command planning, but mouse/focus/menu automation can still fail in the real window. |
| Dropdown galleries and nested menus need systematic mouse/keytip passes. | The XAML contains hundreds of click handlers; grouped menus are where command routing commonly drifts. |
| Target-specific command behavior needs explicit coverage. | A command that works on a single cell can still fail on rows, columns, filtered ranges, tables, pivots, charts, or protected sheets. |
| Modal dialogs need access-key/focus/UIA sweeps. | Many dialog parser tests exist, but keyboard users and UI automation depend on WPF wiring and focus return. |
| Object and contextual surfaces need selection-state coverage. | Chart, PivotTable, table, drawing, slicer/timeline, and sparkline commands are invisible until the correct object is active. |
| Persistence checks should be attached to UI actions. | Formatting, page setup, charts, pivots, tables, and protection need save/load proof, not just visual proof. |
| Foreground-gated live input remains needed for the latest hard UI gaps. | The current pass added deterministic guards, but real OS drag/drop, ribbon chart click, hyperlink Ctrl+click, picture drag/resize, touchpad wheel, and pixel-level font dropdown render proof still need an interactive desktop runner with per-action foreground checks. |

## Next Catalog Tasks

1. Continue expanding the source-based machine-readable inventory guard beyond the current command, shortcut, top-level/contextual tab, dialog, XAML click-handler, UIA automation-id, keytip metadata, worksheet context-menu, screenshot-tool, evidence-artifact, and catalog snapshot counts.
2. Expand the process-scoped UI automation snapshot harness beyond the visible-control, shell-pattern, shortcut/key-routing, and dialog-pattern checks.
3. Attach `tools/screenshot_excel.ps1` and `tools/screenshot_ribbon.ps1` visual evidence to catalog rows, with a foreground-window guard before any global input.
4. Continue Wave 1 and Wave 2 on the latest build, recording every pass/finding in this catalog.
5. Expand each `UI-CAT-*` row into per-command child rows as live testing reaches that area.
6. For each finding, add a focused automated guard when the bugfixing session closes it.
