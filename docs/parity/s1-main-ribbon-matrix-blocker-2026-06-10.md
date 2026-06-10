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
- The current `tools/screenshot_excel.ps1` planned tab set still includes `Draw`; a runner must either use an Excel profile where Draw is visible, or the harness/catalog expectation must be deliberately updated to record an environment-specific Excel tab set before a valid paired matrix can be retained.
- To avoid losing a successful root ribbon matrix, do not run blocked dialog/popup sub-lanes in the same artifact directory immediately afterward; guard cleanup can clear the root `tools/screenshots*/screenshot_manifest.json` and tab PNGs.

## Required Closure Run

Minimum next run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -Widths 1100
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_ribbon.ps1 -Widths 1100
```

Full closure run after the focused pair retains complete manifests:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -Widths max,1100,900,750
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_ribbon.ps1 -Widths max,1100,900,750
```

S1 can close only when both root manifests are retained and each manifest reports complete planned captures with pairable `ribbon:<WidthLabel>:<TabFileName>` keys for the agreed tab set.

## Status

S1 is not closed. This slice advances S1 by pinning the retained-evidence inventory and the exact remaining blocker.
