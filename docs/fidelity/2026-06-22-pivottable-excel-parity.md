# PivotTable Excel parity checkpoint - 2026-06-22

Scope: Windows-only FreeX vs desktop Microsoft Excel PivotTable parity, using the generated PivotTable corpus rows, the Excel-authored smoke fixture, and the real-world fidelity corpus filtered to PivotTable workbooks.

## Harness Results

- Generated supported PivotTable corpus rows passed desktop Excel open/save/reopen after FreeX resave: `generated-pivots-001`, `generated-pivots-filters-002`, and `generated-pivot-calculated-fields-003` at `C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-corpus-20260622-083357`.
- Excel-authored native PivotTable fixture passed the same FreeX load/save -> Excel open/save/reopen -> FreeX reload path with 1 PivotTable and 1 pivot cache preserved at `C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-excel-authored-20260622-083426`.
- Real-world PivotTable fidelity batch passed 8 of 9 files, failed 0, skipped 1 at `fidelity-corpus/runs/pivot-parity-20260622-083236`.

## Fixed Disparity

`historypivot.xls` previously matched cell values but reported inventory differences:

- `sheets: FreeX=3 Excel=2`
- `pivotTables: FreeX=0 Excel=1`

The workbook contains a legacy BIFF PivotTable definition on `Financial History PivotTable`, a hidden source worksheet, and a hidden dialog sheet. FreeX now imports minimal legacy BIFF PivotTable metadata from NPOI PivotTable records, including the table name, target range, cache id, row/column/page fields, and data field. The fidelity inspector now counts Excel-comparable worksheets by excluding FreeX `DialogSheet` entries, matching Excel COM `Worksheets.Count` without dropping the preserved dialog sheet from the model.

Rerun result: `historypivot.xls` passes with 3054 compared cells, 0 value mismatches, and inventory ok.

## Remaining Disparity

`officecli-pivot-tables.xlsx` is still skipped because desktop Excel COM automation failed before comparison:

- FreeX loaded the workbook.
- Excel open/inventory failed with `MissingMemberException: Could not get dispatch ID for Rows (error: 0x80010001)`.

This is tracked as a harness/Excel automation issue rather than a FreeX PivotTable load failure. The row remains useful corpus coverage once the COM read path is hardened for that workbook.

## Verification

```powershell
dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~LegacyXlsFileAdapterTests" --logger "trx;LogFileName=legacy-xls-pivot-tests.trx"
dotnet build tools\FreeX.FidelityCompare\FreeX.FidelityCompare.csproj --configuration Release
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-FidelityBatch.ps1 -Filter pivot -Out fidelity-corpus\runs\pivot-parity-20260622-083236 -Tolerance 0.5
```
