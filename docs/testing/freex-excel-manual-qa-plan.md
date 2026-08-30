# FreeX / Microsoft Excel Manual UX QA Plan

**Status:** active  
**Scope:** local Windows desktop interaction parity. Microsoft cloud-only, macro, external-connection, Data Model, and OLAP workflows remain out of scope.

## Operating Rules

- Keep Excel and FreeX open together against the shared corpus, with one application on each monitor. Run every case Excel-first and then repeat the identical route in FreeX; only one application receives input at a time. Re-check foreground ownership before every synthetic click, drag, wheel, or key sequence.
- Use the same seeded workbook, selection, window state, and DPI for the Excel and FreeX half of each pair.
- A pass requires visible before/after evidence in both live windows, behavioral state validation, keyboard and mouse routes where applicable, UI Automation/focus-return proof for focusable surfaces, and a save/reopen comparison when the command changes workbook state.
- Log any mismatch as a reproducible disparity with expected Excel behavior, observed FreeX behavior, evidence paths, severity, and an isolated implementation owner. Do not send desktop input from a fixing agent.

## Sequential Iterations

| Iteration | Surface | Keyboard coverage | Mouse coverage | Required outcome | Status |
|---|---|---|---|---|---|
| 1 | Grid foundation and AutoFilter | Arrows, Shift/Ctrl selection, F2/Enter/Escape, Ctrl+Shift+L, Alt+Down, filter-menu traversal | Cell/header click, range drag, column-filter click, resize, wheel | Matching selected range, edit state, filter menu, visible rows, focus return, and screenshot pair | Active |
| 2 | Formula bar and name box | Name navigation, formula entry, F2, Enter/Escape, `fx`, expand/collapse, reference entry | Name-box/formula-bar focus, expand control, reference cell clicks | Matching formula text/result, edit mode, references, validation/error recovery | Planned |
| 3 | Workbook chrome and sheet tabs | F6 regions, Alt/keytips, Ctrl+PgUp/PgDn, Shift+F10/Menu, tab menu access keys | QAT, ribbon tab, system chrome, tab select/reorder/context/scroll/add | Matching focus cycle, command menu, tab order, dialogs, and visual states | Planned |
| 4 | File/backstage and native dialogs | Alt+F, access keys, Tab/Shift+Tab, Enter/Escape, F6 containment | Backstage navigation, recent/pinned, Open/Save/Save As/Print/Export dialogs | Matching routing, default controls, cancellation, focus return, saved/output state | Planned |
| 5 | Home, Insert, Page Layout, Formulas, Data, Review, View, Help commands | Keytips, shortcuts, menus, dialog tab order/access keys | Every implemented split button/gallery/menu/dialog command | Command result, disabled states, visuals, persistence where relevant | Planned |
| 6 | Contextual objects and feature workflows | Context-menu/menu-key, contextual keytips, object navigation | Tables, charts, PivotTables, drawings, validation, conditional formatting, filters | Matching contextual UI, object state, workbook result, save/reopen evidence | Planned |
| 7 | Accessibility, scaling, recovery | Keyboard-only traversal, screen-reader metadata, error/cancel/retry paths | DPI/resizing/scrollbars/window state | No trapped focus, correct UIA names/patterns, stable layout and recovery | Planned |

## Disparity Format

| Field | Required content |
|---|---|
| ID and severity | Stable ID, P0-P3 severity, affected surface |
| Reproduction | Workbook fixture, exact mouse and keyboard routes, expected foreground window |
| Expected / actual | Observable Excel state compared with FreeX state |
| Evidence | Paired screenshots, manifests, UIA data, workbook/output delta |
| Owner and validation | Isolated fix branch/agent, focused regression test, rerun evidence path |

## Iteration Log

| Iteration | Run | Result | Disparities / next action |
|---|---|---|---|
| 1 | `20260830-131520` paired core-corpus launch | Passed | Excel 16.0 and FreeX opened separate byte-identical Excel-authored workbooks. The 496-function core corpus has no rich-data entries, and FreeX opened the supplied workbook argument directly without an unsupported-feature dialog. |
| 2 | `20260830-131114` dynamic-array startup probe | Passed | A real Excel-authored `FILTER` workbook opened as `dynamic-array-probe - FreeX` with no unsupported-XLSX dialog in the UI Automation window tree after rich-data classification was corrected. |
| 1 | `20260830-122624` keyboard grid edit | Passed with corpus-warning divergence | Both saved copies contain `Grid Basics!H12 = Keyboard parity 001` after the matched keyboard route. The cause is now isolated to Excel's dynamic-array metadata, not a shared-file lock. |
| 1 | `20260830-131520` visual/mouse continuation | Blocked by desktop evidence harness | This execution context reported no foreground window and produced black captures for both exact window rectangles. No unguarded mouse or keyboard input was sent. Resume these cases only when the interactive desktop can be observed and foreground ownership can be asserted. |
