# FreeW Paragraph Dialog Wave 15

Target-only WPF/Avalonia evidence for the four requested Paragraph states, captured at the WPF authority size and 96-DPI logical coordinates.

## Scope

- `paragraph.initial`
- `paragraph.populated`
- `paragraph.validation-error`
- `paragraph.tab-indents-and-spacing`

## Metrics

| Scenario | Before changed ratio | After changed ratio | Before mean channel delta | After mean channel delta | Classification |
| --- | ---: | ---: | ---: | ---: | --- |
| `paragraph.initial` | 21.63% | 17.76% | 18.21 | 17.48 | genuine visual mismatch |
| `paragraph.populated` | 21.63% | 17.76% | 18.21 | 17.48 | genuine visual mismatch |
| `paragraph.validation-error` | 22.47% | 18.60% | 19.37 | 18.65 | genuine visual mismatch |
| `paragraph.tab-indents-and-spacing` | 21.63% | 17.76% | 18.21 | 17.48 | genuine visual mismatch |

The after bundle contains 4 WPF captures, 4 Avalonia captures, and 4 paired comparison rows. All captures pass the nonblank/content gates. The changed-pixel ratio improved by 17.9% relative for the normal states and 17.3% relative for the validation state.

## Implementation

- Matched the Avalonia outer width to WPF: 380px.
- Matched WPF-authority client pane heights: 253px for Indents and Spacing and 235px for Line and Page Breaks.
- Restored the contextual-spacing checkbox that was clipped by the old Indents pane height.
- Made the Special combo fill the same field column as WPF.
- Added focused geometry/state assertions for width, pane heights, combo stretch, disabled special amount, and checkbox visibility.

## Residuals

The rows remain honest visual mismatches because Avalonia and WPF still rasterize the focused text-box border, combo-box arrow/template, and text anti-aliasing differently. No behavior or semantic mismatch was reported for these four scenarios.

The generated paired report is in `docs/parity/freew-paragraph-wave15-20260727/`.
