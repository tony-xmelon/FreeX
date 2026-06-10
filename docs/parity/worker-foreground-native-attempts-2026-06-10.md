# Guarded Native and Foreground Attempts - 2026-06-10

Branch/worktree:

- Branch: `codex/ux-parity-foreground-native-attempts-20260610`
- Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\ux-parity-foreground-native-attempts-20260610`
- Attempt base: local `main` at `d430896e30b9a7c2ad3ffaa335cee65a6a7adf9c`
- Final branch sync: fast-forwarded from local `main` to `efc3934f1602e446b9b919c4ef186ef026f9388b` before doc edits and verification. The fast-forward touched pivot internals, not screenshot harness files.

## Scope

This slice re-ran safe foreground-gated/native lanes for the remaining hard foreground gaps:

- FreeX Open/Save As native dialogs.
- Excel and FreeX main-ribbon paired capture attempt.
- Excel AutoFilter, Home Borders, and native Open lanes.
- Page Layout Background native-picker guard through the existing output tour.
- Data Validation dropdown foreground proof through the existing submitted-workflows tour.
- Status/zoom guarded attempt through the existing status footer tour.

No guards were disabled, and no unguarded global input was synthesized. Successful screenshot-producing lanes were treated as transient evidence for this documentation pass; all tracked screenshot/PDF/XLSX artifacts were restored to the repository baseline after their manifest details were recorded.

## Preflight

| Check | Result |
|---|---|
| Primary checkout status | `git status --short --branch` showed the primary checkout on `worker-c-cf-aggregate-list-parity` with unrelated dirty files, so it was treated as off-limits. |
| Worktree list | `git worktree list --porcelain` confirmed this session uses a linked worktree under `.worktrees/`. |
| Main sync | `git fetch origin` and `git pull --ff-only` from the existing local main worktree reported up to date at `d430896e3`; this session branch/worktree was created from local `main`. |
| Host build for harness execution | `dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release` passed with 0 warnings and 0 errors, producing the Release host exe for `tools/screenshot_ribbon.ps1`. |
| Excel install | `C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE` exists. |

## Attempt Results

| Lane | Command | Result |
|---|---|---|
| Excel main ribbon | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -Widths max` | Blocked by the harness incomplete-matrix guard, not by foreground. Excel launched as PID `39144`; Home and Insert were transiently captured, then the script aborted because the planned `Draw` tab was not found in this installed Excel UI. The invalid partial matrix was discarded. |
| FreeX main ribbon | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_ribbon.ps1 -Widths max` | Blocked. Expected foreground `Book1 - FreeX` PID `75612`; actual foreground was `Excel` PID `39144` before initial capture setup. |
| FreeX Open dialog | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_ribbon.ps1 -OpenWorkbookDialogTour 1` | Blocked. Expected foreground `Book1 - FreeX` PID `13244`; actual foreground was `Excel` PID `87172` before initial capture setup. The fresh blank Excel PID `87172` was later closed; older user/session Excel processes were left untouched. |
| FreeX Save As dialog | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_ribbon.ps1 -SaveAsWorkbookDialogTour 1` | Produced transient guarded evidence. Manifest recorded `CaptureStatus=complete`, expected foreground `Book1 - FreeX` PID `70552`, dialog class `#32770`, title `Save As`, pair key `interactive:save-as-workbook-dialog:opened`. Artifact changes were restored. |
| Excel AutoFilter flyout | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -AutoFilterFlyoutTour 1` | Produced transient guarded evidence. Manifest recorded `CaptureStatus=complete`, expected foreground `Book1 - Excel` PID `48904`, popup class `Net UI Tool Window`, size `401 x 818`, pair key `interactive:table-autofilter-dropdown:opened`. Artifact changes were restored. |
| Excel Home Borders dropdown | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -HomeBordersDropdownTour 1` | Blocked. Expected foreground `Book1 - Excel` PID `43964`; actual foreground was `Book1 - FreeX` PID `40016` before Excel Home Borders dropdown setup. |
| Excel Open dialog | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -OpenWorkbookDialogTour 1` | Produced transient guarded evidence. Manifest recorded `CaptureStatus=complete`, expected foreground `Book1 - Excel` PID `62824`, dialog class `#32770`, title `Open`, pair key `interactive:open-workbook-dialog:opened`. Artifact changes were restored. |
| Page Layout Background native picker guard | `$env:FREEX_PAGE_LAYOUT_OUTPUT_TOUR='1'; Remove-Item Env:\FREEX_SS_TOUR_ALLOW_BACKGROUND_RENDER -ErrorAction SilentlyContinue; dotnet run --project src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release` | Produced transient foreground-guarded render evidence. Manifest recorded `CaptureStatus=complete-with-native-picker-limitation`, `CaptureMode=foreground-guarded-render`, `FocusGuard.Required=true`, and `background-native-picker-guard`. The native image picker was intentionally not opened or driven; the tour captures the owned Background menu guard and seeded model/output status. Artifact changes were restored. |
| Data Validation dropdown proof | `$env:FREEX_DATA_SUBMITTED_WORKFLOWS_TOUR='1'; Remove-Item Env:\FREEX_SS_TOUR_ALLOW_BACKGROUND_RENDER -ErrorAction SilentlyContinue; dotnet run --project src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release` | Produced transient foreground-guarded render evidence for submitted data workflows, but the actual Data Validation dropdown popup remains blocked. Manifest recorded `CaptureStatus=partial-with-blocked-planned-items`, `FocusGuard.Required=true`, and workflow `Data Validation dropdown popup commit` as `planned-but-blocked` because it requires foreground keyboard or mouse input. Artifact changes were restored. |
| Status/zoom guarded attempt | `$env:FREEX_STATUS_FOOTER_TOUR='1'; Remove-Item Env:\FREEX_SS_TOUR_ALLOW_BACKGROUND_RENDER -ErrorAction SilentlyContinue; dotnet run --project src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release` | Produced transient foreground-guarded render evidence. Manifest recorded `CaptureStatus=complete`, `CaptureMode=foreground-guarded-render`, `FocusGuard.Required=true`, zoom states at 10%, 100%, and 400%, and limitations that this is not CopyFromScreen proof, slider values are set through the in-app model, and live mouse drag/Ctrl+wheel/UIA RangeValue remain open. Artifact changes were restored. |

