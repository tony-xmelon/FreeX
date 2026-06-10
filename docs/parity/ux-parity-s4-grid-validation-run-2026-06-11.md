# S4 Grid Validation Run - 2026-06-11

Branch/worktree:

- Branch: `codex/ux-parity-s4-grid-validation-run-20260611`
- Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\ux-parity-s4-grid-validation-run-20260611`
- Base: local `main` at `347b45a7ed5d11d12c6f51c50d89cbe4622adc14`.

## Scope

This checkpoint ran only the newly added S4 foreground grid validation scenarios already present on `main`:

- `freex-s4-grid-drag-select-validated`
- `freex-s4-grid-autofill-handle-drag`
- `freex-s4-grid-double-click-autofit`

No split-pane scenarios were attempted in this pass.

## Outcomes

| Scenario | Outcome | Retained artifacts |
|---|---|---|
| `freex-s4-grid-drag-select-validated` | Complete. Foreground guard matched the harness-owned `Book1 - FreeX` window, and UIA `SelectionPattern` reported the expected 20-cell `A1:D5` selection. | `tools/foreground-captures/freex-s4-grid-drag-select-validated/freex-s4-grid-drag-select-validated_20260610_221654.png`, `freex-s4-grid-drag-select-validated_manifest.json` |
| `freex-s4-grid-autofill-handle-drag` | Complete. Foreground guard matched the harness-owned `Book1* - FreeX` window, and UIA `ValuePattern` confirmed `A2:A4` copied `11` after dragging the fill handle from `A1` to `A4`. | `tools/foreground-captures/freex-s4-grid-autofill-handle-drag/freex-s4-grid-autofill-handle-drag_20260610_221734.png`, `freex-s4-grid-autofill-handle-drag_manifest.json` |
| `freex-s4-grid-double-click-autofit` | Blocked after foreground-owned input and result validation. The scenario failed because column A width shrank from `96` to `92` after double-click AutoFit instead of growing for the seeded long value. | `tools/foreground-captures/freex-s4-grid-double-click-autofit/freex-s4-grid-double-click-autofit_manifest.json` |

The initial setup-only `freex-s4-grid-drag-select-validated` missing-host manifest was overwritten by the complete rerun after building `src\FreeX.App.Host`; no setup-only PNGs or manifests were retained.

## Remaining S4 Blockers

- Double-click AutoFit needs a product or harness follow-up because the foreground-guarded scenario reports `column-autofit-validation-failed: Expected column A width to grow after double-click AutoFit; before 96, after 92.`
- S4 remains open for hidden-boundary resize foreground breadth, split-divider drag, split mini-scrollbar drag, split-pane wheel routing, touchpad/hardware wheel parity, and Excel-paired screenshots.

## Verification

- `git status --short --branch`: primary checkout was dirty on `worker-c-cf-aggregate-list-parity`; left untouched.
- `git worktree list --porcelain`: confirmed this pass used an isolated linked worktree.
- `dotnet build tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release`: passed with 0 warnings and 0 errors.
- `dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release`: first attempt timed out at 184 seconds before the host executable existed; rerun passed with 0 warnings and 0 errors.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-s4-grid-drag-select-validated`: initially blocked before input because the Release host executable was missing; rerun passed and retained complete evidence.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-s4-grid-autofill-handle-drag`: passed and retained complete evidence.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-s4-grid-double-click-autofit`: blocked after foreground validation with `column-autofit-validation-failed`.
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1`: passed.
