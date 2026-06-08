# Whole-Ribbon Visual Parity Coverage Audit - 2026-06-08

## Scope

This audit maps the current Microsoft Excel visual parity effort across the FreeX ribbon and adjacent interactive spaces. It is intentionally documentation-only: no production files were changed, and sibling worktrees were inspected only as evidence.

Repository state used for this audit:

- Audit branch: `codex/ribbon-coverage-audit-20260608`.
- Base: local integration `main` at `476fd8ca1` after `git fetch origin main`; local `main` remained `ahead 80` of `origin/main`.
- Primary checkout was left untouched because it was on `worker-c-cf-aggregate-list-parity` with an unrelated dirty Core.IO test.
- Excel presence check: `C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE` exists.
- FreeX executable check in this fresh audit worktree: Release and Debug `FreeX.App.Host.exe` outputs were absent, so no fresh live FreeX/Excel launch was run in this low-risk docs slice. Existing live evidence and tool findings from sibling parity branches are recorded below.

The current structured command inventory reports no `Not Implemented` in-scope command rows: 173 Implemented, 26 Partial, 25 Excluded across File/Backstage, QAT, Home, Insert, Draw, Page Layout, Formulas, Data, Review, View, Sheet Tabs, and Help. That inventory is command-surface coverage, not visual/workflow parity coverage. The remaining work is mostly live popup/dialog/context/target evidence, plus a few known product gaps.

## Ownership Legend

| State | Meaning |
|---|---|
| Addressed | A sibling branch or parent integration has documented and implemented a bounded fix or coverage improvement. |
| Active owner | A live agent/worktree is currently editing this area; do not duplicate its write scope. |
| Candidate branch | A branch exists with useful work, but it is not listed as an active owner in this audit context or is awaiting parent integration. |
| Unassigned gap | No current owner was identified; good candidate for the next subagent. |

## Coverage Matrix

