# PivotTable parity pause and resume note - 2026-06-23

Scope: Windows-only local PivotTable parity against desktop Microsoft Excel. External connections, Data Model, and OLAP remain explicitly out of scope.

## Current integrated state

- `main` is integrated through commit `344232324` (`Improve PivotTable Medium13 tabular styling`) and was pushed to `origin/main`.
- The native Excel-authored PivotTable corpus is expanded from 10 to 16 workbooks.
- The expanded corpus generated, saved, reopened, and visually compared successfully.
- The visual harness now writes machine-readable `metrics.json` files next to the existing report text.
- The current result is not 100% visual fidelity. It is a strong structural baseline: all 16 generated native PivotTable workbooks rendered with exact Excel-vs-FreeX image dimensions and the visual compare tool returned exit code `0` for every case.

## Integrated corpus growth

The committed corpus now covers:

- show items with no data (`pivotField@showAll` plus table-level `showEmptyRow`)
- compact, outline, and tabular layout matrix
- subtotal and grand-total permutations
- named-range source pivots via `NativeSalesRange`
- additional Show Values As variants, including `% of column` and running total by Month
- field chrome and pivot style option flags

The generator keeps `show_items_no_data_004` Excel-authored, then patches `xl/pivotTables/pivotTable1.xml` to add `showEmptyRow="1"` because Office COM did not expose a reliable `ShowItemsWithNoDataOnRows` setter in this environment.

## Integrated fidelity work since the first pause note

- `4ce2982fe` (`Add PivotTable visual metrics JSON`): added `metrics.json` output to `FreeX.SheetGridImageCompare`, guarded the smoke-report schema, and produced a 16-case metrics baseline.
- `e1e7171be` (`Improve PivotTable compact row labels`): reserved Excel-style expand/collapse gutter space for compact child row labels without drawing child buttons.
- `344232324` (`Improve PivotTable Medium13 tabular styling`): applied `PivotStyleMedium13` body grid rules and loaded tabular outer row-label styling for repeated first row-field labels.

Evidence roots:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-metrics-json-20260623\full
C:\Users\ali\freex-xlsx-verify\visual\pivot-compact-label-fidelity-20260623\full
C:\Users\ali\freex-xlsx-verify\visual\pivot-loaded-style-text-20260623\full
```

## Last verified evidence

Excel smoke generation and save/reopen:

```powershell
dotnet run --project tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj -c Release -- --save-reopen --generate-excel-pivot-corpus-fixtures --out C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-gaps-20260623b
```

Outcome: `PASS: Excel validated 16/16 workbook(s)`.

Original corpus-growth visual evidence root:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-gaps-20260623b\full
```

