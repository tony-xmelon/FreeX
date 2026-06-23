# PivotTable parity pause and resume note - 2026-06-23

Scope: Windows-only local PivotTable parity against desktop Microsoft Excel. External connections, Data Model, and OLAP remain explicitly out of scope.

## Current integrated state

- `main` is integrated through commit `b3880dcbb` (`Improve PivotTable Medium12 outline styling`) and was pushed to `origin/main`.
- The native Excel-authored PivotTable corpus covers 16 workbooks and remains the current local visual-parity corpus.
- The corpus generates, saves, reopens, and visually compares successfully against Microsoft Excel-rendered PNGs.
- The visual harness writes machine-readable `metrics.json` files next to the existing text reports.
- FreeX is not yet at 100% local PivotTable visual fidelity. The current state is a strong structural baseline: all 16 generated native PivotTable workbooks render with exact Excel-vs-FreeX image dimensions, no compare command failures, and no dimension mismatches, but measurable text/chrome/style deltas remain.

## Integrated corpus coverage

The committed corpus covers:

- show items with no data (`pivotField@showAll` plus table-level `showEmptyRow`)
- compact, outline, and tabular layout matrix
- subtotal and grand-total permutations
- named-range source pivots via `NativeSalesRange`
- additional Show Values As variants, including `% of column` and running total by Month
- field chrome and pivot style option flags
- slicer and timeline coverage in the local generated corpus
- multiple PivotTables sharing one cache
- calculated field/item coverage

The generator keeps `show_items_no_data_004` Excel-authored, then patches `xl/pivotTables/pivotTable1.xml` to add `showEmptyRow="1"` because Office COM did not expose a reliable `ShowItemsWithNoDataOnRows` setter in this environment.

## Integrated fidelity work since this checkpoint began

- `4ce2982fe` (`Add PivotTable visual metrics JSON`): added `metrics.json` output to `FreeX.SheetGridImageCompare`, guarded the smoke-report schema, and produced a 16-case metrics baseline.
- `e1e7171be` (`Improve PivotTable compact row labels`): reserved Excel-style expand/collapse gutter space for compact child row labels without drawing child buttons.
- `344232324` (`Improve PivotTable Medium13 tabular styling`): applied `PivotStyleMedium13` body grid rules and loaded tabular outer row-label styling for repeated first row-field labels.
- `b3880dcbb` (`Improve PivotTable Medium12 outline styling`): split loaded native `PivotStyleMedium12` outline parent, subtotal, and grand-total surfaces so outline parent rows use Accent4 0.8, subtotal rows use Accent4 0.7, and grand-total rows remain white like Excel.

Evidence roots:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-metrics-json-20260623\full
C:\Users\ali\freex-xlsx-verify\visual\pivot-compact-label-fidelity-20260623\full
C:\Users\ali\freex-xlsx-verify\visual\pivot-loaded-style-text-20260623\full
C:\Users\ali\freex-xlsx-verify\visual\pivot-expand-collapse-size-20260623\full
C:\Users\ali\freex-xlsx-verify\visual\pivot-medium12-subtotal-20260623\full
```

## Last verified evidence

Excel smoke generation and save/reopen:

```powershell
dotnet run --project tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj -c Release -- --save-reopen --generate-excel-pivot-corpus-fixtures --out C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-gaps-20260623b
```

Outcome: `PASS: Excel validated 16/16 workbook(s)`.

Latest full visual evidence root:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-medium12-subtotal-20260623\full
```

Latest full visual outcome: 16 compared cases, 0 failed rows, 0 dimension mismatches.

Latest ranked visual metrics:

| Case | Fallback mean diff | Exact mean diff | Changed pixels | Dimension mismatches |
| --- | ---: | ---: | ---: | ---: |
| `layout_options_002` | 6.4261% | 11.9970% | 73.82% | 0 |
| `date_grouping_003` | 6.4024% | 8.8429% | 19.76% | 0 |
| `subtotal_grand_totals_004` | 6.3641% | 7.1258% | 29.05% | 0 |
| `show_items_no_data_004` | 6.1310% | 8.2832% | 18.56% | 0 |
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

Latest measured improvement:

| Case | Fallback mean before | Fallback mean after | Exact mean before | Exact mean after | Changed pixels before | Changed pixels after |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `subtotal_grand_totals_004` | 7.1965% | 6.3641% | 8.0582% | 7.1258% | 31.81% | 29.05% |

## Verification already completed for latest integrated slice

