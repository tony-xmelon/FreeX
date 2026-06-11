# Foreground Pointer Harness Evidence - 2026-06-10

Branch/worktree:

- Branch: `codex/ux-parity-foreground-pointer-harness-20260610`
- Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\main-integration-20260607b`
- Base: local `main` at `38ca94b99` after S1/S3/S5/S8 documentation and test checkpoints were integrated.

## Scope

This checkpoint extends `tools\FreeX.ForegroundCapture` beyond dialogs and popups into guarded FreeX pointer input. Each scenario launches a harness-owned FreeX process, verifies that the foreground window belongs to that process and has a FreeX title, performs bounded mouse input, then captures the owning window with `CopyFromScreen`.

## Captures Retained

| Scenario | Slice | Result | Evidence |
|---|---|---|---|
| `freex-status-zoom-in-click` | S6 | Complete foreground proof for physical status Zoom In button click; UIA result validation records slider `105` and visible zoom text about `115%`. | `tools/foreground-captures/freex-status-zoom-in-click/freex-status-zoom-in-click_20260610_170919.png`, `freex-status-zoom-in-click_manifest.json` |
| `freex-status-zoom-out-click` | S6 | Complete foreground proof for physical status Zoom Out button click; UIA result validation records slider near `95` and visible zoom text about `96%`. | `tools/foreground-captures/freex-status-zoom-out-click/freex-status-zoom-out-click_20260610_170615.png`, `freex-status-zoom-out-click_manifest.json` |
| `freex-status-zoom-slider-drag` | S6 | Complete foreground proof for physical status zoom slider drag; UIA result validation records slider movement from `100` to `90` and visible zoom text about `91%`. | `tools/foreground-captures/freex-status-zoom-slider-drag/freex-status-zoom-slider-drag_20260610_170816.png`, `freex-status-zoom-slider-drag_manifest.json` |
| `freex-status-zoom-slider-rangevalue-set` | S6 | Complete foreground proof for native UIA `RangeValue.SetValue(150)` on the status zoom slider; result validation records visible zoom text about `250%`. | `tools/foreground-captures/freex-status-zoom-slider-rangevalue-set/freex-status-zoom-slider-rangevalue-set_20260610_170649.png`, `freex-status-zoom-slider-rangevalue-set_manifest.json` |
| `freex-status-ctrl-wheel-grid-zoom` | S6 | Complete foreground proof for Ctrl+wheel over the worksheet grid; result validation records slider `110` and visible zoom text about `130%`. | `tools/foreground-captures/freex-status-ctrl-wheel-grid-zoom/freex-status-ctrl-wheel-grid-zoom_20260610_170732.png`, `freex-status-ctrl-wheel-grid-zoom_manifest.json` |
| `freex-sheet-tab-context-menu` | S5 | Complete foreground proof for physical sheet-tab right-click context menu placement and command list. | `tools/foreground-captures/freex-sheet-tab-context-menu/freex-sheet-tab-context-menu_20260610_160955.png`, `freex-sheet-tab-context-menu_manifest.json` |
| `freex-sheet-tab-double-click-rename` | S5 | Complete foreground proof for physical Insert Sheet clicks followed by physical Sheet2 tab double-click rename, capturing the foreground Rename Sheet dialog. | `tools/foreground-captures/freex-sheet-tab-double-click-rename/freex-sheet-tab-double-click-rename_20260610_185918.png`, `freex-sheet-tab-double-click-rename_manifest.json` |
| `freex-grid-drag-select` | S4 | Partial foreground proof for physical grid/header selection. The retained screenshot shows a header-style selected span after drag input, not the intended cell-range drag. | `tools/foreground-captures/freex-grid-drag-select/freex-grid-drag-select_20260610_161353.png`, `freex-grid-drag-select_manifest.json` |
| `freex-s4-grid-drag-select-validated` | S4 | Complete foreground proof for physical cell-range drag select from `A1` to `D5`; UIA `SelectionPattern` validation records 20 expected cells. | `tools/foreground-captures/freex-s4-grid-drag-select-validated/freex-s4-grid-drag-select-validated_20260610_221654.png`, `freex-s4-grid-drag-select-validated_manifest.json` |
| `freex-s4-grid-autofill-handle-drag` | S4 | Complete foreground proof for physical fill-handle drag from `A1` to `A4`; UIA `ValuePattern` validation confirms `A2:A4` copied `11`. | `tools/foreground-captures/freex-s4-grid-autofill-handle-drag/freex-s4-grid-autofill-handle-drag_20260610_221734.png`, `freex-s4-grid-autofill-handle-drag_manifest.json` |

## Still Open

- S4 now has retained foreground proof for precise cell-range drag selection, autofill-handle drag, row/column resize drag, ordinary wheel, Shift-wheel, and Ctrl-wheel through the S4/S6 foreground harness passes. Remaining S4 gaps are double-click AutoFit follow-up, hidden-boundary resize breadth, split-divider drag, mini-scrollbar drag, split-pane wheel routing, touchpad/hardware wheel parity, and Excel-paired proof.
- S5 now has retained foreground proof for sheet-tab right-click context menu, click/select, overflow-right navigation click, and physical double-click rename. Remaining S5 gaps are drag reorder, Ctrl/Shift grouping clicks, right-click Activate dialog from the overflow buttons, and Excel-paired proof.
- S6 now has retained foreground proof for Zoom In physical click, Zoom Out physical click, physical slider drag, native UIA RangeValue set, and Ctrl+wheel zoom over the grid. Remaining S6 gaps are footer view shortcut physical clicks, zoom percentage/dialog physical click proof, Shift/ordinary wheel distinctions, min/max clamp breadth under foreground input, Ctrl+Alt+=/-, and Excel-paired status/footer proof.

## Verification

- `dotnet build tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release` passed with 0 warnings and 0 errors after adding the pointer scenarios.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-status-zoom-in-click` passed and emitted retained evidence.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-status-zoom-out-click` passed and emitted retained evidence.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-status-zoom-slider-drag` passed and emitted retained evidence.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-status-zoom-slider-rangevalue-set` passed and emitted retained evidence.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-status-ctrl-wheel-grid-zoom` passed and emitted retained evidence.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-sheet-tab-context-menu` passed and emitted retained evidence.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-sheet-tab-double-click-rename` passed and emitted retained evidence on the S5 checkpoint branch.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-grid-drag-select` passed on the final retained run and emitted partial S4 evidence. Two earlier A1-only grid captures were discarded.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-s4-grid-drag-select-validated` passed on the S4 validation-run checkpoint and emitted retained evidence.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-s4-grid-autofill-handle-drag` passed on the S4 validation-run checkpoint and emitted retained evidence.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-s4-grid-double-click-autofit` blocked on the S4 validation-run checkpoint after foreground-owned input because column A width changed `96->92` instead of growing for the seeded long value.
