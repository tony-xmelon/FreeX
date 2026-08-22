# FreeX / Excel UX Parity Suite

**Status:** active bootstrap plus strict paired foreground core hardening  
**Started:** 2026-07-01  
**Scope:** local Windows desktop UX parity between Microsoft Excel and FreeX.

## Goal

Build an evidence-producing user testing suite that launches Microsoft Excel and FreeX side by side, opens the same workbook corpus, walks the whole visible UI surface with mouse and keyboard, records every command/dialog/grid/chrome interaction, and turns differences into tracked parity fixes.

The active Codex goal tracker now points at this UX parity workstream; this document is the durable repo-local plan and resume point for the goal.

## In Scope

- Launch Excel and FreeX on Windows against the same workbook.
- Build an Excel-authored workbook corpus that exercises formulas, tables, filtering, formatting, charts, PivotTable seed data, dialog targets, and persistence-sensitive states.
- Walk all visible surfaces: title/chrome, QAT, File/Backstage, ribbon tabs, contextual tabs, formula bar, name box, grid, sheet tabs, status bar, context menus, native dialogs, and app dialogs.
- Exercise mouse, keyboard shortcuts, keytips, access keys, Tab focus traversal, Escape/Enter cancellation/defaults, UI Automation patterns, and workbook state changes.
- Capture run manifests, screenshots, UIA/window metadata, workbook deltas, saved files, and a disparity log.
- Reuse the existing foreground capture tool, parity capture surfaces, screenshot tours, workbook fidelity tools, and Excel COM comparison tools where possible.

## Out of Scope

- Microsoft cloud services, online templates, co-authoring, identity, SharePoint-only workflows, and web-backed linked data.
- VBA/macro execution, Office Scripts, COM add-ins, and proprietary automation runtimes.
- External connections, Power Query, Data Model, and OLAP unless a later goal explicitly opts them back in.
- Worksheet Ink authoring, display, editing, and InkML/contentPart interpretation. Workbook-level Ink visibility metadata is retained, but no worksheet Ink renderer or command surface is in scope.
- Map Chart authoring and rendering. Existing package preservation remains available where possible; a future Map Chart feature requires an approved geospatial model, dataset/licensing policy, renderer, and XLSX authoring contract.

## Resume Priorities

The focused FreeX/FreeW/FreeP adaptive-ribbon pass and FreeX legacy Form Controls authoring, interaction, rendering, undo/redo, and XLSX round-trip work are complete.

Resume from evidence-producing paired foreground UX validation: capture real Excel/FreeX comparisons, log only reproducible visual or behavioral gaps, and prioritize narrow fixes to ribbon/chrome, dialogs, grid interactions, and persistence. Do not reopen Map Chart or worksheet Ink work without an explicit scope decision and the required source artifacts.

## First Runner

Run the bootstrap suite from the repository root:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-UxParitySuite.ps1
```

Useful options:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-UxParitySuite.ps1 -KeepAppsOpen
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-UxParitySuite.ps1 -Suite full -FreeXExe C:\path\to\FreeX.App.Host.exe
```

The runner writes:

- `tools/ux-parity-runs/<timestamp>/ux-parity-corpus.xlsx`
- `tools/ux-parity-runs/<timestamp>/ux-parity-run.json`

The corpus workbook currently seeds the paired walkthrough with:

- `UX Overview`
- `Grid Basics`
- `Formulas`
- `Function Inventory`
- `Feature Matrix`
- `Charts`
- `Pivot Seed`

`Function Inventory` is generated from `docs/parity/functions.md` and records every in-scope implemented function as needing paired UX evidence. Executable formula edge cases remain covered by the existing formula parity corpus; this suite adds the user-facing editing, entry, display, calculation, and interaction layer.

## Paired Scenario Batch

