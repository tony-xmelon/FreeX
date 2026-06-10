# UX S3 Native Dialogs, Backstage, and Export Evidence - 2026-06-10

Branch/worktree:

- Branch: `codex/ux-parity-s3-native-dialogs-docs-20260610`
- Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\ux-parity-s3-native-dialogs-docs-20260610`
- Base: local `main` at `f11fdc137715877a9beda855bbfa97a34996bbdb`, after `git fetch --all --prune`. Local `main` was clean and ahead of `origin/main`.

## Scope

This slice inventories the retained S3 evidence for native Open/Save, File backstage, Background, and Export/Print surfaces. It does not replace screenshots and does not modify `tools/FreeX.ForegroundCapture/Program.cs`.

No new foreground capture was produced in this pass. The existing retained foreground-capture artifacts already close the quick safe native-dialog lanes available through the harness, while the remaining S3 gaps require a different Office Save As route, a foreground-owned native image picker, native export Save As overwrite/cancel proof, or physical OS dialog interaction. This pass therefore records the evidence and blockers rather than inventing ad hoc global input.

## S3 Status

| Sub-scenario | Status | Evidence / blocker |
|---|---|---|
| Excel native Open dialog | Closed for foreground-owned dialog-open proof. | Retained foreground capture: `tools/foreground-captures/excel-open-dialog/excel-open-dialog_20260610_142513.png`; manifest: `tools/foreground-captures/excel-open-dialog/excel-open-dialog_manifest.json`. The manifest records `CaptureStatus=complete`, `CaptureMode=foreground-guarded-uia-win32`, class `#32770`, title `Open`, and a successful Excel foreground guard. Paired baseline evidence also exists at `screenshots_excel/open-workbook-dialog-tour/interactive_open_workbook_dialog_opened.png` and `screenshots_excel/open-workbook-dialog-tour/excel_open_workbook_dialog_tour_manifest.json`. |
| FreeX native Open dialog | Closed for foreground-owned dialog-open proof. | Retained foreground capture: `tools/foreground-captures/freex-open-dialog/freex-open-dialog_20260610_142532.png`; manifest: `tools/foreground-captures/freex-open-dialog/freex-open-dialog_manifest.json`. The manifest records `CaptureStatus=complete`, `CaptureMode=foreground-guarded-uia-win32`, class `#32770`, title `Open`, and a successful FreeX foreground guard. Paired baseline evidence also exists at `screenshots/open-workbook-dialog-tour/freex_open_workbook_dialog_opened.png` and `screenshots/open-workbook-dialog-tour/freex_open_workbook_dialog_tour_manifest.json`. |
| FreeX native Save As dialog | Closed for foreground-owned dialog-open proof. | Retained foreground capture: `tools/foreground-captures/freex-save-as-dialog/freex-save-as-dialog_20260610_142550.png`; manifest: `tools/foreground-captures/freex-save-as-dialog/freex-save-as-dialog_manifest.json`. The manifest records `CaptureStatus=complete`, `CaptureMode=foreground-guarded-uia-win32`, class `#32770`, title `Save As`, and a successful FreeX foreground guard. Paired baseline evidence also exists at `screenshots/save-as-workbook-dialog-tour/freex_save_as_workbook_dialog_opened.png` and `screenshots/save-as-workbook-dialog-tour/freex_save_as_workbook_dialog_tour_manifest.json`. |
| Excel Save As dialog | Blocked for native common-file-dialog proof. | `tools/foreground-captures/excel-save-as-dialog/excel-save-as-dialog_manifest.json` records `CaptureStatus=blocked` with `BlockReason=nuidialog-not-capturable: Detected an Office NUIDialog after F12, but it is not a capturable native Save As file dialog in this Office state.` The older paired baseline at `screenshots_excel/save-as-workbook-dialog-tour/interactive_save_as_workbook_dialog_opened.png` and `screenshots_excel/save-as-workbook-dialog-tour/excel_save_as_workbook_dialog_tour_manifest.json` is retained, but its manifest identifies class `NUIDialog` with an empty title, so it is evidence of the Office backstage/helper Save As surface, not a closed native common-file-dialog scenario. |
| FreeX File backstage workflow tour | Advanced; deterministic workflow/output proof retained, foreground input still missing. | `screenshots/file-backstage-workflows-tour/file_backstage_workflows_tour_manifest.json` plus retained captures for New, Recent/Pinned, Save As guard, saved title/path, reopened workbook, Print settings, Print Preview, and Export output readiness. Retained outputs: `screenshots/file-backstage-workflows-tour/freex_file_backstage_workflows_saved.xlsx` and `screenshots/file-backstage-workflows-tour/freex_file_backstage_workflows_export.pdf`. |
| Backstage Recent/Export/Share tour | Advanced; deterministic backstage/export/share status proof retained, external OS UI intentionally not launched. | `screenshots/backstage-recent-export-share-tour/backstage_recent_export_share_tour_manifest.json` plus retained captures including `freex_backstage_export_entry_focused.png`, `freex_backstage_export_pdf_options.png`, `freex_backstage_export_xps_options.png`, `freex_backstage_share_unsaved_guard_status.png`, and `freex_backstage_share_saved_ready_status.png`. |
| Page Layout Background native image picker | Still missing native picker proof. | Existing `screenshots/page-layout-output-tour/page_layout_output_tour_manifest.json` records the Background command guard and output/persistence state, but the native image picker was intentionally not opened or driven without foreground OS ownership. |
| PDF/XPS export Save As dialog | Still missing foreground native save-dialog interaction proof. | Source/planner/exporter coverage plus deterministic export options/output evidence exist, including `screenshots/file-backstage-workflows-tour/freex_file_backstage_export_entry_output_ready.png`, `screenshots/file-backstage-workflows-tour/freex_file_backstage_workflows_export.pdf`, and `screenshots/backstage-recent-export-share-tour/freex_backstage_export_pdf_options.png` / `freex_backstage_export_xps_options.png`. Missing: foreground native Save As overwrite/cancel, explicit XPS native save path, and OS dialog focus-return proof. |
| Native Print dialog | Still missing native dialog proof. | Print Preview and settings evidence are retained through `screenshots/file-backstage-workflows-tour/freex_file_backstage_print_preview_summary.png` and `screenshots/print-preview-tour/print_preview_tour_manifest.json`; the Windows native Print dialog remains intentionally unopened in deterministic tours. |

