# Wave123 FreeW Backstage Info

## Scope

This slice closes the current FreeW `backstage-info.open` semantic mismatch and
aligns the Avalonia pane's shared text/content contract with the WPF authority.
The global cross-app dashboard and generated global integration reports were not
modified.

## Implementation

- Added `AutomationProperties.Name = action.Label` to shared WPF Backstage action
  buttons. This makes the two-line `StackPanel` action content discoverable by
  accessibility clients and by the visual harness; Avalonia already exposes the
  same shared action labels.
- Added portable `BackstageInfoPaneText` labels and consumed them in both WPF and
  Avalonia (`Info`, `Location`, `Not saved yet`, `Properties`, `Statistics`).
- Added shared `BackstageInfoStatisticsPlanner`; both renderers now build the
  same `Words`, `Characters`, and `Paragraphs` rows from the live document model.
- Added focused WPF, Avalonia, presentation-planner, and source-dedup tests for
  action order, labels, callbacks, shared strings, and statistics layout data.

## Fresh paired evidence

Captured from current source at the same logical size (560x600, 96-DPI target):

- WPF: `artifacts/wave123-freew-backstageinfo-final-wpf/`
- Avalonia: `artifacts/wave123-freew-backstageinfo-final-avalonia/`
- Focused comparison: `artifacts/wave123-freew-backstageinfo-final-compare/`

| Metric | Result |
|---|---:|
| Capture status | captured / captured |
| Changed pixels | 23,430 / 336,000 (6.9732%) |
| Mean absolute channel delta | 4.3795 |
| P95 channel delta | 19 |
| Luminance similarity | 0.9161 |
| Perceptual hash distance | 0 |
| Semantic difference | none |

Both manifests expose the same action order:
`Edit document properties…`, `Mark as Final`, `Restrict Editing`, `Inspect Document`,
`Check Accessibility`.

The pre-fix fresh capture was 8.8188% changed pixels / 7.2034 mean delta and
reported `action-button-order`. The committed canonical report had classified the
surface at approximately 8.99%. The semantic residual is now closed and the
visual delta fell to 6.9732%.

## Linux smoke

Named Docker route succeeded using `freex-linux-interactive-freew-6123` at
1280x820, 96 DPI. Physical X11 input opened File, selected Info, and captured the
real pane with its shared labels, actions, and scrollbar. Evidence is under:
`artifacts/wave123-freew-backstageinfo-linux/freew/sessions/20260803T085711063Z/screenshots/`.
The exact container and app image were stopped and removed after capture.

## Residual

The two application startup demos still seed different documents by design:
the WPF demo reports `44 / 288 / 4`, while the Avalonia demo reports `92 / 515 / 19`
for words / characters / paragraphs. The Info renderer now uses one shared
statistics policy, but changing or deduplicating the separate startup demo
fixtures is outside this bounded Backstage Info slice. Native WPF versus Skia
text rasterization also remains visible in the 6.9732% visual delta.

## Verification

- `FreeW.App.Presentation.Tests`: Backstage planner filter, 20/20 passed.
- `FreeW.App.Host.Tests`: shared Backstage Info/composer filters, 25/25 passed.
- `FreeW.App.Avalonia.Tests`: `BackstageViewTests`, 40/40 passed.
- WPF and Avalonia harness route captures: 1/1 each, content gates passed.
- Linux Docker File -> Info route smoke: passed.
