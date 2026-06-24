# PivotTable parity — continued session (waves 1–4), 2026-06-24

Continues `2026-06-23-pivottable-parity-session-results.md`. Scope unchanged: Windows-only local PivotTable visual parity vs desktop Microsoft Excel. External connections, Data Model, OLAP out of scope. Measurement is serial (single Excel COM instance); all changes gated on the 16-workbook native corpus.

## Deliverable

Branch `pivot-fidelity/wave4-groupheader` = `origin/main` (`d518d973b`) + 10 pivot fixes + 1 doc, a clean linear pivot-only stack (verified no concurrent-session commits interleaved):

```
82e39b357 fix(pivot): drop GT-column borders when GrandTotalFill is null
5cee6227f fix(pivot): Medium10 GrandTotalFill=null matches Excel (no fill on GT row)
adbc03510 fix(pivot): gate row-stripe label-col exclusion to BodyFill-null palettes
ca527193c fix(pivot): add explicit PivotStyleMedium8 neutral-grey palette arm
70ca644d0 fix(pivot): route Light9→Accent1 and Light14→Accent6 through ThemedLightPalette
177055726 docs(fidelity): 2026-06-23 session results
653a71f4e fix(pivot): Medium13 StripeFill tint 0.85
46fef2b29 fix(pivot): split GT-column style — no bold/fill when GrandTotalFill is null
2f6575e30 fix(pivot): PivotStyleMedium13 GT column follows banding (null GrandTotalFill)
afd33b502 fix(pivot): match Excel pivot field dropdown button chrome
965bd4a68 fix(typography): load Aptos Narrow from Windows CloudFonts cache
```

Integration validated: Core.Model + App.UI test suites pass on the combined stack.

## What landed (waves 1–4 this continuation)

- **Wave 1 — unmapped-style palettes.** Light14→Accent6 and Light9→Accent1 routed through `ThemedLightPalette` (they were hitting the hard-coded `LightPalette()` blue-grey fallback); explicit `PivotStyleMedium8` neutral-grey arm (it was hitting the generic blue Medium fallback). `named_range_source_004` (Medium8): ExactMean 14.14→10.40, ChangedPixels 48.6→21.7.
- **Wave 2 — header-bold removal: TESTED AND REVERTED.** Hypothesis "Excel renders pivot headers non-bold" was disproven by the corpus (mean worsened; `slicer_timeline_001` regressed +2.37%). Excel DOES bold pivot headers. No commit.
- **Wave 3 — band guard + Medium10 GT.** `isRowStripe` now excludes row-label columns ONLY for null-BodyFill palettes (Light14 label cells go white like Excel; Medium13 keeps striping): `chrome_style_flags_004` ChangedPixels 58.2→48.9. Medium10 GrandTotalFill set null — sampling DISPROVED the "full orange GT" claim; Excel's Medium10 GT row is no-fill: `filters_sorts_002` 11.34→9.90.
- **Wave 4 — GT-column borders + group-header (partial).** Dropped GT-column top/bottom borders for null-GT-fill styles (Excel draws none): small clean win on `basic_row_column_001`, `named_range_source_004`, `layout_options_002`. The outline/first-of-group row-fill hypothesis was TESTED AND REVERTED (didn't move `layout_options_002`, regressed `subtotal_grand_totals_004` and `show_items_no_data_004`). The GT-ROW force-overwrite (Stage C) was NOT attempted — deemed too risky given the fragile-case sensitivity demonstrated by the reverted Stage A.

## Cumulative results (original session baseline → final)

Corpus mean ExactMean **10.64 → 9.94**. No dimension mismatches, no compare failures, `subtotal_grand_totals_004` (fragile) never regressed.

| Case | Style | Exact: orig → final | Changed%: orig → final |
| --- | --- | --- | --- |
| named_range_source_004 | Medium8 | 14.37 → 10.35 | 48.3 → 21.7 |
| filters_sorts_002 | Medium10 | 11.97 → 9.90 | 36.3 → 23.7 |
| chrome_style_flags_004 | Light14 | 14.64 → 13.71 | 58.0 → 48.9 |
| layout_options_002 | Medium13 | 12.00 → 10.75 | 73.8 → 68.1 |
| show_values_as_variants_004 | Medium10 | 9.82 → 9.40 | 22.7 → 20.9 |
| table_source_filters_001 | Medium4 | 13.27 → 12.96 | 33.9 → 34.0 |
| basic_row_column_001 | Medium9 | 12.37 → 12.05 | 23.3 → 23.4 |
| layout_matrix_004 | Light9 | 11.63 → 11.31 | 40.8 → 40.9 |
| (plus typography improving all 16 cases earlier) | | | |

## Practical floor reached — why "100%" pixel-identical is not attainable

Remaining residuals are dominated by rendering-engine differences, not style bugs:
1. **Text anti-aliasing floor (~7–8% ExactMean).** WPF GridView vs Excel GDI/DirectWrite rasterize Aptos Narrow differently at 11pt. Clean cases sit at this floor: `subtotal_grand_totals_004` 7.05, `multiple_pivots_one_cache_001` 7.10, `show_items_no_data_004` 8.09.
2. **Row∩column stripe-intersection layering** (`layout_options_002`): Excel layers row-band and column-band dxf so the intersection is a distinct shade; FreeX applies one fill per cell. 68% changed but only 10.75 mean = small, widespread, sub-perceptual deltas. The band-tint already sits at the count/mean Pareto frontier (0.85 chosen for mean; 0.80 matches color but trades mean for count).
3. **Native filter/dropdown button bitmaps** (`chrome_style_flags_004` and others with field buttons): Excel paints a native combobox glyph FreeX approximates.

## Remaining items if pushing further (ranked, with risk)

1. `table_source_filters_001` / `slicer_timeline_001` GT-ROW fill preserved-wrongly on loaded-native (Medium4): force GT-row pattern overwrite under preserve mode. ~5% on 2 cases. HIGH RISK — same category reverted twice; Stage A showed fragile-case sensitivity. Gate hard on `subtotal_grand_totals_004`.
2. `slicer_timeline_001`: residual is the slicer/timeline WIDGET chrome (different color scheme), separate from the pivot.
3. `chrome_style_flags_004`: native dropdown-button glyph parity — engine-level.
4. `layout_options_002`: a 4-state stripe model (plain / row / col / both) to match Excel's intersection layering — non-trivial renderer change for one corpus case.

## Reproduce

Corpus: `…\excel-smoke\pivot-native-corpus-gaps-20260623b\generated-excel-pivots\Excel_native_pivot_<case>.xlsx`. Wrapper (build compare tool Release first, then `-NoBuild`): `…\run-pivot-corpus.ps1 -OutRoot <dir> [-Cases <c,...>] -NoBuild`. Final corpus evidence: `…\visual\wave4-stageB-clean-20260624\full\summary.csv`.

## Environment

Local `main` is force-reset by concurrent agent sessions — integrate on a branch off `origin/main`; stage files by explicit path (never `git add -A`).
