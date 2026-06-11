# S1 Main Ribbon Paired Matrix Blocker - 2026-06-10

Branch/worktree:

- Branch: `codex/ux-parity-s1-ribbon-matrix-20260610`
- Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\ux-parity-s1-ribbon-matrix-20260610`
- Base: local `main` at `f11fdc137715877a9beda855bbfa97a34996bbdb` after `git fetch origin`; local `main` was 17 commits ahead of `origin/main`.

## Scope

S1 is the Excel/FreeX paired main-ribbon capture matrix for `UI-CMD-HARNESS-001`, `UI-CMD-RIBBON-004`, and `UI-CAT-RIBBON-001A`.

This pass only inventoried retained evidence already on main and documented the remaining blocker. It did not run new foreground input, did not generate replacement screenshots, and did not edit `tools/FreeX.ForegroundCapture/Program.cs` or any screenshot harness code.

## Retained Evidence Inventory

Retained FreeX deterministic main-ribbon evidence exists, but it is not the paired foreground Excel/FreeX matrix required to close S1:

| Evidence | Status |
|---|---|
| `screenshots/ribbon_default_screenshot_tour_manifest_20260609.json` | Complete FreeX in-process render matrix, 36/36 captures for Home, Insert, Draw, Page Layout, Formulas, Data, Review, View, and Help at max/1100/900/750. |
| `screenshots/max_Home.png` through `screenshots/750_Help.png` | Matching FreeX PNGs for the 2026-06-09 default main-ribbon sweep. |
| `screenshots/main-ribbon-visual-sweep-20260610/ribbon_screenshot_tour_manifest.json` | Complete FreeX in-process render sweep, 27/27 captures for Home, Insert, Draw, Page Layout, Formulas, Data, Review, View, and Help at max/1100/900. |
| `screenshots/main-ribbon-visual-sweep-20260610/max_Home.png` through `screenshots/main-ribbon-visual-sweep-20260610/900_Help.png` | Matching FreeX PNGs for the 2026-06-10 main-ribbon visual sweep. |
| `tools/foreground-captures/excel-autofilter/`, `tools/foreground-captures/excel-borders/`, `tools/foreground-captures/excel-number-format/`, `tools/foreground-captures/excel-context-menu/`, `tools/foreground-captures/excel-open-dialog/`, `tools/foreground-captures/freex-open-dialog/`, `tools/foreground-captures/freex-save-as-dialog/` | Retained foreground captures for popup/native-dialog lanes. Useful for S2/S3/S7, but not S1 main-ribbon tab matrix evidence. |
| `tools/screenshots/` | Contains only `open-workbook-dialog-tour/` and `save-as-workbook-dialog-tour/`; no root `screenshot_manifest.json` and no retained `ribbon_<Width>_<Tab>.png` foreground main-ribbon files. |
| `tools/screenshots_excel/` | Contains popup/native-dialog subfolders only; no root `screenshot_manifest.json` and no retained `excel_<Width>_<Tab>.png` foreground main-ribbon files. |

Related attempt reports already on main:

- `docs/parity/worker-excel-ribbon-pairing-2026-06-09.md`
- `docs/parity/worker-paired-harness-attempt-2026-06-10.md`
- `docs/parity/worker-foreground-native-attempts-2026-06-10.md`
- `docs/parity/foreground-capture-harness-2026-06-10.md`
- Current S1 continuation branch: `codex/ux-parity-s1-main-ribbon-matrix-20260610`, created from local `main` at `dad1b467572b86a4fcff3493e03771d7b3ec8041` after `git fetch origin main` and `git pull --ff-only` from the main integration worktree reported up to date.

## Remaining Uncaptured Matrix

No retained Excel main-ribbon tab screenshots exist for the S1 matrix. These Excel captures remain uncaptured at every planned width:

| Tab | Missing retained Excel outputs |
|---|---|
| Home | `excel_max_Home.png`, `excel_1100_Home.png`, `excel_900_Home.png`, `excel_750_Home.png` |
| Insert | `excel_max_Insert.png`, `excel_1100_Insert.png`, `excel_900_Insert.png`, `excel_750_Insert.png` |
| Draw | `excel_max_Draw.png`, `excel_1100_Draw.png`, `excel_900_Draw.png`, `excel_750_Draw.png` |
| Page Layout | `excel_max_Page_Layout.png`, `excel_1100_Page_Layout.png`, `excel_900_Page_Layout.png`, `excel_750_Page_Layout.png` |
| Formulas | `excel_max_Formulas.png`, `excel_1100_Formulas.png`, `excel_900_Formulas.png`, `excel_750_Formulas.png` |
| Data | `excel_max_Data.png`, `excel_1100_Data.png`, `excel_900_Data.png`, `excel_750_Data.png` |
| Review | `excel_max_Review.png`, `excel_1100_Review.png`, `excel_900_Review.png`, `excel_750_Review.png` |
| View | `excel_max_View.png`, `excel_1100_View.png`, `excel_900_View.png`, `excel_750_View.png` |
| Help | `excel_max_Help.png`, `excel_1100_Help.png`, `excel_900_Help.png`, `excel_750_Help.png` |

No retained foreground FreeX counterpart matrix exists under `tools/screenshots/` either. The paired closure still needs matching `ribbon_<Width>_<Tab>.png` outputs plus `tools/screenshots/screenshot_manifest.json` from `tools/screenshot_ribbon.ps1`, with `PairKey` values matching the Excel manifest.

## Harness Gap

S1 remains blocked by the foreground/Office-profile harness gap, not by lack of deterministic FreeX visual coverage:

- The 2026-06-09 focused `-Widths 1100` pair blocked before initial setup because another foreground window owned focus; no matrix artifacts were retained.
- The 2026-06-10 paired harness pass transiently produced the FreeX `max` tab matrix, but later blocked lanes cleared the root matrix as designed, and no retained paired main-ribbon artifacts were committed.
- The later 2026-06-10 guarded pass advanced the diagnosis: Excel foreground acquisition succeeded and transiently captured Home and Insert, then aborted because the installed Excel UI did not expose the planned `Draw` tab. The invalid partial matrix was discarded by the incomplete-matrix guard.
- The 2026-06-10 continuation in `codex/ux-parity-s1-ribbon-matrix-20260610b` updates `tools/screenshot_excel.ps1` so the Excel lane still requests Home, Insert, Draw, Page Layout, Formulas, Data, Review, View, and Help, but preflights which requested tabs are exposed by the installed Excel UI. Unavailable tabs are recorded as `SkippedTabs` and `SkippedCaptures` in the root Excel manifest instead of forcing the whole matrix to fail.
- The same continuation also changes the Excel launcher to start a separate `/x /e` Excel instance and refuse to bind to pre-existing workbook windows. This avoids accidentally capturing or killing an already-open user/session Excel workbook.
- A no-input UI Automation probe against a separate Excel instance on this machine found Home, Insert, Page Layout, Formulas, Data, Review, View, and Help available, with `Draw` unavailable. The probe process was terminated afterward; older existing Excel processes were left untouched.
- The focused live capture command `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -Widths 1100` then reached the new isolated Excel PID `61232`, but still blocked before initial capture setup because foreground focus was owned by Chrome: `Copy of Copy of Practice Questions. Final Exam - Google Docs - Google Chrome` PID `22828`, expected `Excel` PID `61232`. No root Excel matrix artifacts were retained from that run.
- The 2026-06-10 S1 continuation attempted the full root Excel matrix with `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -Widths max,1100,900,750` after a Release host build fallback succeeded. Excel launched as isolated PID `106372`, but the foreground guard blocked before initial capture setup because `live-pivot-pane - FreeX` PID `103828` owned foreground focus while the script expected `Excel` PID `106372`. No root `tools/screenshots_excel/screenshot_manifest.json` or `excel_<Width>_<Tab>.png` files were retained.
- To avoid losing a successful root ribbon matrix, do not run blocked dialog/popup sub-lanes in the same artifact directory immediately afterward; guard cleanup can clear the root `tools/screenshots*/screenshot_manifest.json` and tab PNGs.

## Required Closure Run

Minimum next run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -Widths 1100
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_ribbon.ps1 -Widths 1100
```

