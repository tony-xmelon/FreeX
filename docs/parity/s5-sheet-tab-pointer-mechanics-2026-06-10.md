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
| Foreground Ctrl/Shift grouping, drag reorder, overflow Activate | `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario <scenario>` | Blocked during this checkpoint. The blocked artifact directories were discarded: Ctrl/Shift grouping had stale/empty UIA target bounds after seeding; drag reorder did not change visible tab order; overflow Activate exited before producing a valid retained foreground dialog capture. |
| Automated WPF guard | `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~MainWindowSheetTabKeyboardTests\|FullyQualifiedName~SheetTabListPlannerTests\|FullyQualifiedName~SheetTabScrollbarLayoutPlannerTests\|FullyQualifiedName~SheetTabWorkflowsScreenshotTourTests" --logger "trx;LogFileName=s5-sheet-tab-pointer-tests.trx" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` | Passed: 44/44 after clearing stale S5 `dotnet.exe`/`testhost.exe` processes from the first timed-out run. |

## Current Inventory

| Mechanic | Current WPF route | Existing evidence | Remaining blocker |
|---|---|---|---|
| Rename by double-click | `SheetTab_LabelMouseDown` checks left button and `ClickCount == 2`, then routes through `RenameSheetFromTab` and `RenameSheet`. | `SheetTabLabelDoubleClick_RenamesOnlyForLeftButton` and the S5 source guard cover the route. Existing `FREEX_SHEET_TAB_TOUR=1` captures the shared Rename Sheet dialog and focus/select-all affordance. Foreground proof is retained at `tools/foreground-captures/freex-sheet-tab-double-click-rename/freex-sheet-tab-double-click-rename_20260610_185918.png`. | Excel-paired proof remains open. |
| Drag reorder | `SheetTab_MouseLeftButtonDown` stores drag state and captures mouse; `SheetTab_MouseMove` waits for `MinimumHorizontalDragDistance`, resolves the target tab, and executes `MoveSheetCommand(fromIndex, toIndex)`; release/lost-capture clears drag state. | `SheetTabMouseMove_CancelsStaleDragWhenLeftButtonIsReleased`, `SheetTabDrag_CapturesMouseAndClearsStateOnReleaseOrLostCapture`, and the new S5 source guard cover wiring and cleanup. Existing workflow tour covers Move or Copy command-result ordering, not physical drag. | No foreground mouse-drag evidence for tab hit-testing/reorder. |
| Ctrl/Shift grouping | `UpdateGroupedSheetsForClick` reads `Keyboard.Modifiers`, uses `SheetGroupSelectionService.Toggle` for Ctrl and `SelectRange` for Shift, then refreshes grouped tab state. | `SheetTabListPlannerTests.SelectAdjacentVisibleSheetGroup_*` covers keyboard range grouping. Catalog evidence records grouped/colored tab visuals and Select All/Ungroup result states. The new S5 source guard covers pointer modifier wiring. | No foreground Ctrl-click/Shift-click evidence. |
| Overflow arrows | `SheetNavLeftBtn_Click` and `SheetNavRightBtn_Click` scroll the tab strip by `SheetTabNavScrollAmount`; right-click on either arrow opens `ActivateSheetDialog`. | `SheetTabScrollbarLayoutPlannerTests` and `MainWindowSheetTabKeyboardTests` cover narrow layout, nav visibility, add-tab clipping, and arrow alignment. Existing `FREEX_SHEET_TAB_TOUR=1` captures overflow start/middle/end states. The new S5 source guard covers click/right-click route wiring. | No foreground arrow click or right-click Activate-dialog capture. |
| Sheet-tab context menu | The tab XAML owns a `ContextMenu` with Insert, Delete, Rename, Move or Copy, View Code, Protect Sheet, Tab Color, Hide, Unhide, Select All Sheets, and Ungroup Sheets; right-click selects the tab first. | `MenuKeyOnFocusedSheetTab_OpensSheetTabContextMenuWithFocusAndAccessKeys`, `MenuKeyOnInactiveFocusedSheetTab_SelectsTabBeforeWorksheetFallback`, and `RightClickSheetTab_ClearsPreviousGroupedHighlight` cover focus/routing/selection. Existing `FREEX_SHEET_TAB_TOUR=1` captures the context menu. The new S5 source guard covers context menu handler wiring. Foreground proof is retained at `tools/foreground-captures/freex-sheet-tab-context-menu/freex-sheet-tab-context-menu_20260610_160955.png`. | Excel-paired proof for the same sheet-tab menu remains open. |

## Evidence Already Present

- `screenshots/sheet-tabs-tour/sheet_tabs_tour_manifest.json` records 10 deterministic FreeX captures for single-sheet, add-sheet, grouped/colored tabs, context menu, rename dialog, hidden/unhide, and overflow start/middle/end states.
- `screenshots/sheet-tab-workflows-tour/sheet_tab_workflows_tour_manifest.json` records submitted command/result and XLSX persistence evidence for insert, rename, move/copy, tab color, hide/unhide, select all, ungroup, save, and reopen.
- `tools/foreground-captures/freex-sheet-tab-context-menu/freex-sheet-tab-context-menu_manifest.json` records guarded foreground ownership for a physical right-click on `Sheet1`, and the retained screenshot shows the sheet-tab context menu placed by the tab strip.
- `tools/foreground-captures/freex-sheet-tab-double-click-rename/freex-sheet-tab-double-click-rename_manifest.json` records guarded foreground ownership for physical Insert Sheet clicks followed by a physical double-click on `Sheet2`, and the retained screenshot captures the foreground Rename Sheet dialog.
- The two `screenshots/` manifests explicitly state that they are `RenderTargetBitmap`/in-process evidence and do not synthesize global mouse, keyboard, double-click, right-click, or drag input.

## Remaining Blockers

- S5 still needs valid retained foreground proof for drag reorder, Ctrl/Shift tab clicks, and right-click Activate from the overflow navigation buttons.
- Microsoft Excel paired evidence for the same sheet-tab pointer flows remains open.
