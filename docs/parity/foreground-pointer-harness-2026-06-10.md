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
| `freex-status-zoom-in-click` | S6 | Complete foreground proof for physical status Zoom In button click; captured result shows zoom at 115%. | `tools/foreground-captures/freex-status-zoom-in-click/freex-status-zoom-in-click_20260610_160853.png`, `freex-status-zoom-in-click_manifest.json` |
| `freex-status-zoom-slider-drag` | S6 | Complete foreground proof for physical status zoom slider drag; captured result shows zoom at 91%. | `tools/foreground-captures/freex-status-zoom-slider-drag/freex-status-zoom-slider-drag_20260610_160932.png`, `freex-status-zoom-slider-drag_manifest.json` |
| `freex-sheet-tab-context-menu` | S5 | Complete foreground proof for physical sheet-tab right-click context menu placement and command list. | `tools/foreground-captures/freex-sheet-tab-context-menu/freex-sheet-tab-context-menu_20260610_160955.png`, `freex-sheet-tab-context-menu_manifest.json` |
| `freex-grid-drag-select` | S4 | Partial foreground proof for physical grid/header selection. The retained screenshot shows a header-style selected span after drag input, not the intended cell-range drag. | `tools/foreground-captures/freex-grid-drag-select/freex-grid-drag-select_20260610_161353.png`, `freex-grid-drag-select_manifest.json` |

## Still Open

- S4 still needs precise cell-range drag selection, autofill-handle drag, row/column resize drag, double-click AutoFit, split-divider drag, mini-scrollbar drag, wheel, Shift-wheel, Ctrl-wheel, and Excel-paired proof.
- S5 still needs foreground double-click rename, drag reorder, Ctrl/Shift grouping clicks, overflow arrow click/right-click Activate dialog, and Excel-paired proof.
- S6 still needs Ctrl-wheel zoom, Shift/Ctrl wheel distinctions, native UIA RangeValue set proof, min/max clamp breadth, and Excel-paired proof.

## Verification

- `dotnet build tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release` passed with 0 warnings and 0 errors after adding the pointer scenarios.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-status-zoom-in-click` passed and emitted retained evidence.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-status-zoom-slider-drag` passed and emitted retained evidence.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-sheet-tab-context-menu` passed and emitted retained evidence.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-grid-drag-select` passed on the final retained run and emitted partial S4 evidence. Two earlier A1-only grid captures were discarded.
