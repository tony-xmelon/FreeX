# FreeW table omitted-layout autofit parity (2026-08-02)

## Result

Word treats an omitted `w:tblLayout` as content autofit. `DocxReader` now maps every table layout except explicit `w:type="fixed"` to `AutoFitMode.Contents`, while preserving imported preferred width and `w:tblGrid` widths.

## Verification

- Focused omitted/fixed/explicit-autofit package contracts: 3/3 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Fresh Word COM export: 11/11 table fixtures at 816x1056 through flat `C:\Temp` PDF staging.
- WPF control: `05-cell-shading_p1.png` stayed byte-identical after the semantic reader change (`AA2F6CA6CC209768626A65A7FAC81B1E1E56D1F9B5D9221CB19900F328F5B8FF`).

## Rejected probe

Letting WPF ignore imported grid widths for every omitted-layout table was rejected. It modestly improved some fixtures but regressed custom borders, vertical text, nested tables, and the authored-width fixture. Content-autofit geometry therefore needs an explicit measured width plan rather than WPF's default table allocator.

## Process rule

Model Word's omitted/default package semantics independently from host raster calibration. Keep the semantic correction when package tests pass and current rendering is byte-stable; accept a host autofit strategy only against the complete affected table corpus.
