# S4/S6 Grid and Status Pointer Mechanics Inventory - 2026-06-10

Branch/worktree:

- Branch: `codex/ux-grid-status-pointer-s4-s6-20260610`
- Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\ux-grid-status-pointer-s4-s6-20260610`
- Base: local `main` at `2fde8749d5adb4ca04644a0c64810fdef4dfd713` after `git fetch origin`; local `main` was clean and not behind `origin/main`.

## Scope

This pass inventories the remaining pointer-only closeout work for:

- S4 grid pointer mechanics: drag select, autofill, row/column resize, split divider drag, split-pane mini-scrollbar/wheel routing, and Ctrl/wheel-related grid behavior.
- S6 status/footer pointer mechanics: status view shortcut buttons, zoom out/in buttons, zoom text/slider, status slider drag, Ctrl+wheel zoom, and status/footer accessibility routes.

The initial inventory made no production code changes and inspected `tools/FreeX.ForegroundCapture/Program.cs` only far enough to confirm supported scenarios. The follow-up S6 foreground expansion edits that harness to add guarded status/footer scenarios and retained artifacts.

## Existing Deterministic Coverage

| Mechanic | Existing deterministic coverage | Remaining foreground proof |
|---|---|---|
| Drag selection | `MainWindowMouseSelectionSourceTests.*` source guards cover cell/header mouse down, drag extension, Shift/Ctrl range behavior, deferred refresh, edge auto-scroll, mouse-up ordering, and lost-capture cleanup. `UI-CAT-GRID-001` also has `FREEX_GRID_SELECTION_EDITING_TOUR` deterministic selected-cell/range/row/column/filtered viewport evidence. | Live WPF click/drag with per-action foreground validation, visible selection rectangle/status stats after physical drag, Excel-paired comparison. |
| Autofill handle | `GridViewAutofillTests` covers handle hit testing, axis constraint, above/left/below/right fill ranges, completed selection ranges, drag target math, edge auto-scroll intent, and cursor source guard. `MainWindowAutofillSelectionSourceTests` verifies successful autofill selects the completed source-plus-fill range. | Physical fill-handle drag, visual fill preview, committed values/series options, edge-scroll behavior under real drag, Excel-paired comparison. |
| Row/column resize | `GridResizeHitPlannerTests`, `GridResizeSizePlannerTests`, `GridViewPointerCursorTests`, and `MainWindowMouseResizeTests` cover header edge hit bands, collapsed hidden-boundary unhide targeting, preview/commit clamp behavior including zero-size hide, double-click AutoFit routes, undo/cancel behavior, and resize capture/cursor cleanup. `docs/parity/subagent-grid-pointer-mechanics-2026-06-07.md` records the prior implementation slice and verification. | Physical resize drag and double-click AutoFit screenshots with foreground CopyFromScreen or equivalent guarded evidence; exact pixel-to-character parity still needs manual Excel pairing. |
| Split divider drag | `GridViewSplitPaneLayoutTests.HitTesting`, `GridViewSplitPaneLayoutTests.Scrollbars`, `GridViewPointerCursorTests`, `ViewportScrollCalculatorTests`, and `FREEX_VIEW_WORKFLOWS_TOUR` cover split state, divider hit testing, drag target math, split mini-scrollbars, wheel target routing, and deterministic split result/persistence captures. The View Workflows manifest intentionally records `physical-split-divider-drag` as planned-but-blocked. | Physical split-divider drag, active-pane scroll proof, split mini-scrollbar drag, synchronous scrolling/window arrangement foreground proof. |
| Status view shortcut/buttons | `StatusBarLayoutTests` covers footer view shortcut commands, F6/footer focus traversal, status zoom focus order, and stable visual alignment. `FREEX_STATUS_FOOTER_INTERACTIONS_TOUR` captures view shortcut click-result states by raising WPF button click events through production handlers. `tools/FreeX.ForegroundCapture` now retains physical foreground Zoom In and Zoom Out button click proof with UIA result validation. | Footer view shortcut physical clicks, zoom percentage/dialog physical click proof, min/max foreground breadth, and Excel-paired status button behavior remain. |
| Status zoom slider | `ZoomLevelMapperTests`, `ZoomSelectionPlannerTests`, `StatusBarLayoutTests`, `UiAutomationCatalogSnapshotTests`, `FREEX_STATUS_FOOTER_TOUR`, and `FREEX_STATUS_FOOTER_INTERACTIONS_TOUR` cover zoom range mapping, dialog/custom zoom planning, keyboard focus metadata, UIA RangeValue exposure, representative 10/100/400 slider values, and button/custom route result states. `tools/FreeX.ForegroundCapture` now retains physical slider drag proof and native UIA `RangeValue.SetValue(150)` proof with guarded foreground ownership and UIA result validation. | Shift/ordinary wheel distinctions, min/max foreground breadth, and Excel-paired status slider behavior remain. |
| Ctrl/wheel and ordinary wheel | `ViewportScrollCalculatorTests` covers normalized wheel deltas, high-resolution touchpad deltas, split-pane wheel target routing, and scrollbar extent calculations. `docs/parity/subagent-grid-pointer-mechanics-2026-06-07.md` records ordinary wheel as covered by source/calculator tests. `tools/FreeX.ForegroundCapture` now retains Ctrl+wheel-over-grid foreground proof with slider `110` and visible zoom text about `130%`. | Physical ordinary wheel, Shift-wheel, touchpad/hardware parity evidence, and Excel-paired wheel behavior remain. |

## Foreground Evidence Attempt

The only safe foreground-harness action attempted in this slice was the non-input inventory command:

```powershell
dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --list-slices
```

Result: passed and reported S4 as "Grid pointer mechanics: drag select, autofill, resize, split panes (foreground harness plus mouse drags)" and S6 as "Status/footer pointer mechanics: zoom slider, wheel, Ctrl/Shift wheel (foreground harness plus wheel input)".

No pointer drag, wheel, SendKeys, UIA Invoke, or native RangeValue input was attempted during the initial inventory because the then-current `FreeX.ForegroundCapture` scenario switch only supported these scenarios:

- `excel-autofilter`
- `excel-number-format`
- `excel-borders`
- `excel-context-menu`
- `excel-open-dialog`
- `excel-save-as-dialog`
- `freex-open-dialog`
- `freex-save-as-dialog`

Those are not S4/S6 drag or wheel scenarios. Attempting grid/status pointer proof through ad hoc global input would bypass the catalog safety rule that foreground process/title must be verified immediately before every click, drag, wheel, or key sequence.

## S6 Foreground Expansion

A follow-up S6 pass extended `tools/FreeX.ForegroundCapture` with guarded, result-validated status/footer scenarios:

| Scenario | Result |
|---|---|
| `freex-status-zoom-in-click` | Closed physical Zoom In click with slider `105` and visible zoom text about `115%`. |
| `freex-status-zoom-out-click` | Closed physical Zoom Out click with slider near `95` and visible zoom text about `96%`. |
| `freex-status-zoom-slider-drag` | Closed physical slider drag with slider movement from `100` to `90` and visible zoom text about `91%`. |
| `freex-status-zoom-slider-rangevalue-set` | Closed native UIA `RangeValue.SetValue(150)` with visible zoom text about `250%`. |
| `freex-status-ctrl-wheel-grid-zoom` | Closed Ctrl+wheel-over-grid zoom with slider `110` and visible zoom text about `130%`. |

## Remaining Blockers

- The foreground harness needs explicit FreeX grid/status scenarios that can compute target coordinates from the live WPF/UIA tree, verify FreeX owns foreground before each action, synthesize bounded drag/wheel/UIA input, and discard artifacts on any guard failure.
- S4 remains open for live drag select, fill-handle drag, resize drag/double-click AutoFit, split-divider drag, split mini-scrollbar drag, wheel/Shift-wheel, and Excel-paired screenshots.
- S6 remains open for footer view shortcut physical clicks, zoom percentage/dialog physical click proof, Shift/ordinary wheel distinctions, min/max foreground breadth, Ctrl+Alt+=/-, and Excel-paired status/footer evidence.
- Existing deterministic tours are useful result-state evidence but are not OS foreground CopyFromScreen proof; several intentionally use RenderTargetBitmap and production command/session routes instead of physical pointer input.

## Verification

- `git status --short --branch` in the primary checkout: showed unrelated dirty files on `worker-c-cf-aggregate-list-parity`; left untouched.
- `git worktree list --porcelain`: confirmed the session uses an isolated linked worktree under `.worktrees/`.
- `git fetch origin` in the local main worktree: passed; `main` remained clean and ahead only.
- `git merge main`: passed; session branch was already up to date before final verification.
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1`: passed.
- `dotnet build FreeX.slnx --configuration Release`: passed with 0 warnings and 0 errors.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"`: passed.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --list-slices`: passed; the follow-up S6 pass added explicit foreground scenarios for Zoom In/Out clicks, slider drag, native UIA RangeValue set, and Ctrl+wheel-over-grid zoom.