With the updated Excel script, the expected Excel outcome on this installed Office profile is an eight-tab retained root matrix plus manifest fields:

- `CaptureStatus=complete-with-skipped-unavailable-tabs`
- `Tabs=Home, Insert, Page Layout, Formulas, Data, Review, View, Help`
- `SkippedTabs=Draw`

If the runner's Excel profile exposes Draw, the same command should retain all nine requested tabs and report `CaptureStatus=complete`.

Full closure run after the focused pair retains complete manifests:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -Widths max,1100,900,750
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_ribbon.ps1 -Widths max,1100,900,750
```

S1 can close only when both root manifests are retained and each manifest reports complete planned captures with pairable `ribbon:<WidthLabel>:<TabFileName>` keys for the agreed tab set.

## Status

S1 is not closed. The Excel Draw-tab expectation gap is now recordable instead of matrix-fatal, but the retained paired foreground root matrix still has not been produced because the latest live Excel sample was blocked by foreground ownership before initial capture setup. The current branch made no harness-code changes and retained no new screenshots; it documents the exact remaining closure path and latest foreground owner.

## 2026-06-11 Checkpoint

Branch/worktree:

- Branch: `codex/ux-parity-s1-ribbon-matrix-close-20260611`
- Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\ux-parity-s1-ribbon-matrix-close-20260611`
- Base: local `main` at `e1b52f96d65ad1cba6a2871b7dde180eef386254`.

