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
| 1 | `20260831-093247` paired keyboard and mouse grid edit | Passed | Excel-first then FreeX: `Ctrl+PgDn`, `Ctrl+G`, `H12`, entry and save wrote the same keyboard value; UIA-bounded mouse clicks on `H14` wrote the same mouse value. Both screenshots end at the matching next-row selection, with no save warning. After clean app exit, direct package reads confirmed the same `H12` and `H14` text in each saved workbook. |
| 1 | `20260831-093247` Region filter menu | Disparity recorded | The corrected table-header clicks open comparable menus. FreeX lacks Excel's explicit `OK` and `Cancel` commit controls and differs in popup composition; see `UX-QA-ITER1-002`. |
| 2 | `20260831-093247` formula edit and cancel | Passed with visual disparities | `Ctrl+PgDn`, Go To `B2`, F2, and Escape produce the matching edit/cancel state for `=SUM(1,2,3)`. FreeX differs in edit-state name-box text and calculated-date display; see `UX-QA-ITER2-001` and `UX-QA-ITER2-002`. |
| 3 | `20260831-093247` Charts worksheet mouse navigation | Passed with rendering disparity | Exact paired mouse clicks select `Charts` in both apps. FreeX renders the embedded clustered-column chart with left-edge clipping and substantial default-style divergence; see `UX-QA-ITER3-001`. |
| 4 | `20260831-093247` File backstage keyboard entry | Disparity recorded | Exact paired `Alt+F` opens Excel's complete backstage navigation but a malformed FreeX file surface; see `UX-QA-ITER4-001`. |
| 5 | `20260831-095401` ribbon Alt keytip entry | Passed with visual/access-key disparity | Exact paired bare `Alt` exposes keytips in both apps. FreeX labels are crowded and its mnemonic map differs from Excel; see `UX-QA-ITER5-001`. |
| 6 | `20260831-095401` Home Bold keyboard command | Passed | Excel-first then FreeX: create `Grid Basics!H20`, select it, invoke `Ctrl+B`, and save. Both rendered the same bold text. After clean app exit, direct package reads confirmed the same cell text and a bold font record in both workbooks. |
| 7 | `20260831-140432` Charts worksheet repair revalidation | Failed revalidation | The merged candidate builds cleanly, but a fresh Excel-authored corpus still renders the `Revenue by region` chart clipped at its left edge in FreeX. The repair is not closed; see `UX-QA-ITER3-001`. |
| 8 | `20260831-140645` Formula edit repair revalidation | Passed | Excel-first then FreeX: navigate to `Formulas!B2`, press F2, and compare the edit state. Both show `SUM` in the Name Box and render the date row as `7/8/2026`. |
| 9 | `20260831-141009` Region AutoFilter repair revalidation | Passed | Excel-first then FreeX: navigate to `Grid Basics`, click the Region header dropdown, and inspect the popup. FreeX now exposes explicit `OK` and `Cancel` controls in its live UI tree. |
| 10 | `20260831-141209` Format Cells keyboard entry | Passed | Exact paired `Ctrl+1` opens a `Format Cells` dialog in both Excel and FreeX. Entry-state screenshots were captured; detailed tab and control comparison remains scheduled. |
| 11 | `20260831-141531` Format Cells tab inventory | Partial pass | Manifest-owned Excel and FreeX instances opened through the same `Ctrl+1` route. FreeX exposes `Number`, `Alignment`, `Font`, `Border`, `Fill`, and `Protection`; Excel's UI Automation tree did not expose its tabs, so visual tab-by-tab comparison remains required. |
| 12 | `20260831-142414` Charts worksheet anchor follow-up | Passed with residual visual disparity | The fresh FreeX chart is fully visible and no longer clips its left edge. Default title typography and gridline styling remain visually different from Excel. |
| 13 | `20260831-142604` Ctrl+End grid navigation | Passed | Excel-first then FreeX: `Ctrl+End` from `UX Overview` selects `B10` in both applications, confirmed by the UI Automation selection tree. |
