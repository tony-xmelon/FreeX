# PivotTable local parity coverage - 2026-06-22

Scope: Windows-only FreeX vs desktop Microsoft Excel PivotTable parity coverage, excluding external connection execution, workbook Data Model execution, and OLAP refresh semantics.

## What Changed

- `tools/FreeX.FidelityCompare` now retries transient Excel COM busy failures around worksheet `UsedRange` and inventory reads. The previous OfficeCLI skip surfaced as `Rows` dispatch failure, but the HRESULT was `RPC_E_CALL_REJECTED`; the workbook is now comparable instead of skipped.
- `tools/FreeX.ExcelOpenSmoke` can now generate a bounded Excel-authored native PivotTable corpus with `--generate-excel-pivot-corpus-fixtures`.
- `tools/FreeX.SheetGridImageCompare` can now run PivotTable range visual comparison with `--pivot-ranges --export-excel-pngs`, exporting Excel range PNGs and comparing them with FreeX GridView renders.

## Native PivotTable Corpus

The new Excel-authored corpus generator creates four non-external `.xlsx` fixtures:

- `Excel_native_pivot_basic_row_column_001.xlsx`
- `Excel_native_pivot_table_source_filters_001.xlsx`
- `Excel_native_pivot_grouping_show_values_001.xlsx`
- `Excel_native_pivot_multiple_pivots_one_cache_001.xlsx`

These cover worksheet/table-backed native PivotTables, report filters, row/column/data fields, multiple summary functions, show-values-as, built-in PivotTable styles, and multiple PivotTables sharing one cache. The grouping/show-values fixture uses explicit month and bucket source fields; true Excel grouping metadata remains a narrower follow-up because COM grouping calls are version-sensitive.

Run result:

```powershell
dotnet run --project tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj -c Release -- --save-reopen --generate-excel-pivot-corpus-fixtures --out C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-20260622-local
```

Outcome: `PASS: Excel validated 4/4 workbook(s).`

## Visual Range Comparison

The PivotTable visual gate exports matching PivotTable target ranges from Excel and FreeX, then computes the existing mean pixel diff. This avoids whole-sheet pagination, margin, and blank-area noise.

Run:

```powershell
$base='C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-20260622-local\generated-excel-pivots'
$out='C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-20260622'
Get-ChildItem $base -Filter '*.xlsx' | ForEach-Object {
  dotnet run --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj -c Release -- $_.FullName --pivot-ranges --export-excel-pngs --out (Join-Path $out $_.BaseName) --threshold 25
}
```

Outcome: all four workbooks passed; five PivotTable ranges were compared. Worst observed diff was `14.5%` on the shared-cache count PivotTable, under the current `25%` exploratory gate.

Known visual-gate limitation: Excel may emit single-cell PivotTable location refs for some freshly anchored/filter-heavy tables. The comparer honors the loaded target range, so that case currently compares the single anchor cell rather than inferring the full visible table. Functional comparison still covers the workbook values.

## Real-World Functional Batch

Run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-FidelityBatch.ps1 -Filter pivot -Out fidelity-corpus\runs\pivot-local-coverage-20260622 -SkipFetch -Tolerance 0.5
```

Outcome: `Pass 9/9  Fail 0  Skipped 0`.

Notable result: `officecli-pivot-tables.xlsx` now passes comparison with `2106` compared cells, `4` tolerated value mismatches, and inventory ok.

The filename-filtered batch includes `openxmlsdk-olap-pivot-a3.xlsx`; this result only proves load/value/package comparison for the workbook as saved. OLAP/external/data-model execution and refresh semantics remain intentionally out of scope for this goal.