## Retained Artifact Inventory

Foreground-capture S3 artifacts:

- `tools/foreground-captures/excel-open-dialog/excel-open-dialog_20260610_142513.png`
- `tools/foreground-captures/excel-open-dialog/excel-open-dialog_manifest.json`
- `tools/foreground-captures/freex-open-dialog/freex-open-dialog_20260610_142532.png`
- `tools/foreground-captures/freex-open-dialog/freex-open-dialog_manifest.json`
- `tools/foreground-captures/freex-save-as-dialog/freex-save-as-dialog_20260610_142550.png`
- `tools/foreground-captures/freex-save-as-dialog/freex-save-as-dialog_manifest.json`
- `tools/foreground-captures/excel-save-as-dialog/excel-save-as-dialog_manifest.json`

Paired native-dialog baseline artifacts:

- `screenshots_excel/open-workbook-dialog-tour/interactive_open_workbook_dialog_opened.png`
- `screenshots_excel/open-workbook-dialog-tour/excel_open_workbook_dialog_tour_manifest.json`
- `screenshots/open-workbook-dialog-tour/freex_open_workbook_dialog_opened.png`
- `screenshots/open-workbook-dialog-tour/freex_open_workbook_dialog_tour_manifest.json`
- `screenshots/save-as-workbook-dialog-tour/freex_save_as_workbook_dialog_opened.png`
- `screenshots/save-as-workbook-dialog-tour/freex_save_as_workbook_dialog_tour_manifest.json`
- `screenshots_excel/save-as-workbook-dialog-tour/interactive_save_as_workbook_dialog_opened.png`
- `screenshots_excel/save-as-workbook-dialog-tour/excel_save_as_workbook_dialog_tour_manifest.json`

Earlier File/backstage/export tour artifacts:

- `screenshots/file-backstage-workflows-tour/file_backstage_workflows_tour_manifest.json`
- `screenshots/file-backstage-workflows-tour/freex_file_backstage_new_entry_focused.png`
- `screenshots/file-backstage-workflows-tour/freex_file_backstage_new_workbook_result.png`
- `screenshots/file-backstage-workflows-tour/freex_file_backstage_open_recent_filtered_list.png`
- `screenshots/file-backstage-workflows-tour/freex_file_backstage_open_pinned_list.png`
- `screenshots/file-backstage-workflows-tour/freex_file_backstage_save_as_native_dialog_guard.png`
- `screenshots/file-backstage-workflows-tour/freex_file_backstage_saved_title_path_info.png`
- `screenshots/file-backstage-workflows-tour/freex_file_backstage_reopened_workbook_title_path.png`
- `screenshots/file-backstage-workflows-tour/freex_file_backstage_print_entry_settings.png`
- `screenshots/file-backstage-workflows-tour/freex_file_backstage_print_preview_summary.png`
- `screenshots/file-backstage-workflows-tour/freex_file_backstage_export_entry_output_ready.png`
- `screenshots/file-backstage-workflows-tour/freex_file_backstage_workflows_saved.xlsx`
- `screenshots/file-backstage-workflows-tour/freex_file_backstage_workflows_export.pdf`
- `screenshots/backstage-recent-export-share-tour/backstage_recent_export_share_tour_manifest.json`
- `screenshots/backstage-recent-export-share-tour/freex_backstage_open_recent_list.png`
- `screenshots/backstage-recent-export-share-tour/freex_backstage_open_pinned_list.png`
- `screenshots/backstage-recent-export-share-tour/freex_backstage_info_unsaved_status.png`
- `screenshots/backstage-recent-export-share-tour/freex_backstage_info_unsupported_feature_save_warning.png`
- `screenshots/backstage-recent-export-share-tour/freex_backstage_export_entry_focused.png`
- `screenshots/backstage-recent-export-share-tour/freex_backstage_export_pdf_options.png`
- `screenshots/backstage-recent-export-share-tour/freex_backstage_export_xps_options.png`
- `screenshots/backstage-recent-export-share-tour/freex_backstage_share_unsaved_guard_status.png`
- `screenshots/backstage-recent-export-share-tour/freex_backstage_share_saved_ready_status.png`
- `screenshots/backstage-recent-export-share-tour/freex_backstage_back_to_workbook_focus_return.png`

## Remaining S3 Blockers

- Excel Save As needs a route that opens a capturable native common `Save As` dialog instead of Office `NUIDialog`, or the S3 catalog should deliberately scope Excel Save As comparison to the Office `NUIDialog` surface.
- Page Layout Background needs foreground-owned native image picker proof, including cancel and selected image acceptance.
- Export to PDF/XPS needs foreground-owned native Save As proof for overwrite, cancel, extensionless `.pdf`, explicit `.xps`, and focus return.
- Native Print remains open for guarded foreground dialog proof; deterministic Print Preview and output inspection are already retained.
- Backstage/export tours remain deterministic RenderTargetBitmap/output-file evidence, not physical mouse, Alt/keytip, Tab/F6, UIA Invoke, or CopyFromScreen proof.

## Verification

This pass is documentation-only. Relevant docs/preflight verification was run after edits:

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1`
