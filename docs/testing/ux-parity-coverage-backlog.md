# FreeX / Excel UX Parity Coverage Backlog

Canonical path: `docs/testing/ux-parity-coverage-backlog.md`

## Purpose

This backlog is the repo-local breadth checklist for Excel-vs-FreeX user testing. It complements the active paired-run plan in `docs/testing/freex-excel-ux-parity-suite.md` and the execution/evidence catalog in `docs/testing/ui-test-catalog.md`.

Use this file to decide which UI surfaces still need paired visual and behavioral coverage. Record actual passes, screenshots, manifests, blockers, and findings in the UI test catalog or the UX parity suite run artifacts.

## Coverage Rules

Each surface is ready to close only when the paired Excel and FreeX pass includes:

| Proof | Required evidence |
|---|---|
| Visual reference | Excel and FreeX screenshots for the same workbook, viewport, selection, and command state. |
| Behavioral result | Workbook, view, dialog, selection, focus, or exported-output state proving what changed. |
| Input breadth | Mouse plus applicable shortcut, keytip, access key, Tab traversal, Enter, Escape, and context-menu paths. |
| Accessibility | UIA name/id/pattern, focus return, disabled-state, and keyboard-only traversal where applicable. |
| Persistence | Save/reopen, export, or package-level proof for persisted workbook features. |
| Disparity tracking | Any mismatch logged with repro steps, severity, expected Excel behavior, actual FreeX behavior, and linked evidence. |

## Scenario Families

| Surface / family | Paired coverage still needed | Next actionable scenario |
|---|---|---|
| Startup, Open, Save | Launch, blank workbook, open recent/local XLSX, Save, Save As, invalid path, overwrite, close/dirty prompt, foreground ownership. | Run paired startup/open/save smoke with the same generated corpus and attach native dialog screenshots plus saved workbook deltas. |
| Grid selection, edit, fill | Click, drag, Shift/Ctrl selection, row/column headers, edit mode, formula edit, fill handle, autofill options, resize, wheel scroll. | Capture a grid basics pair that proves selection visuals, edit commit/cancel, fill result, and row/column resize behavior. |
| Ribbon tabs and commands | Top-level tabs, QAT, contextual tabs, split buttons, galleries, dropdowns, disabled states, keytips, command routing. | Expand the paired ribbon matrix from tab screenshots into representative command activations per tab and contextual object state. |
| Formula bar and name box | Name navigation, defined names, formula entry, `fx`, expand/collapse, reference highlighting, error/invalid entry. | Pair a formulas sheet walkthrough covering name box navigation, Insert Function, long formula editing, and cancel/commit behavior. |
| Dialogs | Format Cells, Sort, Data Validation, Page Setup, Insert Function, Find/Replace, Options-style dialogs, invalid input, OK/Cancel/Escape. | Convert the smoke Format Cells pair into a dialog batch with access-key, default button, focus order, and UIA pattern checks. |
| Status bar | Ready/edit modes, statistics, zoom slider/buttons, view shortcuts, selection counts, accessibility names. | Pair a status bar pass using numeric selection stats, zoom min/max, Ctrl+wheel zoom, and footer view buttons. |
| Sheet tabs | Add, rename, delete, duplicate, move, color, hide/unhide, group/ungroup, context menu. Overflow Activate has paired foreground capture in `tools/ux-parity-runs/20260702-012034/ux-scenario-batch.json` and still needs visual review. | Follow the existing smoke sheet-tab pair with drag reorder, grouped sheets, keyboard/context-menu routes, and visual review of the paired overflow Activate screenshots. |
| Panes and windows | Freeze panes, split panes, pane scrollbars, page layout/page break views, zoom, arrange windows, new window, hide/unhide window. | Pair a view-state workbook that exercises freeze/split visuals, independent pane scrolling, and window/view commands. |
| Context menus | Worksheet cell/range, row/column headers, sheet tabs, charts, tables, PivotTables, objects, keyboard Menu/Shift+F10, access keys. | Capture target-specific context-menu pairs and verify hidden/disabled rows plus command result for each target class. |
| Keyboard shortcuts | Documented shortcuts, exact modifier rejection, repeat/F4, undo/redo, navigation, editing, dialog shortcuts, keytip cancellation. | Build a paired keyboard smoke that records shortcut result state and rejects near-miss modifier combinations. |
| Charts | Insert chart, chart sheet, chart element selection, contextual tabs, format panes/dialogs, resize/move, save/reopen. | Pair an embedded chart walkthrough covering create, select element, change style/type, resize, and persisted visual output. |
| Tables | Format as Table, create table, headers/totals, resize, filters, structured references, Table Design contextual tab. | Pair table creation and editing with saved workbook proof and table-filter dropdown evidence. |
| PivotTables | Insert, field list, drag/drop fields, filters, slicers/timelines, Analyze/Design tabs, refresh, drill/detail, style. | Pair a native PivotTable walkthrough focused on field-list interaction, filter menus, contextual tabs, and result-grid changes. |
| Conditional formatting | Highlight/top-bottom/data bars/color scales/icon sets, rule manager, clear rules, visual result, persistence. | Pair a conditional-formatting gallery/dialog pass with workbook cells proving visual and saved rule state. |
| Data validation | List/input/error settings, dropdown display, invalid entry, prompt/error message, circle invalid data, persistence. | Pair a validation-list workbook covering dropdown opening, allowed/rejected entry, prompt/error UI, and save/reopen. |
| Sorting and filtering | Simple/custom sort, table/filter flyouts, search, checklists, date/number/text filters, clear/reapply, visible rows. | Pair AutoFilter and custom-sort workflows with screenshots of flyouts and before/after visible-row state. |
| Page setup and print | Margins, orientation, size, print area, breaks, print titles, scale, background, print preview, PDF/XPS/native print. | Pair Page Setup and Print/Export passes with preview/output artifacts and native dialog focus-return proof. |
| Accessibility and traversal | Full keyboard traversal, access keys, UIA names/ids/patterns, screen-reader-friendly states, disabled command narration. | Add a keyboard-only pass per major surface and attach UIA snapshots for focus order, names, patterns, and disabled states. |

## Closeout Order

1. Keep the UX parity suite runner focused on paired Excel/FreeX capture and run manifests.
2. Use this backlog to pick the next surface family and target variants.
3. Append the completed evidence or blocker to `docs/testing/ui-test-catalog.md`.
4. If a mismatch is actionable, open a narrow parity fix task with the paired evidence paths and expected Excel behavior.
