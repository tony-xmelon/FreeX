# PivotTable expand/collapse chrome fidelity - 2026-06-23

Scope: Windows-only local PivotTable parity against desktop Microsoft Excel. External connections, Data Model, and OLAP remain explicitly out of scope.

## Completed in this slice

- Tightened the PivotTable expand/collapse box from 10 px to 8 px to better match Excel's rendered outline/group chrome.
- Added focused source coverage so the PivotTable row-label adornment constants stay tied to the visual-parity expectation.
- Rejected two broader experiments before integration:
  - Forcing materialized body borders in loaded PivotTable style rendering produced no measurable visual movement on `subtotal_grand_totals_004`.
  - Preferring Arial Narrow over the existing Calibri-condensed fallback for missing `Aptos Narrow` worsened the same focused case.
- Preserved read-only agent findings for the next pass around field-button/dropdown chrome and subtotal/grand-total style residuals.

This is not a 100% PivotTable-fidelity checkpoint. The accepted change is a small, measured visual improvement that did not regress fallback or exact mean metrics in the 16-case native PivotTable corpus.

## Visual evidence

Baseline evidence:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-loaded-style-text-20260623\full
```

Current evidence:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-expand-collapse-size-20260623\full
```

Machine-readable delta:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-expand-collapse-size-20260623\full\delta-vs-pivot-loaded-style-text.csv
```

The full run compared all 16 native PivotTable cases with 0 failed rows and 0 dimension mismatches.

Delta summary versus `pivot-loaded-style-text-20260623`:

| Metric | Improved cases | Regressed cases |
| --- | ---: | ---: |
| Fallback mean diff | 5 | 0 |
| Exact mean diff | 5 | 0 |
| Changed pixels | 4 | 1 |

Largest fallback-mean improvements:

| Case | Fallback mean before | Fallback mean after | Delta |
| --- | ---: | ---: | ---: |
| `date_grouping_003` | 6.4129% | 6.4024% | -0.0105 |
| `subtotal_grand_totals_004` | 7.2025% | 7.1965% | -0.0060 |
| `show_items_no_data_004` | 6.1368% | 6.1310% | -0.0058 |
| `layout_options_002` | 6.4298% | 6.4261% | -0.0037 |
| `layout_matrix_004` | 4.7904% | 4.7888% | -0.0017 |

Current ranked full-corpus metrics:

| Case | Fallback mean diff | Exact mean diff | Changed pixels | Dimension mismatches |
| --- | ---: | ---: | ---: | ---: |
| `subtotal_grand_totals_004` | 7.1965% | 8.0582% | 31.81% | 0 |
| `layout_options_002` | 6.4261% | 11.9970% | 73.82% | 0 |
| `date_grouping_003` | 6.4024% | 8.8429% | 19.76% | 0 |
| `show_items_no_data_004` | 6.1310% | 8.2832% | 18.59% | 0 |
| `named_range_source_004` | 5.9830% | 14.3672% | 48.26% | 0 |
| `basic_row_column_001` | 5.4726% | 12.3692% | 23.29% | 0 |
| `chrome_style_flags_004` | 5.4038% | 14.6442% | 58.03% | 0 |
| `layout_matrix_004` | 4.7888% | 11.6343% | 40.78% | 0 |
| `table_source_filters_001` | 4.3522% | 13.2684% | 33.92% | 0 |
| `grouping_show_values_001` | 4.1474% | 10.5120% | 47.92% | 0 |
| `report_filters_001` | 3.6842% | 10.3939% | 23.45% | 0 |
| `filters_sorts_002` | 3.2170% | 11.9698% | 36.27% | 0 |
| `show_values_as_variants_004` | 2.5840% | 9.8219% | 22.70% | 0 |
| `slicer_timeline_001` | 2.3562% | 8.3122% | 38.54% | 0 |
| `calculated_field_item_003` | 2.1645% | 9.4053% | 24.77% | 0 |
| `multiple_pivots_one_cache_001` | 1.9556% | 7.2527% | 22.22% | 0 |

## Focused checks

Focused UI/source regression:

```powershell
dotnet test tests\FreeX.App.UI.Tests\FreeX.App.UI.Tests.csproj --configuration Release --filter FullyQualifiedName~GridViewPivotHeaderDropdownSourceTests --logger "trx;LogFileName=pivot-expand-collapse-ui-tests.trx" --verbosity minimal
```

Outcome: 3 passed, 0 failed.

Full native PivotTable visual corpus:

```powershell
dotnet run --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release -- <native-pivot-workbook> --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --threshold 100 --pixel-tolerance 8 --out <case-output>
```

Outcome: 16 compared cases, 0 failed rows, 0 dimension mismatches.

## Agent findings retained for resume

Field-button/dropdown chrome explorer:

- Pivot field buttons are overlay rectangles/glyphs rather than cell styles.
- `chrome_style_flags_004` is likely still affected by 17 px dropdown chrome.
- `date_grouping_003` may also benefit from tighter button geometry.
- `layout_options_002` has no dropdowns, so its remaining diff is body/text/layout rather than dropdown chrome.
- Suggested next step: carry axis/source/state into `PivotHeaderDropdownButton`, add dropdown-cell text padding, then tune `chrome_style_flags_004` before broadening to `date_grouping_003`.

Subtotal/grand-total style explorer:

- `subtotal_grand_totals_004` uses `PivotStyleMedium12`, outline layout, and `location ref="A3:E22" firstHeaderRow="1" firstDataRow="2" firstDataCol="2"`.
- The rejected Medium12 grand-total fill/border experiment worsened the focused case because the broad bands are already close.
- Remaining diff is dominated by text ink/position plus subtle body/gridline and chrome differences.
- Suggested next step: inspect exact loaded styles and prefer one focused visual change before running the full corpus.

## Remaining gaps

FreeX is still not at 100% local PivotTable visual fidelity. The next highest-impact non-external targets are:

- `subtotal_grand_totals_004`: text weight/rasterization, subtotal/grand-total chrome, and field-button details.
- `date_grouping_003`: compact date-grouping geometry/text and button chrome.
- `show_items_no_data_004` and `named_range_source_004`: loaded native style/chrome and typography differences.
- `layout_options_002`: remaining font rasterization, field-button chrome, and residual grid/fill details.

Recommended restart path:

1. Start from current `origin/main` in a fresh isolated worktree.
2. Open `C:\Users\ali\freex-xlsx-verify\visual\pivot-expand-collapse-size-20260623\full\subtotal_grand_totals_004`.
3. Compare the Excel, FreeX, and `worst_01.png` images before changing code.
4. Make one focused visual change, prove movement on the focused case, then rerun the 16-workbook corpus.
