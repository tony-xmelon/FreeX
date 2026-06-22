# PivotTable complete local fidelity progress - 2026-06-22

Scope: Windows-only FreeX vs desktop Microsoft Excel PivotTable parity for local/native PivotTables. External connections, workbook Data Model execution, and OLAP refresh semantics remain explicitly out of scope.

## Progress

- `tools/FreeX.SheetGridImageCompare` now resolves PivotTable visual ranges through Excel COM `PivotTable.TableRange2` when `--pivot-ranges --export-excel-pngs` is used. FreeX renders the same range Excel exported, and the report labels the range source.
- If Excel exposes only a single-cell PivotTable range, the visual harness falls back to the fuller FreeX/materialized-cell range when available and records that provenance instead of silently comparing only an anchor.
- `tools/FreeX.ExcelOpenSmoke` refreshes generated Excel-authored native PivotTables before saving, so the local native corpus carries materialized PivotTable bodies for visual comparison.
- The table-source/filter native fixture now uses a row item filter that saves a visible PivotTable body. The prior report-filter variant stayed anchor-only in this COM generation path.

## Evidence

Generated native corpus:

```powershell
dotnet run --project tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj -c Release -- --save-reopen --generate-excel-pivot-corpus-fixtures --out C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-complete-local-20260622e
```

Outcome: `PASS: Excel validated 4/4 workbook(s).`

Visual comparison:

```powershell
$base='C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-complete-local-20260622e\generated-excel-pivots'
$out='C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-complete-local-20260622e'
Get-ChildItem $base -Filter '*.xlsx' | ForEach-Object {
  dotnet run --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj -c Release -- $_.FullName --pivot-ranges --export-excel-pngs --out (Join-Path $out $_.BaseName) --threshold 25
}
```

Outcome: all four workbooks passed; five PivotTable ranges were compared using `ExcelTableRange2`.

- `Pivot Basic!A3:E9`: diff `6.2%`
- `Pivot Buckets!A3:E9`: diff `3.3%`
- `Pivot Shared Cache!A3:B8`: diff `6.9%`
- `Pivot Shared Cache!F3:G7`: diff `14.5%`
- `Pivot Filters!A3:E8`: diff `7.9%`

The table-source/filter fixture previously compared only `A3:A3`; it now compares `A3:E8`.

## Remaining Non-External Gaps

- True Excel grouping metadata still needs native Excel-authored coverage, especially date grouping that writes `fieldGroup` metadata rather than explicit helper source columns.
- Table-name PivotCache sources need semantic package/load/save coverage. The visual fixture remains table-range backed because the table-name COM path used here produced anchor-only output.
- Native label filters, value filters, and sorts need Excel-authored corpus rows and semantic assertions.
- Native calculated fields/items need Excel-authored coverage beyond the existing synthetic IO tests.
- Layout/options breadth needs native rows for compact, outline, and tabular layouts; grand-total toggles; top subtotals; blank lines; repeated labels; field headers off; and style-option flags.
- Pixel comparison still uses an exploratory threshold. A stricter completion gate should report native image dimensions and range dimensions separately before mean-pixel diff.