Latest visual evidence root:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-loaded-style-text-20260623\full
```

Latest visual outcome: 16/16 comparisons exited `0`; every case had exact Excel-vs-FreeX PNG dimensions.

Latest ranked visual metrics:

| Case | Fallback mean diff | Exact mean diff | Changed pixels | Dimension mismatches |
| --- | ---: | ---: | ---: | ---: |
| `subtotal_grand_totals_004` | 7.2025% | 8.0647% | 31.88% | 0 |
| `layout_options_002` | 6.4298% | 12.0053% | 73.82% | 0 |
| `date_grouping_003` | 6.4129% | 8.8561% | 19.84% | 0 |
| `show_items_no_data_004` | 6.1368% | 8.2908% | 18.66% | 0 |
| `named_range_source_004` | 5.9830% | 14.3672% | 48.26% | 0 |
| `basic_row_column_001` | 5.4726% | 12.3692% | 23.29% | 0 |
| `chrome_style_flags_004` | 5.4038% | 14.6442% | 58.03% | 0 |
| `layout_matrix_004` | 4.7904% | 11.6374% | 40.77% | 0 |
| `table_source_filters_001` | 4.3522% | 13.2684% | 33.92% | 0 |
| `grouping_show_values_001` | 4.1474% | 10.5120% | 47.92% | 0 |
| `report_filters_001` | 3.6842% | 10.3939% | 23.45% | 0 |
| `filters_sorts_002` | 3.2170% | 11.9698% | 36.27% | 0 |
| `show_values_as_variants_004` | 2.5840% | 9.8219% | 22.70% | 0 |
| `slicer_timeline_001` | 2.3562% | 8.3122% | 38.54% | 0 |
| `calculated_field_item_003` | 2.1645% | 9.4053% | 24.77% | 0 |
| `multiple_pivots_one_cache_001` | 1.9556% | 7.2527% | 22.22% | 0 |

Measured improvements from the latest two fidelity slices:

| Case | Baseline fallback mean | Current fallback mean | Baseline exact mean | Current exact mean |
| --- | ---: | ---: | ---: | ---: |
| `date_grouping_003` | 6.8965% | 6.4129% | 9.4397% | 8.8561% |
| `layout_options_002` | 6.6075% | 6.4298% | 12.1284% | 12.0053% |
| `layout_matrix_004` | 4.8986% | 4.7904% | 11.8461% | 11.6374% |

Focused checks that passed before integration:

```powershell
dotnet build tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj --configuration Release
dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --configuration Release --filter FullyQualifiedName~ExcelOpenSmokeReportSchemaTests --logger "trx;LogFileName=pivottable-corpus-schema-tests.trx" --verbosity minimal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1
dotnet build FreeX.slnx --configuration Release
dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"
```

Latest default-lane aggregate at integration time: `Total=16766 Executed=16635 Passed=16635 Failed=0 NotExecuted=0`.

Note: one aggregate default-lane run hit the known `CommentNavigationPlannerTests.NextComment_UsesIndexedLookupForLargeOrderedLists` timing flake by 4 ms. The exact focused test passed in 95 ms, then the full default lane passed cleanly on rerun.

## Reverted experiments

- A compact text-metrics experiment was reverted before integration because it did not produce a durable visual win.
- A `PivotStyleMedium12` grand-total fill/border adjustment was reverted before integration because it worsened `subtotal_grand_totals_004` from 7.2025% to 7.3813% fallback mean diff.

## Read-only agent findings preserved for resume

No agent made code changes; all four agents were closed after reporting read-only findings.

Recommended implementation order:

1. `subtotal_grand_totals_004`: inspect GridView gridline suppression and loaded native PivotTable style materialization. The range geometry matches Excel, but FreeX visibly draws normal sheet gridlines through the white PivotTable body while Excel suppresses them.
2. Typography/rendering: the residual diff is also dominated by lighter FreeX text. Agents identified the relevant areas as `GridView.Rendering.CellStyles.cs`, `GridView.TextLayoutCache.cs`, and the loaded Pivot style font preservation path in `PivotTableRefreshService.Styles.cs`.
3. Pivot chrome: split PivotTable field buttons away from generic AutoFilter chrome in `GridView.Rendering.AutoFilter.cs`, then tighten expand/collapse glyph rendering.
4. Add regression coverage around the visual deltas before broadening the corpus again.

Specific likely files:

- `src/FreeX.Core.Commands/PivotTableRefreshService.Styles.cs`
- `src/FreeX.App.UI/GridView.Rendering.cs`
- `src/FreeX.App.UI/GridView.Rendering.CellStyles.cs`
- `src/FreeX.App.UI/GridView.Rendering.AutoFilter.cs`
- `src/FreeX.App.UI/GridView.TextLayoutCache.cs`
- `tests/FreeX.App.Host.Logic.Tests/PivotLoadedStyleApplicationTests.cs`
- `tests/FreeX.App.UI.Tests/GridViewThemeFontResolutionTests.cs`
- `tests/FreeX.App.UI.Tests/GridViewPivotHeaderDropdownSourceTests.cs`

## Resume checklist

1. Start a fresh isolated worktree from current `origin/main`.
2. Re-open the latest visual evidence for `subtotal_grand_totals_004`:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-loaded-style-text-20260623\full\subtotal_grand_totals_004
```

3. Compare `excel\excel_01_Pivot_Totals_NativePivotSubtotalGrandTotals.png`, `freex\freex_01_Pivot_Totals_NativePivotSubtotalGrandTotals.png`, and `freex\worst_01.png`.
4. Implement one focused visual fix and rerun `FreeX.SheetGridImageCompare` for that workbook first.
5. Broaden to the 16-workbook native corpus only after the focused case improves without regressions.
6. Keep external connections, Data Model, and OLAP excluded from this goal.

Preferred next targets:

- `subtotal_grand_totals_004`: text weight/rasterization, subtotal/grand-total chrome, and field-button details.
- `date_grouping_003`: compact date-grouping geometry/text and button chrome.
- `show_items_no_data_004` and `named_range_source_004`: loaded native style/chrome and typography differences.
- `layout_options_002`: remaining font rasterization, field-button chrome, and residual grid/fill details.
