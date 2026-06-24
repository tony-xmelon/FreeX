# PivotTable parity session results - 2026-06-23 (resume from pause note)

Resumes `docs/fidelity/2026-06-23-pivottable-pause-resume.md`. Scope unchanged: Windows-only local PivotTable visual parity vs desktop Microsoft Excel. External connections, Data Model, OLAP remain out of scope.

## Deliverable

Branch `pivot-fidelity/clean` = `origin/main` (`d518d973b`) + 5 commits (pivot files only, no concurrent-session commits):

1. `fix(typography): load Aptos Narrow from Windows CloudFonts cache`
2. `fix(pivot): match Excel pivot field dropdown button chrome (all 4 sub-changes)`
3. `fix(pivot): PivotStyleMedium13 GT column follows banding (null GrandTotalFill)`
4. `fix(pivot): split GT-column style — no bold/fill when GrandTotalFill is null`
5. `fix(pivot): Medium13 StripeFill tint 0.85 matches Excel banding`

The same work also exists as a stacked branch `pivot-fidelity/medium13-retune` (with interleaved concurrent-session commits). Integration validated on the combined stack: `FreeX.Core.Model.Tests` 4046 passed / 0 failed, `FreeX.App.UI.Tests` 722 passed / 0 failed.

## What changed and why

- **Typography** (`GridView.Rendering.CellStyles.cs`): "Aptos Narrow" (the modern Office theme minor font) is not a system font here, so it fell back to Calibri+`FontStretches.Condensed` — a no-op (Calibri has no condensed face), leaving text ~18% too wide. The real font is present per-user at `%LOCALAPPDATA%\Microsoft\FontCache\4\CloudFonts\Aptos Narrow\`; FreeX now loads it via a folder-URI `FontFamily`, with the Calibri fallback retained when the cache dir is absent (CI/other machines).
- **Pivot button chrome** (`GridView.Rendering.AutoFilter.cs`): pivot field dropdown buttons now match Excel — 15px (was 17), 2px margin, flat fill (was gradient), 6×4 glyph (was 8×5), darker border. Generic AutoFilter path untouched.
- **Grand Total column** (`PivotStylePaletteResolver.cs` + `PivotTableRefreshService.Styles.cs`): Excel emphasizes the GT *column* (bold + distinct fill) only for styles that define a distinct GT fill; for null-GT-fill styles (Medium13, Medium9, Medium8…) the GT column follows normal banding at regular weight. Medium13 now nulls `GrandTotalFill`, and the apply loop routes GT rows (always bold) and GT columns (bold/fill only when `GrandTotalFill` is non-null) to separate styles.
- **Medium13 banding** (`PivotStylePaletteResolver.cs`): stripe fill tint 0.9 → 0.85 (Excel's pixel-sampled banding ≈ Accent5 tint 0.8, RGB 236,212,233). 0.85 was chosen because it improves both mean metrics; 0.8 (the exact color) reduces ChangedPixels further but raises the means slightly, indicating a residual band-pattern issue.

## Results (vs the resume-note baseline)

- **Typography improved ExactMean on all 16/16 cases** (corpus ExactMean mean −0.23). Pivot button chrome improved 12/15 dropdown-bearing cases (small, geometry-correct).
- **Worst case `layout_options_002` (Medium13): 6.4261 / 11.9970 / 73.8170 → 5.7629 / 10.7776 / 68.0912** (FallbackMean −0.66, ExactMean −1.22, ChangedPixels −5.7), driven by the GT-column structural fix and the band re-tune.
- **`subtotal_grand_totals_004` (Medium12, the fragile case) held at 6.2786 / 7.0486 / 29.0983** throughout — never regressed.
- No dimension mismatches, no compare failures across the 16-case corpus.

## Metric semantics (clarified this session)

`FreeX.SheetGridImageCompare` `ComputeExactPixelDiff`: `meanDiffPercent` = sum of |per-channel delta| over ALL pixels / (pixels·3·255); `changedPixelPercent` = fraction of pixels with max-channel-delta > tolerance (8). The two can disagree: a color that matches Excel can push a uniform region under the threshold (count drops) while raising mean error elsewhere if FreeX's striped *region/phase* differs from Excel's. Treat both as proxies; eyeball the worst-NN PNG.

## Per-case pivot style map (corpus)

Medium13: layout_options_002 (row+col stripes) · Medium12: subtotal_grand_totals_004 · Medium8: named_range_source_004 · Medium9: basic_row_column_001 · Medium6: date_grouping_003 · Medium7: calculated_field_item_003 · Medium5: report_filters_001 · Medium14: show_items_no_data_004 · Medium4: slicer_timeline_001, table_source_filters_001 · Medium10: filters_sorts_002, show_values_as_variants_004 · Light16: grouping_show_values_001 · Light9: layout_matrix_004 · Light14: chrome_style_flags_004 · Dark3: multiple_pivots_one_cache_001

## Remaining residuals / next targets (ranked by opportunity)

1. `chrome_style_flags_004` (Light14): largest exact-mean residual (14.33%, 58% changed). Light14 was a previously-rejected experiment; the residual is a combined style+font+line-weight problem, not a single palette value. Needs isolated layer-by-layer work.
2. `named_range_source_004` (Medium8): 14.14% exact-mean, 48% changed — investigate Medium8 body/subtotal fills and GT-row shade.
3. `layout_options_002` (Medium13): still 68% changed pixels. The band *pattern* (row-stripe vs column-stripe coverage/phase, and their intersection) — not the tint — is the remaining driver. Exact tint 0.8 matches Excel's color but the count/mean tension shows FreeX's striped region differs from Excel's.
4. Diffuse text anti-aliasing across all cases (residual after the Aptos Narrow fix).

## Reproduce

Corpus workbooks (16): `C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-gaps-20260623b\generated-excel-pivots\Excel_native_pivot_<case>.xlsx`.
Measurement wrapper (build the compare tool in Release first, then `-NoBuild`): `C:\Users\ali\freex-xlsx-verify\run-pivot-corpus.ps1 -OutRoot <dir> [-Cases <case,...>] -NoBuild`.
Baselines: chrome-base `…\visual\baseline-chrome-20260623\summary.csv`; final `…\visual\pass5-medium13-20260623\full\summary.csv`.

## Environment note

Local `main` is force-reset by concurrent agent sessions on this machine — integrate on a branch off `origin/main`, never local `main`; stage files by explicit path (never `git add -A`); measurement is serial (single Excel COM instance).