Harness update:

- `tools/screenshot_excel.ps1` and `tools/screenshot_ribbon.ps1` now retry foreground activation with restore/topmost pulse, `AttachThreadInput`, `BringWindowToTop`, `SetActiveWindow`, `SetFocus`, `SetForegroundWindow`, and a guarded Alt-key pulse before enforcing the existing foreground guard.
- Root ribbon runs now clear stale `screenshot_blocker_manifest.json` files at the start of a new root capture attempt.
- If the root foreground guard still blocks, the scripts retain a separate `screenshot_blocker_manifest.json` with expected/actual foreground ownership, requested widths/tabs, and blocker reason while still discarding root screenshot PNGs and `screenshot_manifest.json` as invalid evidence.

Retained evidence:

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -Widths 1100` completed under foreground guard.
- Retained Excel root manifest: `tools/screenshots_excel/screenshot_manifest.json`.
- Retained Excel root PNGs: `tools/screenshots_excel/excel_1100_Home.png`, `excel_1100_Insert.png`, `excel_1100_Page_Layout.png`, `excel_1100_Formulas.png`, `excel_1100_Data.png`, `excel_1100_Review.png`, `excel_1100_View.png`, and `excel_1100_Help.png`.
- Manifest status: `CaptureStatus=complete-with-skipped-unavailable-tabs`, `PlannedCaptureCount=8`, `ActualCaptureCount=8`, `SkippedTabs=Draw`.

S1 remains open because the matching FreeX root counterpart matrix was intentionally not run after the checkpoint stop request. The next smallest closure step is:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_ribbon.ps1 -Widths 1100
```

If that retains `tools/screenshots/screenshot_manifest.json` with pair keys matching the Excel 1100 manifest, the focused 1100 pair can be reviewed before expanding to the full width matrix.

## 2026-06-11 Integration Closeout

The integration pass ran the matching FreeX focused counterpart:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_ribbon.ps1 -Widths 1100
```

Retained FreeX root manifest: `tools/screenshots/screenshot_manifest.json`.
Retained FreeX root PNGs: `tools/screenshots/ribbon_1100_Home.png`, `ribbon_1100_Insert.png`, `ribbon_1100_Draw.png`, `ribbon_1100_Page_Layout.png`, `ribbon_1100_Formulas.png`, `ribbon_1100_Data.png`, `ribbon_1100_Review.png`, `ribbon_1100_View.png`, and `ribbon_1100_Help.png`.

The focused 1100px foreground pair is now retained. Excel contributes the eight tabs available in this Office profile and explicitly records `SkippedTabs=Draw`; FreeX contributes all nine top-level tabs including Draw. S1 remains open only for expanding the paired foreground matrix to the full `max,1100,900,750` width set and for Excel-paired comparison review beyond the focused 1100px baseline.
