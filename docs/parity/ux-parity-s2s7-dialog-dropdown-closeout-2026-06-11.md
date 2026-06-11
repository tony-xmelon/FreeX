# S2/S7 Dialog Dropdown Closeout - 2026-06-11

Scope: checkpoint for the Format Cells/Data Validation/dialog-dropdown closeout slice in branch `codex/ux-parity-s2s7-dialog-dropdown-close-20260611`.

## Product/Harness Fix

- FreeX worksheet context-menu items now expose stable UI Automation names from the planner header and stable automation ids from the planner action. This keeps the displayed access-key headers unchanged while giving foreground automation a reliable `WorksheetContextMenu_FormatCells` target.
- The foreground harness menu-item invoker now normalizes access-key markers and punctuation, matches against both UIA name and automation id, and prefers onscreen menu items before falling back to larger/offscreen matches.
- A source guard was added for the worksheet context-menu automation metadata.

## Evidence State

- No new valid S2/S7 PNG evidence was produced in this checkpoint.
- The retained FreeX Format Cells context-menu blocker manifest remains `tools/foreground-captures/freex-format-cells-context-dialog/freex-format-cells-context-dialog_manifest.json`; it records the pre-fix state where A1 was right-clicked under a valid FreeX foreground guard but no invokable `Format Cells` menu item was discoverable through UIA.
- The retained Excel/Data Validation blocker manifests from `docs/parity/ux-parity-s2s7-popup-gallery-checkpoint-2026-06-10.md` remain the current Office foreground evidence state. The Data Validation dropdown popup is still blocked by Office foreground/popup exposure; this checkpoint did not expand that route.

## Verification

- `dotnet build tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release` passed after the harness fix.
- `dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release` timed out before producing `src/FreeX.App.Host/bin/Release/net10.0-windows10.0.19041.0/FreeX.App.Host.exe`.
- The fallback host build with `--disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` also timed out before producing the host executable; stale build processes tied to this worktree were cleared.
- A focused host test run for worksheet context menu and shortcut coverage timed out before writing `ux-parity-s2s7-focused.trx`; the timed-out test process for this slice was stopped. Other sessions' unrelated build/test processes were left untouched.

## Remaining Blockers

- Rerun `freex-format-cells-context-dialog` once the host project can build in this worktree; the route should now have a stable UIA target for `Format Cells...`.
- Excel Format Cells and Excel Data Validation dropdown remain Office foreground/popup-state blockers unless a future runner exposes the dialog/list popup through a different foreground-safe route.

## Integration Rerun

After integration, the host fallback build passed and the fixed route was rerun:

```powershell
dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario freex-format-cells-context-dialog
```

Result: complete. Retained `tools/foreground-captures/freex-format-cells-context-dialog/freex-format-cells-context-dialog_20260611_002043.png` plus the updated manifest. The validation confirms that the foreground-owned FreeX worksheet context menu opened the actual `Format Cells` dialog through the stable `WorksheetContextMenu_FormatCells` route.

Remaining S2/S7 blockers are now narrowed to the Office-side Format Cells/Data Validation popup states and broader gallery/dropdown pairings outside the already retained AutoFilter, Borders, Number Format, worksheet context, Cell Styles, and FreeX Format Cells context-dialog evidence.

## Final Bounded Office Rerun

The final bounded S2/S7 pass reran only existing Office foreground scenarios:

```powershell
dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario excel-format-cells-dialog
dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario excel-format-cells-context-dialog
dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario excel-data-validation-dropdown-prepared
dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --scenario excel-cell-styles-gallery
```

All four runs reached foreground-owned Excel windows and retained blocker manifests:

- `excel-format-cells-dialog`: blocked because no Excel Format Cells dialog was detected after `Alt,H,O,E`.
- `excel-format-cells-context-dialog`: blocked because invoking the worksheet context-menu Format Cells route did not expose a detectable Format Cells dialog.
- `excel-data-validation-dropdown-prepared`: blocked because no foreground Excel validation-list dropdown was detected after physical in-cell arrow click or `Alt+Down`.
- `excel-cell-styles-gallery`: blocked because the expected `Net UI Tool Window` gallery popup was not detected.

No new S2/S7 closure was produced in this final batch; the remaining work is Office popup/dialog detection strategy rather than FreeX context-route plumbing.
