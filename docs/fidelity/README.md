# Fidelity Workstream Summary

**Last updated:** 2026-06-22

This folder holds point-in-time XLSX and FreeW fidelity findings. Keep durable summaries here and avoid committing temporary handoff notes, downloaded sample workbooks, generated comparison outputs, or Excel ground-truth images. Local workbook binaries belong in ignored corpus folders such as `fidelity-corpus/files/`, `fidelity-corpus/runs/`, `freew-fidelity-corpus/files/`, or `freew-fidelity-corpus/runs/`.

## Current XLSX Coverage

The June 17-18 fidelity sweep covered three major workbook groups:

- `ExcelExamples1.xlsx`: 36 real-world sheets, brought to 100% recalc parity for the then-current corpus.
- Contextures samples: pivots, slicers, charts, conditional formatting, tables, dynamic arrays, comments, advanced filter, and form-control rendering.
- tealeg-xlsx fixtures: 25 edge-case workbooks, including chartsheet support and invalid-source pass-through documentation.

Durable outcome notes live in the dated files in this folder. Current workbook-format coverage is summarized by [2026-06-19-file-format-support-audit.md](2026-06-19-file-format-support-audit.md), with focused June 19 notes for ODS rebuild triage, LibreOffice cross-checking, and legacy XLS/XLSB handling. Current chart/PivotTable corpus expansion notes are [2026-06-18-xlsx-chart-pivot-corpus-growth.md](2026-06-18-xlsx-chart-pivot-corpus-growth.md), [2026-06-21-chart-fidelity-corpus-coverage.md](2026-06-21-chart-fidelity-corpus-coverage.md), [2026-06-22-pivottable-local-coverage.md](2026-06-22-pivottable-local-coverage.md), [2026-06-22-pivottable-complete-local-progress.md](2026-06-22-pivottable-complete-local-progress.md), [2026-06-22-pivottable-native-corpus-expansion.md](2026-06-22-pivottable-native-corpus-expansion.md), and [2026-06-22-pivottable-slicer-timeline-visual.md](2026-06-22-pivottable-slicer-timeline-visual.md).

## Current FreeW Coverage

FreeW fidelity uses the on-demand corpus in [../../freew-fidelity-corpus/README.md](../../freew-fidelity-corpus/README.md). The committed manifest currently has 134 redistributable rows and is guarded by `freew/FreeW.Core.IO.Tests/FreeWFidelityCorpusManifestTests.cs`; downloaded document binaries and run outputs stay ignored.

Durable FreeW notes:

- [2026-06-19-freew-corpus-feature-growth.md](2026-06-19-freew-corpus-feature-growth.md) - current corpus expansion note and feature coverage summary.
- [2026-06-17-freew-corpus-roundtrip.md](2026-06-17-freew-corpus-roundtrip.md) - historical 26-file round-trip baseline, now superseded by the corpus-gated test path.
- [2026-06-17-freew-word-visual-comparison.md](2026-06-17-freew-word-visual-comparison.md) - historical 26-file Word/LibreOffice visual comparison baseline.
- [2026-06-17-freew-corpus-growth-scout.md](2026-06-17-freew-corpus-growth-scout.md) - historical 26-to-48 growth scout, superseded by the June 19 134-row manifest.

## Deferred Fidelity Items

- ChartEx families now have deterministic generated workbook drivers in `generated-charts-chartex-004`; the remaining work is to add real-world samples when open-license or user-approved workbooks surface chart layouts the synthetic driver does not exercise.
- Form-control interactivity is intentionally separate from rendering fidelity and needs explicit product scope before wiring linked-cell behavior.
- Color emoji chart-label rendering remains an approximation in the WPF text stack.
- Dropdown list-cell number/date formatting needs a sample workbook with formatted list values.

## Harnesses

- `tools/FreeX.SheetFidelity`: functional workbook gate for load warnings, unsupported features, formula parity, round-trip validation, and source-file validation.
- `tools/FreeX.SheetGridImageCompare`: headless GridView sheet rendering and optional Excel ground-truth comparison, including PivotTable range mode with `--pivot-ranges --export-excel-pngs`.
- `tools/FreeX.ExcelExamplesCharts`: chart census, Excel-COM ground-truth comparison, and round-trip checks.

Excel COM capture should be serialized because `CopyPicture` and the clipboard are shared machine resources. Agents can fan out `--no-excel` comparisons against pre-captured PNGs once ground truth exists.