| Surface | Current state | Evidence / owner | Remaining work that accelerates the parent |
|---|---|---|---|
| Visual evidence harness | Addressed | `codex/visual-evidence-harness-20260608` / parent integrated harness docs; `docs/parity/subagent-visual-evidence-harness-2026-06-07.md` | Unassigned: popup, dropdown, context-menu, native-dialog capture flows; pixel/layout diff scoring; artifact-to-catalog attachment beyond manifest metadata. |
| App shell, titlebar, QAT | Active owner | `codex/titlebar-qat-parity-20260608` has dirty docs/tests and titlebar/QAT XAML work. `codex/view-chrome-status-parity-20260607` also touches QAT/status/View and should wait for coordination. | After owner lands: live native window drag, Alt+Space/system menu, mouse minimize/maximize/close, dirty marker clearing when undo returns to saved state. |
| Formula bar and Name Box | Active owner | `codex/formula-bar-name-box-parity-20260608` has dirty docs/tests adding cancel/accept affordances, fx UIA metadata, and Name Box focus selection. | After owner lands: foreground mouse focus proof, formula reference highlight screenshots, F2/Ctrl+F2 and formula-bar accept/cancel visual comparison against Excel. |
| File / Backstage | Addressed | `codex/backstage-file-persistence-parity-20260608`; parent-integrated Save existing path/start-screen behavior; older `subagent-sheettabs-backstage-2026-06-07.md` covers sheet-tab/backstage adjacency. | Unassigned: guarded native Open/Save/Save As dialogs, print dialog/export save dialog, recent/pinned row context menu live clicks, PDF/XPS output inspection tied to UI action. |
| Home - Clipboard / Editing | Addressed | `subagent-home-editing-clipboard-2026-06-07.md`; parent preserved copy marquee after internal paste and retained cut-mode clearing. | Unassigned: live Paste dropdown, real Ctrl+V clipboard formats, persistent Format Painter double-click/Escape, mouse/keytip coverage for Clear/Fill/Find/Go To menus. |
| Home - Font / Alignment / Number / Styles | Addressed | Home number/formatting parent integration; command-source tests for compact number dropdown, Accounting/Comma style, Merge dropdown; catalog rows UI-CAT-HOME-002/003. | Unassigned: visual swatches/galleries, border drawing by actual mouse, Format Cells visual tab order, conditional-format gallery screenshots, save/load proof connected to UI action. |
| Home - Cells / grid sizing | Active parent owner | Parent is integrating `codex/grid-collapsed-boundary-unhide-20260608`; parent already has zero-size pointer resize work from grid pointer mechanics. | Do not assign until parent finishes. Afterwards: live row/column hidden-boundary drag unhide, AutoFit double-click evidence, F4 repeat against rows/columns/sheets. |
| AutoFilter dropdown / filter button | Parent-owned history plus remaining gap | Original task fixed direction: FreeX ribbon Filter button should toggle Excel-like AutoFilter headers rather than open the modal dialog; parent catalog notes mention borderless modeless flyout and hidden Filter by Color when no color choices exist. | Unassigned after parent settles: actual Excel-like filter flyout screenshot parity, per-column predicate state so clearing one column preserves other columns, foreground-safe Alt+Down/menu keyboard proof. |
| Insert - Tables / PivotTables | Partially addressed, still unassigned for live workflows | `subagent-contextual-table-pivot-ribbons-2026-06-07.md`; slicer/timeline branch `codex/sparkline-slicer-timeline-parity-20260608`; UI-CAT-INSERT-001 remains `Not Started` in current catalog. | High-priority unassigned: end-to-end Insert Table and PivotTable workflows, field-list drag/drop, field button menus, source/placement dialog focus, PivotTable context visibility after real selection. |
| Insert - Charts / Sparklines | Addressed | Insert chart branch integrated in parent; contextual Chart Design/Format tabs are now integrated in the aggregate branch. | Unassigned: live advanced chart picker mutation/render evidence, chart object selection handles, Select Data/Move Chart mutation, chart sheet behavior, Combo category representation, Map remains deferred/hidden. |
| Insert - Objects / links / text | Addressed plus active Draw owner | `subagent-insert-objects-2026-06-07.md` covers natural-size picture insertion and object routing. Draw/object owner is active on object interactions. | Unassigned: Symbol picker mouse/keyboard, Header/Footer visual flow, Hyperlink dialog plus Ctrl+click navigation, picture/shape/text-box insertion by real ribbon click. |
| Draw / object formatting | Active owner | `codex/draw-objects-parity-20260608` has dirty Draw docs/tests and production edits; earlier doc notes stable UIA metadata and picture-aware size/rotation routing. | Do not duplicate. Remaining by owner doc: ink authoring intentionally excluded, gradients/effects partial versus galleries, picture fill/outline not modeled, Selection Pane visuals partial. |
| Page Layout | Addressed | `codex/page-layout-ribbon-parity-20260607`; parent has Page Layout state; focused tests passed 150/150 in parent context. | Unassigned: Add to Print Area, full Scale to Fit spinner/dropdown/calculated percent behavior, background visual parity, live page layout/page break screenshots, print/export smoke. |
| Formulas - names/function authoring | Candidate branch / likely incomplete | Existing model tests and Formula Bar owner cover some authoring. `codex/formula-names-evaluate-parity-20260607` has dirty Paste Names / command-source work but is not listed as active. | Unassigned unless that branch resumes: Paste Names dialog, Name Manager/Define Name/Create from Selection live dialog focus, Insert Function UIA versus mouse parity, saved/reloaded names from UI actions. |
| Formulas - auditing/diagnostics | Candidate branches | `codex/formula-auditing-parity-20260608` committed trace arrow parity work; Remove Arrows branch was superseded by parent kind-based implementation. | Unassigned after parent decision: integrate/reconcile trace-arrow branch if desired, live Formula Auditing arrows, Show Formulas visual toggle, Error Checking/Evaluate Formula modal flow, Watch Window add/delete/refresh by mouse/keyboard. |
| Data - import/refresh | Active owner | `codex/data-import-refresh-parity-20260608` has dirty docs/tests/XAML for Get Data/Refresh All metadata and honest import help text. | Do not duplicate. Remaining by owner doc: no dedicated Excel-style Get Data dropdown, From Text/CSV subcommand, recent sources, connections pane, database/web/Power Query connectors. |
| Data - sort/filter/tools/outline | Addressed plus gaps | `subagent-data-sort-outline-scenarios-2026-06-07.md`; AutoFilter planner/dialog tests; catalog UI-CAT-DATA-001/002/003. | Unassigned: Quick Sort ribbon wiring noted in data slice, Data Validation owner boundary was left open, live Text to Columns/Remove Duplicates/Advanced Filter range-picker flows, outline buttons and grouped row/column screenshots. |
| Review - proofing/comments/protection | Active plus completed branch | `codex/review-proofing-comments-parity-20260608` committed stable Review proofing/comment UIA and accessibility OK fix. `codex/review-comments-protection-20260608` has dirty comment-list/protection/password work; `codex/review-protection-parity-20260607` also dirty. | Do not duplicate active Review protection/comment files. Remaining: live proofing/accessibility/comment list workflows, Allow Edit Ranges full Excel dialog gap, XLSX advanced protection hash prompt verification, excluded Thesaurus/Smart Lookup/Translate/Track Changes should stay documented. |
| View tab / status bar / footer | Candidate branch, overlaps titlebar/QAT | `codex/view-chrome-status-parity-20260607` passed full UI lane in its worktree but overlaps active titlebar/QAT and status/View. | Wait for titlebar/QAT coordination. Remaining: live status zoom slider/buttons, split-pane drag, freeze/page-layout visual proof, Custom Views round trip, multi-window side-by-side/arrange screenshots. |
| Help / About / Legal | Addressed | `codex/help-about-legal-parity-20260608`; parent integrated Help/Legal UIA metadata and tests. | Unassigned: live browser allow/block behavior, About message-box focus return, Legal Notices visual screenshots. |
| Contextual Table / Pivot / Chart tabs | Partially addressed | Table/Pivot contextual doc is in main; slicer/timeline integrated in parent; Chart Design/Format affordances are now parent-integrated. | Unassigned: true embedded chart object selection and chart-element selection, table-connected slicer command, Pivot field expand/collapse active-field commands, contextual tab screenshot evidence with real object selections. |
| Sheet tabs | Addressed | `subagent-sheettabs-backstage-2026-06-07.md`; focused sheet-tab keyboard/dialog/planner tests passed in parent context. | Unassigned: live pointer-only tab drag reorder, cross-workbook/new-workbook Move or Copy, tab-scroll arrow right-click Activate dialog screenshots. |
| Worksheet context menus | Partially addressed | Catalog UI-CMD-CONTEXT-006; Draw owner is tightening object-target context routing. | Unassigned: live right-click/Menu routing for table, filtered range, chart, PivotTable, protected sheet, and edit-mode states. |
| Cross-target command matrix | Unassigned gap | Catalog UI-CMD-TARGET-001 is `Not Started`. | Highest-value new subagent: run representative command families across cell, range, whole row/column, table, filtered range, PivotTable, chart, drawing object, protected sheet, hidden row/column, and grouped sheets; record unsupported targets explicitly. |
| Dialog keyboard/accessibility sweep | Unassigned gap | Catalog UI-CMD-DIALOG-001 is `In Progress`; many parser/planner tests exist. | Systematic live default-focus, Tab order, access-key collision, Enter/Escape, UIA pattern, and focus-return sweep for modal/modeless dialogs. |

