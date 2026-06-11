# S5 Sheet-Tab Pointer Mechanics - 2026-06-10

Branch/worktree:

- Branch: `codex/ux-parity-s5-sheet-tab-edge-20260610b`
- Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\ux-parity-s5-sheet-tab-edge-20260610b`
- Base: local `main` at `93344cc3574b8a076fa09ac1211a8162a3182c46`

## Scope

This pass inventoried the WPF sheet-tab pointer mechanics requested for UX parity slice S5:

- Sheet tab double-click rename.
- Drag reorder.
- Ctrl/Shift tab grouping.
- Overflow left/right arrows.
- Sheet-tab context menu.

No changes were made to `tools/FreeX.ForegroundCapture/Program.cs` in the checkpoint branch; the already-integrated S5 scenarios were run and only valid retained foreground artifacts were kept.

## Guarded Evidence Attempt

| Attempt | Command | Result |
|---|---|---|
| Foreground harness capability inventory | `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --help` | Completed. The foreground capture harness now exposes `freex-sheet-tab-context-menu` for guarded sheet-tab right-click proof. |
| S5 slice inventory | `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --list-slices` | Completed. The harness lists `S5: Sheet-tab pointer mechanics: rename, reorder, grouping, overflow/context (foreground harness plus mouse drags)`, but this is only an umbrella slice marker. |
| Foreground sheet-tab context menu | `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-sheet-tab-context-menu` | Passed and retained `tools/foreground-captures/freex-sheet-tab-context-menu/freex-sheet-tab-context-menu_20260610_160955.png` plus `freex-sheet-tab-context-menu_manifest.json`. |
| Foreground sheet-tab double-click rename | `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-sheet-tab-double-click-rename` | Passed and retained `tools/foreground-captures/freex-sheet-tab-double-click-rename/freex-sheet-tab-double-click-rename_20260610_185918.png` plus `freex-sheet-tab-double-click-rename_manifest.json`. |
| Foreground sheet-tab Ctrl-click grouping | `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-sheet-tab-ctrl-click-grouping` | Passed in the third-wave S5 worker after re-resolving the target tab following the anchor click. Retained `tools/foreground-captures/freex-sheet-tab-ctrl-click-grouping/freex-sheet-tab-ctrl-click-grouping_20260610_222356.png` plus `freex-sheet-tab-ctrl-click-grouping_manifest.json`; the foreground title is `Book1 [Group] - FreeX`. |
| Foreground Ctrl/Shift grouping, drag reorder, overflow Activate | `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario <scenario>` | Blocked during this checkpoint. The blocked artifact directories were discarded: Ctrl/Shift grouping had stale/empty UIA target bounds after seeding; drag reorder did not change visible tab order; overflow Activate exited before producing a valid retained foreground dialog capture. |
| Automated WPF guard | `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~MainWindowSheetTabKeyboardTests\|FullyQualifiedName~SheetTabListPlannerTests\|FullyQualifiedName~SheetTabScrollbarLayoutPlannerTests\|FullyQualifiedName~SheetTabWorkflowsScreenshotTourTests" --logger "trx;LogFileName=s5-sheet-tab-pointer-tests.trx" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` | Passed: 44/44 after clearing stale S5 `dotnet.exe`/`testhost.exe` processes from the first timed-out run. |

## Current Inventory

