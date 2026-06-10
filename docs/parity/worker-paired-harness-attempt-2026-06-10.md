# Foreground-Gated Paired Screenshot Harness Attempt - 2026-06-10

Branch/worktree:

- Branch: `codex/ux-parity-paired-harness-attempt-20260610`
- Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\ux-parity-paired-harness-attempt-20260610`
- Source: local `main` at `67e084812d27906b9e61e9a5bf7381ffde22a67d`

## Scope

This slice attempted the existing foreground-gated paired screenshot lanes in:

- `tools/screenshot_excel.ps1`
- `tools/screenshot_ribbon.ps1`

No unsafe global input was sent outside those scripts. Each attempted lane relied on the script foreground guards before keyboard, mouse, or screen-capture operations. Existing tracked screenshot evidence was restored after incidental guard cleanup or successful overwrites so this branch only records documentation/catalog evidence.

## Preflight

| Check | Result |
|---|---|
| `git status --short --branch` in primary checkout | Primary checkout was on `worker-c-cf-aggregate-list-parity` with unrelated dirty files, so it was treated as off-limits. |
| `git worktree list --porcelain` | Confirmed this session uses a linked worktree under `.worktrees/`. |
| `git fetch origin main` | Completed. Local `main` was ahead of `origin/main`; the session branch was created from local `main` as requested. |
| Host build | `dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release` timed out after 304 seconds, but later produced `src\FreeX.App.Host\bin\Release\net10.0-windows10.0.19041.0\FreeX.App.Host.exe`, enabling FreeX harness attempts. |
| Excel install | `C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE` exists. |

## Attempt Results

| Lane | Command | Result |
|---|---|---|
| Excel main ribbon | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -Widths max` | Blocked. Expected foreground `Excel` PID `39144`; actual foreground was `Book1* - FreeX` PID `84080` before initial capture setup. No valid main-ribbon Excel evidence was produced. |
| FreeX main ribbon | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_ribbon.ps1 -Widths max` | Succeeded transiently. Produced nine `ribbon_max_<Tab>.png` captures plus `tools\screenshots\screenshot_manifest.json`, then later blocked dialog attempts cleared the root screenshot matrix by design. No root screenshot matrix evidence is committed in this branch. |
| FreeX Open dialog | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_ribbon.ps1 -OpenWorkbookDialogTour 1` | Blocked. Expected foreground `Book1 - FreeX` PID `86784`; actual foreground was `Book1* - FreeX` PID `84080` before initial capture setup. |
| FreeX Save As dialog | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_ribbon.ps1 -SaveAsWorkbookDialogTour 1` | Blocked. Expected foreground `Book1 - FreeX` PID `90224`; actual foreground was `Book1* - FreeX` PID `84080` before initial capture setup. |
| Excel AutoFilter flyout | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -AutoFilterFlyoutTour 1` | Blocked. Expected foreground `Book1 - Excel` PID `84416`; actual foreground was `Book1* - FreeX` PID `84080` before Excel AutoFilter flyout setup. The script cleared the tracked AutoFilter evidence path during guard cleanup; those tracked files were restored. |
| Excel Home number format dropdown | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -NumberFormatDropdownTour 1` | Succeeded transiently. Wrote `tools\screenshots_excel\home-number-format-dropdown-tour\interactive_home_number_format_opened.png` and `excel_home_number_format_dropdown_tour_manifest.json`. These tracked baseline artifacts were restored instead of being replaced in this documentation slice. |
| Excel Home borders dropdown | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -HomeBordersDropdownTour 1` | Blocked after guarded trigger. The harness reported: `Excel Home Borders dropdown tour did not detect a foreground Excel popup window after Alt,H,B.` No Excel Borders artifact is checked in. |
| Excel worksheet context menu | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -WorksheetContextMenuTour 1` | Succeeded transiently. Wrote `tools\screenshots_excel\worksheet-context-menu-tour\interactive_worksheet_cell_context_menu_opened.png` and `excel_worksheet_context_menu_tour_manifest.json`. These tracked baseline artifacts were restored instead of being replaced in this documentation slice. |
| Excel Open dialog | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -OpenWorkbookDialogTour 1` | Blocked after guarded trigger. The harness reported: `Excel native Open dialog tour did not detect an Excel-owned '#32770' Open dialog after Ctrl+F12.` The script cleared the tracked Open dialog evidence path during guard cleanup; those tracked files were restored. |
| Excel Save As dialog | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -SaveAsWorkbookDialogTour 1` | Succeeded transiently. Wrote `tools\screenshots_excel\save-as-workbook-dialog-tour\interactive_save_as_workbook_dialog_opened.png` and `excel_save_as_workbook_dialog_tour_manifest.json`. These tracked baseline artifacts were restored instead of being replaced in this documentation slice. |

## Catalog Rows Impacted

The attempts exercise the existing `UI-CMD-HARNESS-001` harness row and leave these paired-evidence gaps still open:

- Main ribbon pairing: `UI-CMD-HARNESS-001`, `UI-CMD-RIBBON-004`, `UI-CAT-RIBBON-001A`.
- Native Open/Save dialog foreground proof: `UI-CAT-FILE-001A` plus the `UI-CMD-HARNESS-001` paired dialog entries.
- AutoFilter flyout proof: `UI-CAT-DATA-001` plus `UI-CMD-HARNESS-001`.
- Home number format and Borders dropdown foreground proof: Home font/alignment/number/styles command family plus `UI-CMD-HARNESS-001`.
- Worksheet context menu foreground proof: `UI-CAT-CONTEXT-001`, `UI-CAT-CONTEXT-001A`, and `UI-CMD-HARNESS-001`.

## Evidence Handling

Successful runs updated existing tracked screenshot artifacts in-place. Because this slice was scoped to a harness attempt/report and the coordinator requested preserving existing tracked evidence unless deliberately replacing it, those screenshot changes were restored to the repository baseline. The committed evidence for this branch is therefore this report and the catalog note pointing to it.

## Follow-Up

- Re-run the successful transient lanes only from a foreground-owned runner window if replacement artifacts are intentionally desired.
- Avoid running blocked dialog sub-lanes immediately after a successful root ribbon matrix if the root matrix should be preserved, because guard cleanup can clear the root `tools\screenshots` matrix.
- The Home Borders Excel lane still needs a harness investigation or a foreground runner that can reliably expose the Office `Net UI Tool Window` after `Alt,H,B`.
