# S2/S7 Popup Gallery Checkpoint - 2026-06-10

Scope: foreground-harness checkpoint for S2 popup/dropdown/gallery captures and S7 Excel-paired popup/dialog comparison. This pass did not expand beyond the in-hand Format Cells dialog and Data Validation dropdown attempts. It did not modify product app code.

## Harness Changes

- Added foreground harness scenario names for `excel-format-cells-dialog`, `freex-format-cells-dialog`, and `excel-data-validation-dropdown`.
- Added Excel workbook setup for a simple list-validation dropdown candidate and guarded in-cell dropdown clicking.
- Added a native `Ctrl+1` helper for FreeX Format Cells dialog attempts; Excel Format Cells uses a foreground-guarded `Alt,H,O,E` keytip route after `Ctrl+1` did not open the dialog in this environment.
- Second-wave edge checkpoint added distinct alternate-route scenario names for `excel-format-cells-context-dialog`, `freex-format-cells-context-dialog`, `excel-data-validation-dropdown-prepared`, and `excel-cell-styles-gallery`.
- Added Excel worksheet-context-menu Format Cells invocation through UI Automation menu item discovery, a FreeX A1 context-menu Format Cells route, a prepared/reopened Excel validation-list workbook route with stricter popup filtering that rejects Office `NUIDialog` false positives, and an Excel Cell Styles gallery route via `Alt,H,J`.

## Retained Artifacts

| Scenario | Artifact | Outcome |
|---|---|---|
| Excel Format Cells dialog | `tools/foreground-captures/excel-format-cells-dialog/excel-format-cells-dialog_manifest.json` | Blocked: Excel owned foreground, but `Alt,H,O,E` did not produce a detectable `Format Cells` dialog. Earlier `Ctrl+1` attempts also failed before the final retained manifest. |
| FreeX Format Cells dialog | `tools/foreground-captures/freex-format-cells-dialog/freex-format-cells-dialog_manifest.json` | Blocked: FreeX owned foreground, but `Ctrl+1` did not produce a detectable `Format Cells` dialog. The run used the already-built Release host from the synced main worktree because this branch changed only the foreground harness. |
| Excel Data Validation dropdown | `tools/foreground-captures/excel-data-validation-dropdown/excel-data-validation-dropdown_manifest.json` | Blocked: Excel COM returned `0x800AC472` while preparing/opening the validation dropdown scenario; no popup PNG was produced. |
| Excel Format Cells via worksheet context menu | `tools/foreground-captures/excel-format-cells-context-dialog/excel-format-cells-context-dialog_manifest.json` | Blocked: Excel owned foreground, the worksheet context-menu route was invoked, but no detectable `Format Cells` dialog appeared. |
| FreeX Format Cells via worksheet context menu | `tools/foreground-captures/freex-format-cells-context-dialog/freex-format-cells-context-dialog_manifest.json` | Blocked: FreeX owned foreground and A1 was right-clicked, but the worksheet context menu did not expose a visible invokable `Format Cells` item through UI Automation. This third-wave run used the existing primary-checkout Release host executable because the fresh worktree host build timed out before producing a binary. |
| Excel Data Validation dropdown via prepared workbook | `tools/foreground-captures/excel-data-validation-dropdown-prepared/excel-data-validation-dropdown-prepared_manifest.json` plus retained setup workbook `prepared-validation-list.xlsx` | Blocked: validation workbook was prepared and reopened read-only, but no foreground validation-list popup was detected after physical in-cell arrow click or `Alt+Down`. A first run exposed an Office `NUIDialog`; the harness was tightened so that helper is rejected instead of retained as dropdown evidence. |
| Excel Cell Styles gallery | `tools/foreground-captures/excel-cell-styles-gallery/excel-cell-styles-gallery_20260610_185707.png` with `excel-cell-styles-gallery_manifest.json` | Complete: Excel foreground-owned `Net UI Tool Window` capture for the Cell Styles gallery via `Alt,H,J`, paired with existing FreeX Cell Styles gallery evidence in `screenshots/home-styles-cf-tour/freex_home_styles_cf_cell_styles_gallery_opened.png`. |

This second-wave checkpoint retains one new complete PNG pairing candidate for Cell Styles gallery and explicit blocker manifests for the alternate Format Cells/Data Validation routes. Existing closed S2/S7 pairings for AutoFilter, Home Borders, Home Number Format, and worksheet context menu remain as documented in `docs/parity/worker-popup-evidence-pairing-s2s7-2026-06-10.md`.

## Remaining S2/S7 Blockers

- Data Validation dropdown popup remains blocked after both direct COM setup and prepared-workbook routes. The prepared route avoids setup-time `0x800AC472`, but this Office desktop state reopens the workbook read-only and does not expose the in-cell list popup to the foreground detector.
- Format Cells dialog pairing remains blocked. Excel direct `Alt,H,O,E`, earlier `Ctrl+1`, and worksheet-context-menu invocation all failed to produce a detectable dialog; FreeX `Ctrl+1` is blocked, and the third-wave FreeX worksheet-context-menu route now has a retained blocker manifest because the context menu did not expose an invokable `Format Cells` item to UI Automation after a guarded A1 right-click.
- Additional ribbon gallery/dropdown pairings outside the closed AutoFilter/Home Borders/Home Number Format/worksheet-context-menu set and the new Cell Styles pairing remain open.

## Third-Wave Checkpoint - 2026-06-11

- Work proceeded in isolated branch `codex/ux-parity-s2s7-alt-proof-20260611` from local `main` at `347b45a7e`.
- `dotnet build tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release` passed.
- `dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release` timed out before creating `src/FreeX.App.Host/bin/Release/net10.0-windows10.0.19041.0/FreeX.App.Host.exe`; stale build processes tied to this worktree were cleared. A fallback-shaped host build process was also observed still tied to the timed-out parent and cleared before the foreground run.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-format-cells-context-dialog --freex-exe "E:\Users\anton\Documents\Claude\FreeX\src\FreeX.App.Host\bin\Release\net10.0-windows10.0.19041.0\FreeX.App.Host.exe"` produced the retained blocked manifest at `tools/foreground-captures/freex-format-cells-context-dialog/freex-format-cells-context-dialog_manifest.json`.
- No new complete S2/S7 PNG was produced in this environment. The remaining high-value route for this slice is a product/harness fix that makes the Format Cells command accessible from a foreground-safe FreeX route or exposes the dialog through a reliable shortcut/menu path; rerunning the same Ctrl+1, Excel context-menu, prepared validation dropdown, or FreeX A1 context-menu attempts is not expected to close new proof without such a change.

## Second-Wave Verification

- `git status --short --branch` and `git worktree list --porcelain` were run before edits; work proceeded in isolated branch `codex/ux-parity-s2s7-dialog-dropdown-edge-20260610b` from local `main` at `93344cc35`.
- `git fetch origin main` completed; local `main` remained at `93344cc35` and ahead of `origin/main`.
- `dotnet build tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release` passed before and after the stricter Data Validation popup filter.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario excel-format-cells-context-dialog` produced the retained blocked manifest.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario excel-data-validation-dropdown-prepared` initially exposed an Office `NUIDialog`; after tightening popup detection and removing the invalid PNG, rerun produced the retained blocked manifest.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario excel-cell-styles-gallery` passed and produced the retained PNG/manifest.
- `dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release` timed out before the FreeX context-menu route could be run; lingering dotnet processes from this worktree were cleared before checkpointing.