| Mechanic | Current WPF route | Existing evidence | Remaining blocker |
|---|---|---|---|
| Rename by double-click | `SheetTab_LabelMouseDown` checks left button and `ClickCount == 2`, then routes through `RenameSheetFromTab` and `RenameSheet`. | `SheetTabLabelDoubleClick_RenamesOnlyForLeftButton` and the S5 source guard cover the route. Existing `FREEX_SHEET_TAB_TOUR=1` captures the shared Rename Sheet dialog and focus/select-all affordance. Foreground proof is retained at `tools/foreground-captures/freex-sheet-tab-double-click-rename/freex-sheet-tab-double-click-rename_20260610_185918.png`. | Excel-paired proof remains open. |
| Drag reorder | `SheetTab_MouseLeftButtonDown` stores drag state and captures mouse; `SheetTab_MouseMove` waits for `MinimumHorizontalDragDistance`, resolves the target tab, and executes `MoveSheetCommand(fromIndex, toIndex)`; release/lost-capture clears drag state. | `SheetTabMouseMove_CancelsStaleDragWhenLeftButtonIsReleased`, `SheetTabDrag_CapturesMouseAndClearsStateOnReleaseOrLostCapture`, and the new S5 source guard cover wiring and cleanup. Existing workflow tour covers Move or Copy command-result ordering, not physical drag. | No foreground mouse-drag evidence for tab hit-testing/reorder. |
| Ctrl/Shift grouping | `UpdateGroupedSheetsForClick` reads `Keyboard.Modifiers`, uses `SheetGroupSelectionService.Toggle` for Ctrl and `SelectRange` for Shift, then refreshes grouped tab state. | `SheetTabListPlannerTests.SelectAdjacentVisibleSheetGroup_*` covers keyboard range grouping. Catalog evidence records grouped/colored tab visuals and Select All/Ungroup result states. The S5 source guard covers pointer modifier wiring. Foreground Ctrl-click grouping proof is retained at `tools/foreground-captures/freex-sheet-tab-ctrl-click-grouping/freex-sheet-tab-ctrl-click-grouping_20260610_222356.png`. | Foreground Shift-click range grouping remains open. |
| Overflow arrows | `SheetNavLeftBtn_Click` and `SheetNavRightBtn_Click` scroll the tab strip by `SheetTabNavScrollAmount`; right-click on either arrow opens `ActivateSheetDialog`. | `SheetTabScrollbarLayoutPlannerTests` and `MainWindowSheetTabKeyboardTests` cover narrow layout, nav visibility, add-tab clipping, and arrow alignment. Existing `FREEX_SHEET_TAB_TOUR=1` captures overflow start/middle/end states. The new S5 source guard covers click/right-click route wiring. | No foreground arrow click or right-click Activate-dialog capture. |
| Sheet-tab context menu | The tab XAML owns a `ContextMenu` with Insert, Delete, Rename, Move or Copy, View Code, Protect Sheet, Tab Color, Hide, Unhide, Select All Sheets, and Ungroup Sheets; right-click selects the tab first. | `MenuKeyOnFocusedSheetTab_OpensSheetTabContextMenuWithFocusAndAccessKeys`, `MenuKeyOnInactiveFocusedSheetTab_SelectsTabBeforeWorksheetFallback`, and `RightClickSheetTab_ClearsPreviousGroupedHighlight` cover focus/routing/selection. Existing `FREEX_SHEET_TAB_TOUR=1` captures the context menu. The new S5 source guard covers context menu handler wiring. Foreground proof is retained at `tools/foreground-captures/freex-sheet-tab-context-menu/freex-sheet-tab-context-menu_20260610_160955.png`. | Excel-paired proof for the same sheet-tab menu remains open. |

## Evidence Already Present

- `screenshots/sheet-tabs-tour/sheet_tabs_tour_manifest.json` records 10 deterministic FreeX captures for single-sheet, add-sheet, grouped/colored tabs, context menu, rename dialog, hidden/unhide, and overflow start/middle/end states.
- `screenshots/sheet-tab-workflows-tour/sheet_tab_workflows_tour_manifest.json` records submitted command/result and XLSX persistence evidence for insert, rename, move/copy, tab color, hide/unhide, select all, ungroup, save, and reopen.
- `tools/foreground-captures/freex-sheet-tab-context-menu/freex-sheet-tab-context-menu_manifest.json` records guarded foreground ownership for a physical right-click on `Sheet1`, and the retained screenshot shows the sheet-tab context menu placed by the tab strip.
- `tools/foreground-captures/freex-sheet-tab-double-click-rename/freex-sheet-tab-double-click-rename_manifest.json` records guarded foreground ownership for physical Insert Sheet clicks followed by a physical double-click on `Sheet2`, and the retained screenshot captures the foreground Rename Sheet dialog.
- `tools/foreground-captures/freex-sheet-tab-ctrl-click-grouping/freex-sheet-tab-ctrl-click-grouping_manifest.json` records guarded foreground ownership for physical Insert Sheet clicks, a physical Sheet1 anchor click, and a physical Ctrl-click on `Sheet3`; the retained screenshot captures `Book1 [Group] - FreeX` with grouped sheet-tab styling.
- The two `screenshots/` manifests explicitly state that they are `RenderTargetBitmap`/in-process evidence and do not synthesize global mouse, keyboard, double-click, right-click, or drag input.

## Remaining Blockers

- S5 still needs valid retained foreground proof for drag reorder, Shift-click tab range grouping, and right-click Activate from the overflow navigation buttons.
- Microsoft Excel paired evidence for the same sheet-tab pointer flows remains open.

## 2026-06-11 Integration Rerun

The fourth-wave S5 pass added a product fix for sheet-tab drag hit testing under mouse capture and foreground harness entries for more FreeX/Excel sheet-tab routes. After integration, the following foreground scenarios were rerun:

Closed with retained evidence:

- `freex-sheet-tab-shift-click-grouping`: complete. Retained `tools/foreground-captures/freex-sheet-tab-shift-click-grouping/freex-sheet-tab-shift-click-grouping_20260611_003104.png` plus manifest. The validation records physical Insert Sheet clicks, Sheet1 anchor selection, and physical Shift+click on Sheet5, with the title `Book1 [Group] - FreeX`.
- `excel-sheet-tab-context-menu`: complete. Retained `tools/foreground-captures/excel-sheet-tab-context-menu/excel-sheet-tab-context-menu_20260611_004008.png` plus manifest. The validation records Microsoft Excel's sheet-tab context menu after a physical right-click on Sheet1.

Still blocked with retained manifests:

- `freex-sheet-tab-grouped-commands`: blocked by a UIA/COM `E_UNEXPECTED` failure during the grouped-command foreground path.
- `freex-sheet-tab-drag-reorder`: blocked because validation still observed `Sheet1, Sheet2, Sheet3, Sheet4` after the drag, so the product/harness route did not prove reorder.
- `freex-sheet-tab-overflow-activate-dialog`: blocked because the Activate Sheet dialog was not detected after right-clicking the overflow navigation button.
- `excel-sheet-tab-overflow-activate-dialog`: blocked because Excel's Activate dialog was not detected after right-clicking the sheet-tab navigation button in this Office state.

Remaining S5 work is now drag reorder, grouped-command foreground proof, Activate dialog proof on both FreeX and Excel, and broader Excel pairing beyond the retained Excel context-menu reference.

## 2026-06-11 Sheet-Tab Hardening Rerun

The next S5 checkpoint added product/harness hardening before rerunning the blocked foreground scenarios:

- Sheet-tab drag preserves drag state through tab refresh and recaptures the refreshed tab element.
- Drag hit-testing falls back to tab bounds when `InputHitTest` misses under mouse capture.
- Grouped-command menu invocation handles UIA/COM failures more defensively.
- The drag-reorder harness drags deeper into the target tab.
- FreeX/Excel Activate dialog lookup now uses a stricter shared detector, and sheet-nav button lookup is anchored to sheet-tab bounds.

Verification before rerun:

```powershell
dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
dotnet build tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
```

Both builds passed with 0 warnings and 0 errors.

Rerun outcomes:

- `freex-sheet-tab-grouped-commands`: still blocked. The grouped sheet-tab context menu opened, but the harness could not invoke `Ungroup Sheets`.
- `freex-sheet-tab-drag-reorder`: still blocked, but improved. The observed order changed to `Sheet1, Sheet2, Sheet4, Sheet3`; the drag now moves Sheet4, but not before Sheet2 as expected.
- `freex-sheet-tab-overflow-activate-dialog`: still blocked because the Activate Sheet dialog was not detected after right-clicking the overflow navigation button.
- `excel-sheet-tab-overflow-activate-dialog`: still blocked because Excel's Activate dialog was not detected after right-clicking the sheet-tab navigation button in this Office state.

The retained manifests in each scenario folder reflect these latest blockers. S5 remains open for the three hard interaction proofs: grouped context command invocation, exact drag insertion targeting, and Activate-dialog detection on FreeX/Excel.

## 2026-06-11 Blocker Closeout Prep

This S5 pass did not launch foreground scenarios because the desktop slot was not released. It added bounded product and harness changes aimed at the latest retained blockers:

- Right-clicking a tab that is already part of a multi-sheet group now keeps the group active while making the clicked tab current, so the grouped context menu can still invoke `Ungroup Sheets`.
- Sheet-tab drag reorder now computes insertion from the target tab half. Dragging left across the right half of an intermediate tab remains a no-op, while dropping into the left half inserts before that target.
- FreeX sheet-nav right-click now marks the mouse event handled before asynchronously opening the Activate Sheet dialog, avoiding nested right-button input while the dialog opens.
- The S5 foreground Activate scenarios now retry plausible sheet-nav button candidates and detect Activate dialogs by title or by a sheet list plus OK/Cancel controls.

Non-foreground verification:

```powershell
dotnet build tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~MainWindowSheetTabKeyboardTests" --logger "trx;LogFileName=s5-sheet-tab-keyboard-tests.trx" --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
```

The foreground blockers remain pending live rerun: grouped command invocation, exact drag insertion proof, and FreeX/Excel Activate-dialog capture.

## 2026-06-11 S5D Closeout

The S5D branch `codex/s5d-sheet-tabs-foreground-20260611` closed the remaining FreeX sheet-tab foreground blockers and was merged to local `main` as `87a76ce56` (`Merge S5 sheet tab foreground parity`).

Closed with retained foreground evidence:

- `freex-sheet-tab-grouped-commands`: complete. Validation records physical Insert Sheet clicks, `Select All Sheets`, grouped title `Book1 [Group] - FreeX`, `Ungroup Sheets`, and final title `Book1 - FreeX`.
- `freex-sheet-tab-drag-reorder`: complete. Validation records physical drag of `Sheet4` onto `Sheet2` and visible order `Sheet1, Sheet4, Sheet2, Sheet3`.
- `freex-sheet-tab-overflow-activate-dialog`: complete. Validation records physical right-click on the real overflow navigation button and capture of the foreground `Activate` dialog.
- `freex-sheet-tab-overflow-nav-click`: complete after the same forced-overflow setup.

User-supplied Excel evidence on 2026-06-11 validated the native Excel sheet-tab overflow `Activate` dialog. The screenshot shows title `Activate`, the `Activate:` list, sheet entries through `Sheet14`, `Sheet14` selected, and `OK`/`Cancel` buttons. The retained Excel foreground manifest remains blocked only because the harness did not detect that dialog through UIA/coordinate/built-in-dialog routes in this Office state.
