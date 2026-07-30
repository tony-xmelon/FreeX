# Avalonia parity Wave70: FreeW Font and Paragraph dialog chrome

This follow-up slice refines the ten canonical FreeW Font and Paragraph dialog
states from the Wave69 focused comparison. WPF remains the visual authority;
no WPF production source, comparison threshold, or classification policy was
changed.

## Implementation

- Restored WPF-like borders for non-editable dialog combo boxes and disabled
  numeric fields.
- Aligned the compact checkbox glyph to the measured 14 x 13 painted WPF
  frame while preserving its 18 px interaction row.
- Tuned Font tab margins, checkbox row spacing, and foreground color to the
  authority capture.
- Added focused assertions for the disabled field border and measured checkbox
  indicator geometry.

## Fresh focused evidence

The fresh capture was generated from the current source with the canonical
focused inventory at 96 DPI:

- WPF: `artifacts/freew-wave70-font-paragraph-20260730/wpf-fresh` - 10/10
  captured.
- Avalonia: `artifacts/freew-wave70-font-paragraph-20260730/avalonia-fresh` -
  10/10 captured with valid content.
- Paired report: `artifacts/freew-wave70-font-paragraph-20260730/compare-fresh`
  - 10/10 `genuine-visual-mismatch`, with zero missing, unsupported, or
  invalid-content rows.

The arithmetic route averages below are calculated directly from the current
source comparison rows. The baseline is the preserved Wave69-focused
`compare` report, not a recaptured or modified WPF surface.

| Route | Baseline changed | Fresh changed | Delta | Baseline mean | Fresh mean | Delta |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `font` | 11.488% | 8.016% | -3.472 pp | 10.302 | 7.519 | -2.783 |
| `paragraph` | 8.594% | 8.345% | -0.249 pp | 10.032 | 9.807 | -0.225 |

The machine-readable per-state values are in
`avalonia-parity-wave70-freew-font-paragraph-20260730-metrics.json`.

## Per-state audit

Every current row remains a `genuine-visual-mismatch`; the improved metrics do
not relabel any state as a visual pass.

| State | Changed delta | Mean delta | pHash | Result |
| --- | ---: | ---: | ---: | --- |
| `font.initial` | -3.348 pp | -2.590 | 7 -> 2 | improved |
| `font.populated` | -3.356 pp | -2.617 | 7 -> 2 | improved |
| `font.tab-advanced` | -3.943 pp | -3.474 | 1 -> 2 | improved |
| `font.tab-font` | -3.356 pp | -2.611 | 7 -> 2 | improved |
| `font.validation-error` | -3.356 pp | -2.625 | 7 -> 2 | improved |
| `paragraph.initial` | -0.315 pp | -0.216 | 2 -> 2 | improved |
| `paragraph.populated` | -0.315 pp | -0.216 | 2 -> 2 | improved |
| `paragraph.tab-indents-and-spacing` | -0.315 pp | -0.216 | 2 -> 2 | improved |
| `paragraph.tab-line-and-page-breaks` | +0.014 pp | -0.262 | 5 -> 5 | mixed, retained |
| `paragraph.validation-error` | -0.315 pp | -0.216 | 2 -> 2 | improved |

`paragraph.tab-line-and-page-breaks` is deliberately retained and not hidden:
its changed ratio rises from 8.235% to 8.249% (about 17 pixels in the
normalized frame), while the mean channel delta improves from 11.021 to
10.759 and pHash stays at 5. The same checkbox/frame alignment improves the
other four Paragraph states and the route average. The evidence therefore
shows a net fidelity improvement, with this isolated changed-pixel regression
remaining visible for a future targeted typography/template pass.

## Verification

- `dotnet run --project freew/tools/FreeW.DialogVisualHarness.Wpf/FreeW.DialogVisualHarness.Wpf.csproj -c Release -- --inventory artifacts/freew-wave70-font-paragraph-20260730/inventory/focused.json --output artifacts/freew-wave70-font-paragraph-20260730/wpf-fresh`
  - 10/10 captured.
- `dotnet run --project freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj -c Release -- --inventory artifacts/freew-wave70-font-paragraph-20260730/inventory/focused.json --wpf-authority artifacts/freew-wave70-font-paragraph-20260730/wpf-fresh/wpf_dialog_capture_manifest.json --output artifacts/freew-wave70-font-paragraph-20260730/avalonia-fresh`
  - 10/10 captured.
- `dotnet run --project freew/tools/FreeW.DialogVisualHarness/FreeW.DialogVisualHarness.csproj -c Release -- compare --inventory artifacts/freew-wave70-font-paragraph-20260730/inventory/focused.json --wpf artifacts/freew-wave70-font-paragraph-20260730/wpf-fresh/wpf_dialog_capture_manifest.json --avalonia artifacts/freew-wave70-font-paragraph-20260730/avalonia-fresh/avalonia_dialog_capture_manifest.json --output artifacts/freew-wave70-font-paragraph-20260730/compare-fresh`
  - expected comparison exit `2`; all ten captures are valid and honestly
    classified as genuine visual mismatches.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --no-restore --filter "FullyQualifiedName~FontDialogVisualParityTests|FullyQualifiedName~ParagraphDialogVisualParityTests"`
  - 9 passed, 0 failed.

No physical Docker lane was run for this dialog-focused render slice.

