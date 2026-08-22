# FreeW Avalonia parity Wave174: Symbol Picker

Date: 2026-08-22

## Scope

This slice targeted the current canonical `symbol-picker.initial` mismatch in
`docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.json`. WPF remained the
authority. Only the FreeW symbol-picker realization, its focused Avalonia regression tests,
and the route-local canonical evidence were changed.

## Diagnosis

Fresh source captures showed a product-side Avalonia chrome and focus defect, not only native
glyph rasterization:

- WPF and Avalonia both rendered the authority geometry at 560x600 with 6 columns of 36-DIP
  glyph tiles and 272 px of painted content height.
- WPF tile interiors were white. Avalonia tile interiors were `#DDDDDD` because the dialog's
  shared generic button chrome remained visible under the glyph buttons.
- WPF initial focus was the dialog surface (`SymbolPickerDialog`); Avalonia had no realized
  focused element. The WPF cancel action was `Cancel` and neither host had a default action.

## Implementation

- Avalonia glyph tiles now use the WPF white tile surface while retaining the shared catalog,
  36-DIP metrics, 1 px `#C8C8C8` border, hover, pressed, and focus behavior.
- The Avalonia dialog is focusable and focuses its own surface after `Opened`, matching WPF
  without forcing focus onto the first glyph.
- The focused test realizes the dialog and asserts the actual focus/default/cancel contract,
  tile colors/borders/metrics, and stable glyph automation IDs.

## Evidence

Fresh route-only captures:

- WPF manifest: `artifacts/wave174-freew-symbol-picker-20260822/wpf/wpf_dialog_capture_manifest.json`
- Avalonia manifest: `artifacts/wave174-freew-symbol-picker-20260822/after/avalonia/avalonia_dialog_capture_manifest.json`
- Route comparison: `artifacts/wave174-freew-symbol-picker-20260822/after/compare/freew_dialog_visual_comparison.json`

| Pair | Changed pixels | Changed ratio | Mean channel delta | Semantic difference |
| --- | ---: | ---: | ---: | --- |
| Pre-fix WPF/Avalonia | 103,682 / 336,000 | 30.8577% | 11.2547 | `focus` |
| Post-fix WPF/Avalonia | 7,400 / 336,000 | 2.2024% | 1.8886 | none |

The canonical FreeW report changed from 142 mismatches / 79 passes / 70 Avalonia extensions to
141 mismatches / 80 passes / 70 extensions. Comparison thresholds and classifications were not
changed. The remaining 2.2024% delta is native text and glyph rasterization.

## Verification

- Fresh WPF route capture: 1/1 captured and passed content gates.
- Fresh Avalonia route capture: 1/1 captured and passed content gates.
- Fresh route comparison: `symbol-picker.initial` classified `pass`; semantic difference empty.
- Focused test: `SymbolPickerDialogParityTests`, 3 passed.
- No WPF source, comparison thresholds, cross-app dashboard, or unrelated dirty files changed.
