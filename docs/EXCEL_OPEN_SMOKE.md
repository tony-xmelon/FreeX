# Real Excel XLSX open smoke

`tools/FreeX.ExcelOpenSmoke` is a Windows-only COM smoke check for FreeX-authored `.xlsx`
files. It exists because Open XML SDK validation can pass while desktop Microsoft Excel still
rejects a workbook during `Workbooks.Open`.

Run from the repo root:

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke -- --generate-chart-fixtures
```

That command writes fresh FreeX Histogram and Waterfall workbooks under
`%USERPROFILE%\freex-xlsx-verify\excel-smoke\<timestamp>\generated`, stages the exact files Excel
will open under the same run directory, and opens each workbook through desktop Excel COM.

To check existing generated files:

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke -- C:\Users\anton\freex-xlsx-verify\H_histogram_fixed.xlsx C:\Users\anton\freex-xlsx-verify\I_waterfall_fixed.xlsx
```

Operational details:

- The process sets `Thread.CurrentThread.CurrentCulture` and `CurrentUICulture` to `en-US` before
  creating `Excel.Application`.
- Inputs are copied to a staging directory under `%USERPROFILE%`; the tool rejects output
  directories outside `%USERPROFILE%` to avoid `%TEMP%` Protected View behavior.
- Excel is launched with `Visible=false`, `DisplayAlerts=false`, and normal-load `Workbooks.Open`.
- A COM rejection with `0x800A03EC` is reported as an Excel-open failure.
- The tool tracks the Excel PID it creates and kills orphan `EXCEL` processes that were not present
  before the smoke run.

Expected use for chartEx work:

1. Integrate the chartEx package-wiring change.
2. Run the generated-fixture command above.
3. Treat exit code `0` as "real Excel opened every workbook"; any non-zero exit means the generated
   files still need package repair before handoff.