## Recommended Next Subagents

1. Popup/dropdown visual capture harness: extend the evidence harness for ribbon dropdowns, filter flyouts, context menus, and native dialogs before broad live parity sweeps continue.
2. Cross-target matrix executor: take UI-CMD-TARGET-001 and produce a target-by-command-family pass/fail sheet for parent triage.
3. Insert Table/Pivot live workflows: UI-CAT-INSERT-001 is still the cleanest unassigned ribbon lane.
4. Formulas names/auditing live workflows: reconcile the existing candidate branches, then verify Name Manager/Paste Names/Evaluate/Watch Window/trace arrows visually.
5. Page Layout print/export visuals: Add to Print Area plus live page-layout/page-break/print-preview/export smoke.
6. AutoFilter flyout parity: after parent finishes the filter-button behavior and grid work, compare the FreeX flyout to Excel with actual data/filter criteria.

## Coordination Notes

- Avoid production edits in Formula Bar/Name Box, Titlebar/QAT, Data Import/Refresh, Draw/Object, Review protection/comments, and Grid pointer/unhide until those owners complete or hand off.
- Do not merge `codex/view-chrome-status-parity-20260607` without checking the active Titlebar/QAT branch because both touch shell chrome/QAT-adjacent surfaces.
- Do not import the older Formula Remove Arrows implementation wholesale; parent already has the kind-based Remove Arrows behavior.
- Chart contextual tabs are useful but need careful integration because the branch adds contextual tab visibility inferred from active visible charts, not true chart-object selection.
- The command inventory's 100% in-scope coverage should not be used as a closeout signal for this effort. The closeout signal should be live or source-guarded evidence per UI-CAT/UI-CMD row, plus explicit exclusions for Microsoft cloud/proprietary features.
