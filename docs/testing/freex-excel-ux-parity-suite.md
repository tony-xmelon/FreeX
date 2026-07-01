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
```

The batch runner uses `tools/FreeX.ForegroundCapture` to run matching Excel and FreeX scenarios, stores per-subject manifests/screenshots under `tools/ux-parity-runs/<timestamp>/foreground-captures/`, writes `ux-scenario-batch.json` with pair status and the next review action, and generates `ux-scenario-report.html` for side-by-side visual review.
`-MinimizeForeignForeground` is intentionally narrow: it only minimizes the known Media Player foreground blocker seen on this machine during desktop automation.

Suites:

- `smoke`: Format Cells dialog and sheet-tab context-menu pairs.
- `core`: smoke coverage plus worksheet context-menu Format Cells and sheet-tab overflow Activate dialog pairs.
- `dialogs`: Format Cells and native Open/Save dialog pairs.
- `all`: all currently paired foreground scenarios.

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
| `tools/ux-parity-runs/20260702-015812/ux-scenario-batch.json` | Current strict `core` run completed 4/4 paired captures with zero partial/blocked records and wrote `ux-scenario-report.html`. The strict contact sheet is `tools/ux-parity-runs/20260702-015812/ux-core-contact-sheet-strict.png`. |

The current actionable harness gaps are:

- Keep `20260702-015812` as the strict `core` baseline, not `20260702-012034`; the latter is superseded by visual review.
- Triage the strict contact-sheet findings before marking the covered cases as parity-equivalent: FreeX Format Cells is visually/layout-wise larger than Excel and exposes extra controls in the Number tab, and the Excel overflow Activate reference appears to be a workbook/window Activate fallback while FreeX lists sheets.
- Continue hardening foreground ownership reacquisition while expanding beyond `core`; repeated desktop-driven scenarios can still produce transient foreground failures on this machine.
- Promote the generated strict contact sheet into a first-class report artifact if this evidence format becomes the standard review path.

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