Focused core PivotTable style regression:

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --configuration Release --filter "FullyQualifiedName~PivotTableRefreshServiceTests" --logger "trx;LogFileName=pivot-medium12-core-style-tests.trx" --verbosity minimal
```

Outcome: 155 passed, 1 benchmark skipped, 0 failed.

Focused visual comparison:

```powershell
dotnet run --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release -- C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-gaps-20260623b\generated-excel-pivots\Excel_native_pivot_subtotal_grand_totals_004.xlsx --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --threshold 100 --pixel-tolerance 8 --out C:\Users\ali\freex-xlsx-verify\visual\pivot-medium12-subtotal-20260623\focused
```

Outcome: 1 compared case, 0 failed rows, 0 dimension mismatches.

Full native PivotTable visual corpus:

```powershell
dotnet run --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release -- <native-pivot-workbook> --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --threshold 100 --pixel-tolerance 8 --out <case-output>
```

Outcome: 16 compared cases, 0 failed rows, 0 dimension mismatches.

Repository lane for the latest integrated code slice:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1
dotnet build FreeX.slnx --configuration Release
dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"
```

Outcome: passed.

## Reverted or rejected experiments

- A compact text-metrics experiment was reverted before integration because it did not produce a durable visual win.
- A `PivotStyleMedium12` grand-total fill/border adjustment was reverted before integration because it worsened `subtotal_grand_totals_004`.
- A trial preference for `Arial Narrow` as the missing `Aptos Narrow` fallback worsened the focused `subtotal_grand_totals_004` evidence and was not kept.

## Read-only investigation findings preserved for resume

No read-only agent made code changes; agents were closed after reporting findings.

- Excel COM reports loaded native PivotTable cells as `Aptos Narrow` 11 pt, with bold used on style/header/subtotal surfaces. This Windows environment does not expose `Aptos Narrow` as an installed WPF/system font.
- Current WPF fallback for `ResolveCellFontForDisplay("Aptos Narrow")` is `Calibri` with condensed stretch. That is better than the rejected `Arial Narrow` experiment for the latest focused case.
- Pivot field buttons are overlay rectangles/glyphs, not normal cell style fills. Residual chrome differences are concentrated in dropdown geometry, glyph size, and text padding.
- `chrome_style_flags_004` remains the largest exact-mean residual, while `layout_options_002`, `date_grouping_003`, and `subtotal_grand_totals_004` remain the highest fallback-mean residuals.

Likely files:

- `src/FreeX.Core.Commands/PivotTableRefreshService.Styles.cs`
- `src/FreeX.App.UI/GridView.Rendering.cs`
- `src/FreeX.App.UI/GridView.Rendering.CellStyles.cs`
- `src/FreeX.App.UI/GridView.Rendering.AutoFilter.cs`
- `src/FreeX.App.UI/GridView.TextLayoutCache.cs`
- `tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.Styles.cs`
- `tests/FreeX.App.UI.Tests/GridViewThemeFontResolutionTests.cs`
- `tests/FreeX.App.UI.Tests/GridViewPivotHeaderDropdownSourceTests.cs`

## Resume checklist

1. Start a fresh isolated worktree from current `origin/main`.
2. Re-open the latest visual evidence for the top residual cases:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-medium12-subtotal-20260623\full\layout_options_002
C:\Users\ali\freex-xlsx-verify\visual\pivot-medium12-subtotal-20260623\full\date_grouping_003
C:\Users\ali\freex-xlsx-verify\visual\pivot-medium12-subtotal-20260623\full\subtotal_grand_totals_004
C:\Users\ali\freex-xlsx-verify\visual\pivot-medium12-subtotal-20260623\full\chrome_style_flags_004
```

3. Compare each case's `excel`, `freex`, and `worst` PNGs before editing.
4. Implement one focused visual fix and rerun `FreeX.SheetGridImageCompare` for the targeted workbook first.
5. Broaden to the 16-workbook native corpus only after the focused case improves without regressions.
6. Keep external connections, Data Model, and OLAP excluded from this goal.

Preferred next targets:

- `layout_options_002`: font rasterization, row-label/body layout, and residual style geometry.
- `date_grouping_003`: compact date-grouping geometry/text and button chrome.
- `subtotal_grand_totals_004`: remaining text rasterization and field-button chrome after the Medium12 style improvement.
- `chrome_style_flags_004`: PivotTable field-button/dropdown chrome and text padding.
- `show_items_no_data_004` and `named_range_source_004`: loaded native style/chrome and typography differences.

Recommended implementation order:

1. Typography/font rendering for loaded Office-authored PivotTables, especially the missing `Aptos Narrow` theme face. Keep changes behind measurable visual evidence because the `Arial Narrow` fallback was already rejected.
2. PivotTable-specific dropdown/button chrome: carry enough PivotTable axis/source/state into the renderer to split PivotTable field buttons from generic AutoFilter buttons.
3. Date-grouping and layout geometry: tune row-label/body layout only after the font/chrome surface is less noisy.
