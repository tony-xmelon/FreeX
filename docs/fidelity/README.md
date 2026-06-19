# Fidelity Workstream Summary

**Last updated:** 2026-06-19

This folder holds point-in-time XLSX and FreeW fidelity findings. Keep durable summaries here and avoid committing temporary handoff notes, downloaded sample workbooks, generated comparison outputs, or Excel ground-truth images. Local workbook binaries belong in ignored corpus folders such as `fidelity-corpus/files/`, `fidelity-corpus/runs/`, `freew-fidelity-corpus/files/`, or `freew-fidelity-corpus/runs/`.

## Current XLSX Coverage

The June 17-18 fidelity sweep covered three major workbook groups:

- `ExcelExamples1.xlsx`: 36 real-world sheets, brought to 100% recalc parity for the then-current corpus.
- Contextures samples: pivots, slicers, charts, conditional formatting, tables, dynamic arrays, comments, advanced filter, and form-control rendering.
- tealeg-xlsx fixtures: 25 edge-case workbooks, including chartsheet support and invalid-source pass-through documentation.

Durable outcome notes live in the dated files in this folder. The current corpus expansion note is [2026-06-18-xlsx-chart-pivot-corpus-growth.md](2026-06-18-xlsx-chart-pivot-corpus-growth.md).

## Deferred Fidelity Items

- ChartEx families such as funnel, treemap, sunburst, histogram, and box-and-whisker need representative non-degenerate workbook drivers before a broad renderer implementation is worth taking on.
- Form-control interactivity is intentionally separate from rendering fidelity and needs explicit product scope before wiring linked-cell behavior.
- Color emoji chart-label rendering remains an approximation in the WPF text stack.
- Dropdown list-cell number/date formatting needs a sample workbook with formatted list values.

## Harnesses

- `tools/FreeX.SheetFidelity`: functional workbook gate for load warnings, unsupported features, formula parity, round-trip validation, and source-file validation.
- `tools/FreeX.SheetGridImageCompare`: headless GridView sheet rendering and optional Excel ground-truth comparison.
- `tools/FreeX.ExcelExamplesCharts`: chart census, Excel-COM ground-truth comparison, and round-trip checks.

Excel COM capture should be serialized because `CopyPicture` and the clipboard are shared machine resources. Agents can fan out `--no-excel` comparisons against pre-captured PNGs once ground truth exists.
