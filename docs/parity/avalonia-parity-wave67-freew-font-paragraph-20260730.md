# FreeW Wave67 Font and Paragraph Dialog Parity

This slice aligns the Avalonia Font and Paragraph dialogs with the app-owned WPF authorities. The
comparison thresholds and classifications were not changed. The focused capture was regenerated
from the current branch with fresh WPF and Avalonia renders.

## Before and after

Metrics are `changedRatio` and `meanAbsoluteChannelDelta` from the existing comparison harness.
The baseline is the checked-in report at
`docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.json`. The after evidence is in
the local focused artifact bundle at `artifacts/freew-wave67-final-compare`.

| Route | Before changed pixels | After changed pixels | Before mean delta | After mean delta |
| --- | ---: | ---: | ---: | ---: |
| Font, five states average | 16.980% | 14.045% | 13.313 | 12.573 |
| Paragraph, five states average | 16.123% | 9.844% | 16.176 | 11.063 |

| Scenario | Before ratio | After ratio | Before mean | After mean | Before pHash | After pHash |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `font.initial` | 17.152% | 14.589% | 13.479 | 13.112 | 8 | 2 |
| `font.populated` | 17.220% | 14.685% | 13.596 | 13.236 | 8 | 2 |
| `font.tab-advanced` | 15.936% | 11.514% | 12.143 | 9.962 | 1 | 2 |
| `font.tab-font` | 17.152% | 14.589% | 13.479 | 13.112 | 8 | 2 |
| `font.validation-error` | 17.439% | 14.848% | 13.868 | 13.443 | 8 | 2 |
| `paragraph.initial` | 17.763% | 10.005% | 17.483 | 11.007 | 3 | 1 |
| `paragraph.populated` | 17.763% | 10.005% | 17.483 | 11.007 | 3 | 1 |
| `paragraph.tab-indents-and-spacing` | 17.763% | 10.005% | 17.483 | 11.007 | 3 | 1 |
| `paragraph.tab-line-and-page-breaks` | 8.724% | 8.465% | 9.782 | 10.516 | 4 | 3 |
| `paragraph.validation-error` | 18.603% | 10.741% | 18.646 | 11.780 | 3 | 1 |

## Implementation

- Added optional shared Avalonia compact-dialog metrics for TextBox, ComboBox, tab, button, focus,
  foreground, input-border, button-border, and tab-pane-border authority differences.
- Applied the WPF profile to FreeW Font and Paragraph only: 18 px text fields, 22 px combo boxes,
  20 px tabs and action buttons, black WPF text, WPF border colors, and a one-pixel focused input
  border without the Fluent focus adorner.
- Tightened the Font effects wrap rows to match WPF vertical spacing.
- Corrected the Avalonia evidence reader to exclude scrollbar `RepeatButton` controls from dialog
  action-button semantics. This removes a harness false positive; it does not alter pixel thresholds
  or visual classifications.
- Added focused Avalonia geometry/chrome tests for both dialogs and a harness source guard for the
  action-button normalization.

## Verification

- WPF focused capture: 10/10 captured in `artifacts/freew-wave67-final-wpf`.
- Avalonia focused capture: 10/10 captured in `artifacts/freew-wave67-final-avalonia`.
- Paired comparison: 10/10 paired; all remain `genuine-visual-mismatch`.
- Focused Avalonia tests: 17 passed, 0 failed, 0 skipped.
- No threshold weakening or reclassification was used.

## Residuals

The paired rows remain genuine visual mismatches because Skia/Avalonia and WPF still rasterize text
differently and retain small native-template differences in combo arrows, checkbox/text baselines,
and one-pixel pane positioning. The Paragraph line-and-page-breaks row has a small ratio improvement
but a higher mean channel delta and needs a separate typography/control-template pass. The slice does
not claim overall FreeW dialog visual parity.
