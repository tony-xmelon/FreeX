# FreeW Avalonia parity Wave198: Mark Index Entry compact toggles

Date: 2026-08-25

## Scope

This slice rechecked the three `mark-index-entry` dialog states: `initial`,
`populated`, and `validation-error`. WPF remained the rendering authority.
Ink/Draw behavior and map-chart fidelity remain explicitly out of scope for the
active parity effort.

## Diagnosis and implementation

The fields match through the **Options** label, but Avalonia's default Fluent
radio buttons and checkboxes consumed substantially taller rows than the native
WPF controls. The accumulated height placed the action row 54 pixels below the
WPF authority.

`MarkIndexEntryDialog` now uses the shared compact radio and checkbox templates,
with a route-local 16-DIP radio row and a 4-DIP action-row top margin. Those
metrics keep the WPF 13-pixel toggle indicators while aligning the content and
action row without changing the shared chrome used by other dialogs.

The WPF visual-harness adapter now constructs this route with the same selected
text seed used by the public Avalonia constructor. That corrects a fixture-only
drift where the two populated screenshots represented different dialog states.

## Evidence

Fresh route-only evidence:

- Baseline: `artifacts/wave198-freew-mark-index-entry-current/comparison/freew_dialog_visual_comparison.json`
- Equivalent WPF authority: `artifacts/wave198-freew-mark-index-entry-final/wpf/wpf_dialog_capture_manifest.json`
- Corrected Avalonia: `artifacts/wave198-freew-mark-index-entry-final2/avalonia/avalonia_dialog_capture_manifest.json`
- Corrected comparison: `artifacts/wave198-freew-mark-index-entry-final2/comparison/freew_dialog_visual_comparison.json`

All three WPF and all three Avalonia states captured; none was unsupported. The
corrected route has matching WPF/Avalonia painted-content bottoms (384 pixels).
Using the equivalent authority fixture, every state improved versus the
compact-toggle baseline:

| Pair | Before changed pixels | After changed pixels | Before mean channel delta | After mean channel delta |
| --- | ---: | ---: | ---: | ---: |
| `mark-index-entry.initial` | 20,641 | 16,672 | 4.1741 | 3.5810 |
| `mark-index-entry.populated` | 19,326 | 16,369 | 4.3995 | 3.8594 |
| `mark-index-entry.validation-error` | 21,018 | 17,049 | 4.2752 | 3.6821 |

The original uncorrected route capture had 26,612–27,535 changed pixels per
state; its WPF populated fixture was not equivalent and is retained only as the
initial diagnosis artifact. The remaining variance is native text and control
rasterization, not an evidence-supported reason for another geometry change.

## Verification

- Avalonia visual-harness build: succeeded, 0 warnings, 0 errors.
- WPF visual-harness build: succeeded, 0 warnings, 0 errors.
- Fresh paired capture: 3/3 WPF and 3/3 Avalonia states captured.
- `MarkIndexEntryDialogPlannerTests`: 11 passed, 0 failed.
- WPF `MarkIndexEntryDialogTests`: 9 passed, 0 failed.
- Avalonia Mark Index Entry tests: 7 passed, 0 failed.
