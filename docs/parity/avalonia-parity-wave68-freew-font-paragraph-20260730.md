# FreeW Wave68 Font and Paragraph Dialog Template Fidelity

This focused slice compares the app-owned WPF Font and Paragraph dialogs with their Avalonia
counterparts. The capture inventory contains five Font states and five Paragraph states. Existing
comparison thresholds and classifications were preserved.

## Before and after

The before bundle is a fresh capture from the Wave67 source state. The after bundle is the final
Wave68 capture from this branch.

| Scenario | Before changed | After changed | Before mean | After mean | Before pHash | After pHash |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `font.initial` | 14.589% | 12.941% | 13.112 | 11.598 | 2 | 2 |
| `font.populated` | 14.685% | 13.049% | 13.236 | 11.738 | 2 | 2 |
| `font.tab-advanced` | 11.514% | 12.659% | 9.962 | 10.831 | 2 | 1 |
| `font.tab-font` | 14.589% | 12.941% | 13.112 | 11.598 | 2 | 2 |
| `font.validation-error` | 14.848% | 13.226% | 13.443 | 11.992 | 2 | 2 |
| `paragraph.initial` | 10.005% | 9.769% | 11.007 | 10.882 | 1 | 1 |
| `paragraph.populated` | 10.005% | 9.769% | 11.007 | 10.882 | 1 | 1 |
| `paragraph.tab-indents-and-spacing` | 10.005% | 9.769% | 11.007 | 10.882 | 1 | 1 |
| `paragraph.tab-line-and-page-breaks` | 8.465% | 8.403% | 10.516 | 10.527 | 3 | 4 |
| `paragraph.validation-error` | 10.741% | 10.400% | 11.780 | 11.568 | 1 | 1 |

| Route | Before average changed | After average changed | Before average mean | After average mean |
| --- | ---: | ---: | ---: | ---: |
| Font | 14.045% | 12.963% | 12.573 | 11.551 |
| Paragraph | 9.844% | 9.622% | 11.063 | 10.948 |

## Changes

- Added idempotent shared compact ComboBox template normalization. The real Fluent
  `PathIcon`/`DropDownGlyph` part now receives a compact filled chevron, WPF-like dimensions, and
  trailing alignment after the template is materialized. Existing popup and editable-combo behavior
  remains platform-owned.
- Added a shared class guard so repeated `ApplyComboBox` calls do not add duplicate local styles or
  `AttachedToVisualTree` render jobs. Ordinary ComboBox properties remain refreshable on repeated
  calls.
- Made compact checkbox content use the WPF dialog font and explicit centered content alignment;
  the existing 13px indicator template is retained.
- Corrected the Font and Paragraph selected-pane top edge by one pixel and matched the Font pane's
  horizontal content inset to the WPF capture.
- Added focused assertions for the runtime combo glyph and ComboBox chrome idempotence.

## Evidence and verification

- Final focused WPF capture: `artifacts/freew-wave68-final3/wpf` (`10/10`).
- Final focused Avalonia capture: `artifacts/freew-wave68-final3/avalonia` (`10/10`).
- Final paired comparison: `artifacts/freew-wave68-final3/compare` (`10/10` genuine visual mismatches).
- Focused tests: `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~CommonDialogChromeParityTests|FullyQualifiedName~FontDialogVisualParityTests|FullyQualifiedName~ParagraphDialogVisualParityTests"` - 19 passed, 0 failed, 0 skipped.
- Avalonia dialog harness Release build: 0 warnings, 0 errors.

## Residuals

The slice does not claim visual parity. All ten rows remain genuine mismatches because WPF and Skia
still rasterize text differently, and the two native frameworks retain small differences in tab
content arrangement, checkbox text metrics, combo field surfaces, and scrollbar/template details.
The Paragraph line-and-page-breaks row has a slightly higher mean delta and pHash distance after the
one-pixel pane correction; it remains visible for a later typography/template pass. No threshold,
classification, or evidence gate was weakened.