Run paired foreground evidence after the bootstrap has built the Release host:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-UxParityScenarioBatch.ps1 -Suite smoke
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-UxParityScenarioBatch.ps1 -Suite core -MinimizeForeignForeground
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-UxParityScenarioBatch.ps1 -Suite status -MinimizeForeignForeground
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-UxParityScenarioBatch.ps1 -Suite formula -MinimizeForeignForeground
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-UxParityScenarioBatch.ps1 -Suite filtering -MinimizeForeignForeground
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-UxParityScenarioBatch.ps1 -Suite grid -MinimizeForeignForeground
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-UxParityScenarioBatch.ps1 -Suite native-output -ListScenarios
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-UxParityScenarioBatch.ps1 -Suite native-output -AssertScenarioCoverage
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-UxParityScenarioBatch.ps1 -Suite native-output -MinimizeForeignForeground
```

The batch runner uses `tools/FreeX.ForegroundCapture` to run matching Excel and FreeX scenarios, stores per-subject manifests/screenshots under `tools/ux-parity-runs/<timestamp>/foreground-captures/`, writes `ux-scenario-batch.json` with pair status and the next review action, and generates `ux-scenario-report.html` plus `ux-scenario-contact-sheet.png` for side-by-side visual review.
`-MinimizeForeignForeground` is intentionally narrow: it only minimizes the known Media Player foreground blocker seen on this machine during desktop automation.

Suites:

- `smoke`: Format Cells dialog and sheet-tab context-menu pairs.
- `core`: smoke coverage plus worksheet context-menu Format Cells and sheet-tab overflow Activate dialog pairs.
- `dialogs`: Format Cells and native Open/Save dialog pairs.
- `status`: Excel and FreeX status/footer reference with selected numeric cells and validated Average/Count/Sum readouts.
- `formula`: Excel and FreeX formula bar/name box reference with the same selected formula cell and validated FreeX UIA readback.
- `filtering`: Excel and FreeX AutoFilter opened-state reference with the same A1:D6 seeded range; FreeX seeds the range through foreground paste, toggles AutoFilter with `Ctrl+Shift+L`, opens the score-column dropdown with `Alt+Down`, and validates the Text Filters checklist surface before capture.
- `grid`: FreeX-only foreground capture for grid pointer mechanics: row/column resize and wheel scrolling. This suite is intentionally runnable when Excel COM is unavailable; it produces FreeX workflow evidence and should be paired with Excel reference captures later on a COM-capable desktop before final parity closeout. Drag selection, autofill handle drag, and double-click autofit remain individual foreground scenarios pending screenshot-capture hardening before joining the default grid suite.
- `native-output`: guarded native Open/Save references plus FreeX WPF Save As invalid path, export cancel/overwrite/XPS, and native PrintDialog proof. Use `-ListScenarios` to emit the JSON evidence contract without building or launching foreground capture, and `-AssertScenarioCoverage` to verify the native-output catalog still declares required artifacts and explicit pending Avalonia baselines before spending an interactive desktop slot.
- `all`: all currently paired foreground scenarios.

`native-output -ListScenarios` also validates retained artifact files under `tools/foreground-captures/<scenario>/`. The catalog reports `evidenceStatus`, `nextMissingArtifact`, `missingArtifacts`, and per-subject `artifactStatuses` so stale manifests, absent screenshots, missing native output files, and pending Avalonia foreground baselines are visible before anyone treats a catalog row as parity evidence.

## Current Evidence

Latest bootstrap run retained locally under ignored artifacts:

| Run | Result |
|---|---|
| `tools/ux-parity-runs/20260701-195022/ux-parity-run.json` | `ready-for-walkthrough`; Excel 16.0 launched, FreeX launched, both opened the generated corpus workbook, and the workbook included all 488 in-scope implemented functions from `docs/parity/functions.md`. |

Foreground paired batch status:

| Run | Result |
|---|---|
| `tools/ux-parity-runs/20260701-214833/ux-scenario-batch.json` | First paired smoke batch captured Excel and FreeX Format Cells dialogs successfully, producing PNG evidence for both. Sheet-tab context-menu pair blocked on UIA lookup for `Sheet1` in both apps. |
| `tools/ux-parity-runs/20260701-215137/ux-scenario-batch.json` | Retry-enabled smoke batch captured FreeX Format Cells, but Excel Format Cells hit repeated transient foreground-guard failures; sheet-tab context-menu remained blocked on `Sheet1` UIA lookup in both apps. |
| `tools/ux-parity-runs/20260701-215944/ux-scenario-batch.json` | Report-enabled smoke batch captured Excel and FreeX Format Cells dialogs successfully and wrote `ux-scenario-report.html` with side-by-side images. Sheet-tab context-menu remained blocked on `Sheet1` UIA lookup in both apps. |
| `tools/ux-parity-runs/20260701-220538/ux-scenario-batch.json` | Sheet-tab fallback hardening run completed 2/2 paired smoke scenarios. `ux-scenario-report.html` includes side-by-side Excel/FreeX screenshots for Format Cells and sheet-tab context menus. |
| `tools/ux-parity-runs/20260702-000404/ux-scenario-batch.json` | Expanded `core` run completed 3/4 paired scenarios with side-by-side evidence for Format Cells, worksheet context-menu Format Cells, and sheet-tab context menus. Sheet-tab overflow Activate dialog remains blocked on both sides and is the next harness target. |
| `tools/ux-parity-runs/20260702-012034/ux-scenario-batch.json` | Expanded `core` run completed 4/4 paired scenarios, but visual review superseded this as a closeout artifact because the FreeX sheet-tab context-menu screenshot was actually the worksheet cell context menu. Keep the Format Cells and overflow Activate evidence; rerun sheet-tab context under the stricter validator. |
| `tools/ux-parity-runs/manual-sheet-tab-context-check4/` and `tools/ux-parity-runs/manual-overflow-check4/` | Targeted strict FreeX reruns completed after hardening: sheet-tab context-menu validation now requires sheet-tab-specific menu items, and overflow Activate completes after stable window sizing. |
| `tools/ux-parity-runs/20260702-014815/ux-scenario-batch.json` and `tools/ux-parity-runs/20260702-015039/ux-scenario-batch.json` | Strict `core` reruns still need attention. The harness no longer false-passes the wrong FreeX menu, but the desktop foreground slot later returned `No foreground window detected` for both Excel and FreeX, blocking official paired closeout. |
| `tools/ux-parity-runs/20260702-015812/ux-scenario-batch.json` | Strict `core` run completed 4/4 paired captures with zero partial/blocked records, but visual review found the Excel overflow Activate screenshot was the workbook/window Activate fallback listing `Book1`. This run is superseded for overflow Activate closeout. |
| `tools/ux-parity-runs/manual-excel-overflow-activate-strict-sheet-list-v2/` | Targeted Excel rerun completed with the real sheet-list Activate dialog through Workbook Tabs > More Sheets; the screenshot lists `Sheet1` onward and passes OK/Cancel sheet-list validation. |
| `tools/ux-parity-runs/20260702-021746/ux-scenario-batch.json` | Current strict `core` baseline completed 4/4 paired captures with zero partial/blocked records and wrote `ux-scenario-report.html`. The strict contact sheet is `tools/ux-parity-runs/20260702-021746/ux-core-contact-sheet-strict.png`. |
| `tools/ux-parity-runs/20260702-status-footer-reference-v2/ux-scenario-batch.json` | Dedicated `status` suite completed 1/1 paired capture with zero partial/blocked records after the Excel scenario validated Average/Count/Sum through the native status-bar context menu. Review artifact: `ux-scenario-contact-sheet.png`. |
| `tools/ux-parity-runs/20260702-formula-bar-name-box-reference-v3/ux-scenario-batch.json` | Dedicated `formula` suite completed 1/1 paired capture with zero partial/blocked records. Both apps select `B4` in the same seeded formula worksheet and show `=B2-B3` in the formula bar; the FreeX scenario also validates Name Box `B4` and Formula Bar `=B2-B3` through UIA before capture. Review artifact: `ux-scenario-contact-sheet.png`. |
| `tools/ux-parity-runs/20260702-core-after-dialog-fidelity/ux-scenario-batch.json` | Post-fix strict `core` run completed 4/4 paired captures after integrating the Format Cells and Activate Sheet dialog fidelity slices. The contact sheet shows Format Cells now uses Excel tab order/footprint and selected-cell General preview text, and Activate now opens a real sheet-list dialog with Excel-like OK/Cancel/default/chrome behavior. Remaining visible deltas are now narrower: FreeX Format Cells still has denser right-pane/control framing and selection highlight differences, the sheet-tab context menu still differs in scale/command set/position, and Activate still differs in list height/selection framing with fewer visible sheet rows. |
| `tools/ux-parity-runs/20260702-format-cells-density-pass/ux-scenario-batch.json` | Format Cells density pass completed 4/4 paired `core` captures with zero partial/blocked records after tightening the Number tab category list, selected highlight, sample/description framing, and OK/Cancel sizing. Visual review shows incremental improvement, but FreeX still needs additional Format Cells layout work: the context-menu route renders larger under the foreground harness/DPI capture and the right-pane whitespace/framing still does not fully match Excel. Sheet-tab context-menu and Activate deltas remain open. |
| `tools/ux-parity-runs/20260702-core-activate-list-40-pass/ux-scenario-batch.json` | Current strict `core` run completed 4/4 paired captures with zero partial/blocked records after expanding the sheet-tab overflow Activate scenario to create `Sheet2` through `Sheet40` and tightening the FreeX Activate list density. The Activate contact-sheet row now compares real Excel/FreeX sheet-list dialogs at matching `440x475` bounds with `Sheet1` through `Sheet20` visible. Remaining visible deltas are selected-row highlight tone/framing, the sheet-tab context-menu scale/command-set/position mismatch, and Format Cells right-pane/capture-geometry differences. |
| `tools/ux-parity-runs/20260702-core-after-context-and-number-pane/ux-scenario-batch.json` | Current strict `core` run completed 4/4 paired captures with zero partial/blocked records after integrating the sheet-tab context-menu state planner and Format Cells Number-pane refinements. Format Cells now has a compact fixed right pane and sample frame closer to Excel. Activate remains matched on bounds and visible row count. Remaining visible deltas are sheet-tab context-menu scale/placement, Tab Color still not matching Excel's submenu-palette behavior, Format Cells exact foreground/DPI geometry, and Activate selected-row highlight tone/framing. |

The current actionable harness gaps are:

- Keep `20260702-core-after-context-and-number-pane` as the current strict `core` baseline; `20260702-core-activate-list-40-pass` remains the pre-context-menu/Number-pane baseline, `20260702-format-cells-density-pass` remains the pre-Activate-density baseline, `20260702-core-after-dialog-fidelity` remains the pre-density-pass baseline, `20260702-021746` remains the pre-fix baseline, `20260702-012034` is superseded by the FreeX worksheet-menu false positive, and `20260702-015812` is superseded by the Excel workbook/window Activate false positive.
- Triage the current strict contact-sheet findings before marking the covered cases as parity-equivalent: FreeX Format Cells now matches Excel tab ordering and selected-cell General preview behavior and has closer Number-tab density/button sizing, but still needs visual tuning for right-pane whitespace/framing and DPI/capture geometry. The corrected Activate pair now compares real sheet-list dialogs with matching bounds, row count, label, default buttons, and context help; the remaining Activate difference is selected-row highlight tone/framing.
- Triage the `status` contact-sheet findings before closing the status bar surface: both apps show Average 5, Count 4, and Sum 20 for the same numeric selection, while FreeX also exposes Numerical Count, Min, and Max in the footer and uses a much larger capture geometry than the Excel reference.
- Triage the `formula` contact-sheet findings before closing the formula bar/name box surface: both apps now have paired B4/formula-bar visual proof, while expand/collapse, `fx` Insert Function, edit commit/cancel, reference highlighting, and invalid formula handling still need paired foreground coverage.
- Run the `filtering` suite as the next AutoFilter foreground-evidence checkpoint. It pairs the existing Excel AutoFilter opened-state scenario with the new FreeX `freex-autofilter` counterpart so filter flyouts can produce side-by-side screenshots and manifests instead of remaining only a backlog row.
- Run the `grid` suite as the next COM-independent foreground-evidence checkpoint. It exposes the reliable FreeX row/column resize and wheel-scroll validations through the batch manifest/contact-sheet flow so grid mechanics evidence can be collected even when Microsoft Excel automation is blocked.
- Before rerunning `native-output`, run `tools\Run-UxParityScenarioBatch.ps1 -Suite native-output -ListScenarios` and `-AssertScenarioCoverage` to confirm the seven native-output rows still have declared artifact expectations, visible pending Avalonia foreground-baseline debt, and explicit `nextMissingArtifact` values for any retained WPF/Excel artifact gaps. The foreground run remains necessary for actual screenshots/manifests.
- Continue hardening foreground ownership reacquisition while expanding beyond `core`; repeated desktop-driven scenarios can still produce transient foreground failures on this machine.
- Continue using `ux-scenario-contact-sheet.png` as the first-pass visual review artifact for paired scenario batches.

## Evidence Contract

Every UX parity scenario should append or link evidence in the run folder:

| Evidence | Purpose |
|---|---|
| `ux-parity-run.json` | Run environment, app paths, process IDs, workbook path, scenario statuses. |
| Excel screenshot(s) | Microsoft Excel visual/reference behavior. |
| FreeX screenshot(s) | FreeX visual behavior. |
| UIA/window metadata | Focus, automation IDs/names, patterns, disabled states, foreground ownership. |
| Workbook delta | Saved workbook, cell/range state, style state, object state, or exported output proving command results. |
| Disparity entry | Difference summary, severity, repro steps, expected Excel behavior, actual FreeX behavior, owner/fix branch. |

## Walkthrough Matrix

| Area | Required UX coverage | Existing assets to reuse |
|---|---|---|
| App launch and chrome | process launch, startup file, title, custom window buttons, system menu, QAT | `tools/Run-UxParitySuite.ps1`, `docs/testing/ui-test-catalog.md` |
| File/Backstage | New/Open/Save/Save As/Print/Export/Info/Share/Account/Options/Close, recent/pinned rows | screenshot tours, `tools/FreeX.ForegroundCapture` native dialog scenarios |
| Formula bar/name box | name navigation, formula entry, `fx`, expand/collapse, reference editing | formula screenshot tours, shortcut matrix |
| Grid | selection, edit, drag, autofill, resize, scroll, freeze/split/page layout views | `tools/FreeX.ForegroundCapture`, grid planner tests |
| Ribbon/keytips | all top-level tabs, QAT, contextual tabs, dropdowns, galleries, nested menus | `docs/parity/command-surface.md`, `docs/parity/shortcuts.md` |
| Dialogs | default values, invalid input, OK/Cancel/Escape, access keys, focus order, UIA | parity capture, dialog planner tests |
| Workbook features | formulas, tables, filters, charts, pivots, objects, comments, protection, view state | fidelity tools, screenshot tours, generated corpus |
| Visual comparison | paired captures, side-by-side images, pixel/semantic notes | `tools/FreeX.SheetGridImageCompare`, existing WPF/Avalonia parity captures |
| Disparities | triage, severity, fix branch, verification commands, evidence links | docs parity notes and UI test catalog |

## Next Work

1. Harden paired foreground batch reliability for repeated Excel focus reacquisition.
2. Promote the HTML report into a richer image contact sheet once the paired capture set is stable.
3. Expand the corpus generator from seed sheets into per-feature sheets for every supported command family and every documented formula category.
4. Add a disparity log schema and a reducer that summarizes open gaps by command family.
5. Run the foreground walkthrough in batches, serializing Excel COM and clipboard-sensitive steps.
6. Spawn implementation agents only after a disparity has a narrow non-overlapping owner area and evidence.
