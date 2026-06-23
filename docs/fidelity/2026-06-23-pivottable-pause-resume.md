# PivotTable parity pause and resume note - 2026-06-23

Scope: Windows-only local PivotTable parity against desktop Microsoft Excel. External connections, Data Model, and OLAP remain explicitly out of scope.

## Current integrated state

- `main` is integrated through merge commit `4ac5a45f7` (`Merge native PivotTable corpus gaps`) and was pushed to `origin/main`.
- The native Excel-authored PivotTable corpus is expanded from 10 to 16 workbooks.
- The expanded corpus generated, saved, reopened, and visually compared successfully.
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

## Last verified evidence

Excel smoke generation and save/reopen:

```powershell
dotnet run --project tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj -c Release -- --save-reopen --generate-excel-pivot-corpus-fixtures --out C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-gaps-20260623b
```

Outcome: `PASS: Excel validated 16/16 workbook(s)`.

Visual evidence root:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-gaps-20260623b\full
```

Visual outcome: 16/16 comparisons exited `0`; every case had exact Excel-vs-FreeX PNG dimensions.

Largest remaining diffs:

| Case | Diff | Exact dimensions | Exact pixel metrics |
| --- | ---: | --- | --- |
| `subtotal_grand_totals_004` | 8.7% | 747x530 | mean 9.691%, changed>8 50.61% |
| `show_items_no_data_004` | 7.9% | 512x482 | mean 10.602%, changed>8 39.31% |
| `date_grouping_003` | 7.0% | 371x218 | mean 9.572%, changed>8 22.34% |
| `layout_options_002` | 6.6% | 713x314 | mean 12.128%, changed>8 73.89% |

Focused checks that passed before integration:

```powershell
dotnet build tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj --configuration Release
dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --configuration Release --filter FullyQualifiedName~ExcelOpenSmokeReportSchemaTests --logger "trx;LogFileName=pivottable-corpus-schema-tests.trx" --verbosity minimal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1
dotnet build FreeX.slnx --configuration Release
dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"
```

Default test aggregate at integration time: `files=13 total=16769 executed=16638 passed=16638 failed=0 notExecuted=0`.

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
2. Re-open the visual evidence for `subtotal_grand_totals_004`:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-gaps-20260623b\full\subtotal_grand_totals_004
```

3. Compare `excel\excel_01_Pivot_Totals_NativePivotSubtotalGrandTotals.png`, `freex\freex_01_Pivot_Totals_NativePivotSubtotalGrandTotals.png`, and `freex\worst_01.png`.
4. Implement one focused visual fix and rerun `FreeX.SheetGridImageCompare` for that workbook first.
5. Broaden to the 16-workbook native corpus only after the focused case improves without regressions.
6. Keep external connections, Data Model, and OLAP excluded from this goal.
