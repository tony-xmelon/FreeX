# Command Source Remaining Audit - 2026-06-08

## Scope

Worker audit for remaining ribbon and context command families that are not already covered by focused `docs/parity/subagent-*` notes. This pass compared:

- `docs/parity/command-inventory.json`
- existing `docs/parity/subagent-*.md` notes
- `tests/FreeX.App.Host.Tests/*CommandSourceTests.cs`
- `tests/FreeX.App.Host.Tests/*SourceHygiene*.cs`
- broad catalog guards such as `RibbonTabParityTests`, `RibbonXamlCatalogSnapshotReaderTests`, `RibbonDisabledCommandGuardrailTests`, and worksheet context-menu planner/source tests

Product files were not edited.

## Already documented by focused subagent notes

| Family | Current note | Status |
|---|---|---|
| Insert chart/chartEx source and picker routing | `subagent-insert-charts-2026-06-07.md` | Documented with focused tests. |
| Contextual Table Design and PivotTable Analyze/Design slice | `subagent-contextual-table-pivot-ribbons-2026-06-07.md` | Documented with focused tests. |

## Existing command-source guard coverage

| Family | Guard status | Notes |
|---|---|---|
| Home ribbon | Covered by focused Home `*CommandSourceTests` for clipboard, font, alignment, number, styles, cells, editing, Format as Table, borders, and related handlers. | Remaining work is mostly behavioral/live UI evidence, not command-source discovery. |
| Insert non-chart commands | Covered by `InsertCommandSourceTests`; chart-specific coverage is documented separately. | Pivot/table/slicer/timeline command-source entries are guarded, but full end-to-end parity proof remains broader UI/catalog work. |
| Draw/object commands | Covered by `DrawCommandSourceTests` and object source-hygiene helpers. | Needs live object-selection and rendering evidence, not more source metadata guards. |
| Page Layout | Covered by `PageLayoutCommandSourceTests` for primary buttons, menus, sheet-option toggles, and handler routing. | Background/header-footer/page setup behavior remains live parity/catalog work. |
| Formulas function library and defined names | Covered by `FormulaCommandSourceTests`. | This pass added read-only guards for formula auditing and calculation command metadata. |
| Data sort/filter | Covered by `DataCommandSourceTests`. | Other Data families still need focused source guards, listed below. |
| Review | Covered by `ReviewCommandSourceTests` for proofing/accessibility, comments/notes, protection/share, and handler routing. | Remaining gaps are protected-state/live dialog evidence. |
| View | Covered by `ViewCommandSourceTests`. | Out of write scope for this worker; leave view-tab residual work to its owner. |
| Help | Covered by `HelpCommandSourceTests`. | Help/about/legal residual work is already owned elsewhere. |
| Contextual PivotTable tabs | Covered by `PivotAnalyzeCommandSourceTests` and `PivotDesignCommandSourceTests`; documented by the contextual subagent note. | PivotTable localization/context residual branches are active; avoid overlap. |
| Table Design contextual tab | Covered by `TableDesignCommandSourceTests`; documented by the contextual subagent note. | Slicer-on-table absence remains documented as a product gap. |
| Worksheet context menu | Covered broadly by `WorksheetContextMenuPlannerTests.*` plus catalog rows. | Still lacks a concise parity note tying source routes to the 50-command right-click/Shift+F10/Menu-key family. |

## Remaining focused command-source gaps

| Priority | Family | Missing focused test/doc | Suggested low-risk next guard |
|---|---|---|---|
| P1 | Data tab non-filter families | `DataCommandSourceTests` currently focuses on sort/filter and unsupported Queries & Connections. The source audit still lacks a single focused guard for Text to Columns, Remove Duplicates, Data Validation, Consolidate, Goal Seek, Scenario Manager, Data Table, Forecast Sheet, Refresh All, Subtotal, Group/Ungroup, and Show/Hide Detail command metadata and handler routing. | Add a `DataCommandSourceTests` slice that reads only `MainWindow.xaml`, `MainWindow.DataCommands.cs`, and `MainWindow.OutlineCommands.cs`. Keep Get Data/import source assertions out of scope because data-import workers are active. |
| P1 | Worksheet context menu family | Existing planner tests prove the catalog count and common routing, but no subagent parity note explains the full context command-source surface and remaining target-state gaps. | Add a short `docs/parity/subagent-worksheet-context-command-source-*.md` note, or extend an existing context-menu row in the UI catalog after a focused source audit. |
| P2 | QAT/title-bar command family | QAT Save/Undo/Redo and customization are represented in inventory/catalog tests, but there is no focused parity note for direct QAT command metadata, QAT customization command context menus, and add/remove/reset/import/export routing. | Add a dedicated QAT source guard if no active QAT branch owns it; avoid Backstage/Options overlap unless coordinated. |
| P2 | File/Backstage command family | Backstage source-hygiene tests exist, but there is no focused `BackstageCommandSourceTests` equivalent documenting New/Open/Save/Save As/Print/Export/Info/Share/Account command-source parity. | Do not start from this branch because Backstage is explicitly out of this worker's write scope. Leave a focused note/test to the Backstage residual owner. |
| P2 | Page Layout residual doc | Source tests exist, but there is no focused parity note summarizing command-source coverage versus live page setup/export/manual-dialog gaps. | Add a doc-only note once active print/export/Page Layout residual branches settle. |
| P2 | Insert objects/sparklines/link/text/symbol/comment doc | Source tests exist and chart work is documented separately, but non-chart Insert families lack a concise command-source parity note. | Doc-only summary is enough unless future audit finds an unguarded XAML command. |
| P3 | Status bar and sheet-tab adjacent command surfaces | Sheet tabs are intentionally out of this worker scope and source-hygiene tests exist; status bar is not a ribbon/context command family but shares command-source parity concerns for zoom/view controls. | Defer to sheet-tab/status-footer residual owners. |

## Guard added in this pass

Added read-only source coverage in `FormulaCommandSourceTests` for:

- Formula Auditing: Trace Precedents, Trace Dependents, Remove Arrows, Show Formulas, Error Checking, Evaluate Formula, and Watch Window.
- Calculation: Calculate Now, Calculate Sheet, Calculation Options.

This closes the Formulas command-source metadata hole without touching product behavior.

## Remaining non-source parity work

These are not command-source audit blockers, but they still need broader evidence before Excel visual parity can be considered complete:

- live mouse/keytip/UIA activation for backstage/native dialogs and system-dependent flows;
- target-breadth proof for Data Tools, Outline, worksheet context menus, QAT customization, and object/contextual commands;
- visual evidence for dialogs, galleries, dropdowns, contextual tabs, object handles, and print/export output;
- persistence and undo/repeat proof for commands that mutate workbook state.
