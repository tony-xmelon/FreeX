# UX Parity S3 Native Dialogs/Backstage/Export Continuation - 2026-06-10

Branch/worktree:

- Branch: `codex/ux-parity-s3-native-dialogs-20260610`
- Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\ux-parity-s3-native-dialogs-20260610`
- Base: `origin/main` at `1ac76f98254375f6d889eb01601f2d99c8124a92`

## Scope

This S3 pass inventoried the remaining native dialog, Backstage, Page Layout background, PDF/XPS export, and native Print blockers using only existing docs, catalog rows, tests, and scripts. No harness code was added or edited, and `tools/FreeX.ForegroundCapture/Program.cs` was not touched.

## Existing Evidence Inventory

| Subcase | Evidence found | S3 status |
|---|---|---|
| FreeX Save As native dialog opens | `screenshots/save-as-workbook-dialog-tour/freex_save_as_workbook_dialog_tour_manifest.json` records `CaptureStatus=complete`, `DialogClassName=#32770`, `EntryPath=F12`, and pair key `interactive:save-as-workbook-dialog:opened`. | Opened-dialog proof exists; save/cancel/overwrite continuation is still foreground-only. |
| Excel Save As dialog opens | `screenshots_excel/save-as-workbook-dialog-tour/excel_save_as_workbook_dialog_tour_manifest.json` records `CaptureStatus=complete`, `EntryPath=F12`, and `DialogClassName=NUIDialog` in this Office install. | Existing script proves the F12 Excel Save As surface, but not the downstream common `#32770` Browse/Save continuation. |
| File/backstage workflows | `screenshots/file-backstage-workflows-tour/file_backstage_workflows_tour_manifest.json` records saved/reopened workbook proof, Backstage Save As guard, Print settings, Print Preview summary, Export entry, and retained PDF output. | Deterministic Backstage/output proof exists; native Open/Save/Export/Print OS dialogs remain out of deterministic scope. |
| Page Layout background/output | `screenshots/page-layout-output-tour/page_layout_output_tour_manifest.json` records `CaptureStatus=complete-with-native-picker-limitation`, background menu guard, saved XLSX reload, and PDF output proof. | Background command/model/output proof exists; the native image picker selection/replacement/clear foreground flow is still blocked without new foreground dialog automation. |
| PDF/XPS options and output | `screenshots/file-io-import-smoke-tour/file_io_import_smoke_tour_manifest.json` records PDF and XPS Export Options summaries; Backstage workflow evidence records retained PDF output inspection. | Options and PDF output proof exist; native export SaveFileDialog overwrite/cancel, explicit XPS save-path acceptance, and post-dialog focus-return proof remain open. |
| Native Print | `screenshots/print-preview-tour/print_preview_tour_manifest.json` and Backstage workflow evidence record Print Preview entry, toolbar state, settings summary, close/focus return, and print-command source coverage. | Print Preview proof exists; Windows `PrintDialog` foreground proof is intentionally not launched by existing deterministic tours. |

## Script Attempts

| Command | Result |
|---|---|
| `dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release` | Passed after rerun with a longer timeout: 0 warnings, 0 errors. |
| `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -SaveAsWorkbookDialogTour 1` | Blocked before setup input by the foreground guard because another Excel-owned window, `Create PivotTable` / `Recommended PivotTables` PID `88716`, owned foreground instead of the script-launched workbook. No valid new evidence was kept. |
| `$env:FREEX_FILE_BACKSTAGE_WORKFLOWS_TOUR='1'; $env:FREEX_SS_TOUR_ALLOW_BACKGROUND_RENDER='1'; dotnet run --project src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release` | Passed. It refreshed deterministic Backstage/output evidence locally, but the resulting diffs were path/byte-count churn and were restored to preserve the checked-in artifact baseline. |
| `$env:FREEX_PAGE_LAYOUT_OUTPUT_TOUR='1'; $env:FREEX_SS_TOUR_ALLOW_BACKGROUND_RENDER='1'; dotnet run --project src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release` | Passed. It confirmed the background native-picker guard, XLSX reload proof, and PDF output inspection remain deterministic; generated churn was restored. |
| `$env:FREEX_FILE_IO_IMPORT_SMOKE_TOUR='1'; $env:FREEX_SS_TOUR_ALLOW_BACKGROUND_RENDER='1'; dotnet run --project src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release` | Passed. It confirmed PDF/XPS Export Options surfaces remain deterministic; generated churn was restored. |
| `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_ribbon.ps1 -SaveAsWorkbookDialogTour 1` | Blocked before initial capture setup by the same external Excel foreground window. The launched FreeX process had already exited when checked. |

## Remaining S3 Blockers

- Excel Save As common-dialog route: the existing Excel script only captures the first F12 Save As surface. In this checked-in evidence it is an Office `NUIDialog`, not the common `#32770` Save As/Browse continuation. Closing this needs a new or extended foreground-safe script path that drives the Excel Browse/common-dialog transition while preserving ownership guards.
- Page Layout Background native image picker: source and deterministic tours prove command wiring, menu guard, model/output persistence, replacement semantics, and clear command routing, but no existing script opens, selects, cancels, or captures the native `OpenFileDialog` for sheet backgrounds.
- PDF/XPS native Save As continuation: source coverage proves filters, default `.pdf`, `FilterIndex == 2` XPS routing, add-extension, overwrite prompts, normalized overwrite warning, and exporter property hooks. Existing tours stop before the native export `SaveFileDialog`, so overwrite/cancel, explicit `.xps` path acceptance, and post-dialog focus-return proof remain open.
- Native Print dialog: source coverage proves the Print Preview toolbar Print button routes to `ShowNativePrintDialog`, while tours intentionally capture Print Preview only. Existing scripts do not open or capture the Windows `PrintDialog`.
- Foreground conflict: the foreground-safe Save As scripts could not run in this desktop session because an unrelated Excel PID `88716` owned foreground. Per session ownership rules, that process/window was not closed or manipulated.

## Evidence Handling

Successful deterministic runs changed tracked screenshots/manifests only because of regenerated paths, timestamps, or byte counts. Those artifacts were restored before commit. The committed result is this S3 residual report plus catalog row updates.