## Catalog Rows Impacted

- Main ribbon pairing: `UI-CMD-HARNESS-001`, `UI-CMD-RIBBON-004`, `UI-CAT-RIBBON-001A`.
- Native Open/Save As dialog proof: `UI-CAT-FILE-001A`, `UI-CMD-HARNESS-001`.
- Excel AutoFilter and Borders proof: `UI-CAT-DATA-001`, `UI-CAT-DATA-001B`, `UI-CMD-DATA-002`, `UI-CAT-HOME-002`, `UI-CMD-HARNESS-001`.
- Page Layout Background native picker: `UI-CAT-PAGE-001`, `UI-CAT-PAGE-001A`, `UI-CMD-PAGE-002`.
- Data Validation dropdown: `UI-CAT-DATA-002`, `UI-CMD-DATA-005`.
- Status/zoom wheel/slider: `UI-CAT-STATUS-001C`, `UI-CAT-STATUS-001D`, `UI-CMD-STATUS-003`, `UI-CAT-VIEW-002`.

## Evidence Handling

The following tracked artifact groups were modified transiently by successful or guarded-render attempts and then restored:

- `tools/screenshots/save-as-workbook-dialog-tour/`
- `tools/screenshots_excel/autofilter-flyout-tour/`
- `tools/screenshots_excel/open-workbook-dialog-tour/`
- `screenshots/page-layout-output-tour/`
- `screenshots/data-submitted-workflows-tour/`
- `screenshots/status-footer-tour/`

No screenshot, PDF, or XLSX evidence replacement is committed in this branch. The committed evidence is this report plus the catalog note referencing it.

## Follow-Up

- Re-run Excel main ribbon with an Excel profile that exposes the planned Draw tab, or update the harness/catalog expectations deliberately if Draw is hidden by environment policy.
- Re-run FreeX main ribbon and FreeX Open from a runner where no other app steals foreground after launch.
- Excel Home Borders still needs a reliable foreground-owned Office popup detection/crop path.
- Data Validation dropdown and status zoom slider/Ctrl+wheel still require physical foreground input; the current in-app tours document guarded render state and blocked popup/slider limitations only.
