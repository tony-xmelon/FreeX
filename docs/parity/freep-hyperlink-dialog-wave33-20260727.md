# FreeP Insert Hyperlink Dialog Wave33

## Objective

Bring the FreeP Avalonia Insert Hyperlink dialog to WPF visual and functional parity for the initial, populated, and validation states. WPF is the authority. Preserve shared planner policy, insertion result propagation, invalid-input focus and persistence, default/cancel behavior, tab order, and modal close lifecycle. Do not change WPF or shared chrome for this slice.

## Fresh Paired Evidence

Captures were taken before editing and again after the final post-merge build using the FreeP dialog-pane visual evidence runner. All three states are 406x216 px at logical 96 DPI. Changed-pixel percentage is the normalized target metric; mean is mean channel delta.

| State | Before | After | Mean before -> after | Result |
|---|---:|---:|---:|---|
| `initial` | 19.15% | 7.59% | 13.63 -> 6.94 | pass |
| `populated` | 20.66% | 9.08% | 15.63 -> 8.41 | pass |
| `validation` | 21.09% | 10.34% | 15.47 -> 9.09 | pass |

Checked-in focused captures are under `docs/parity/freep-hyperlink-dialog-wave33-20260727/`:

- `before/{wpf,avalonia,diff}/insert.hyperlink.{initial,populated,validation}.png`
- `after/{wpf,avalonia,diff}/insert.hyperlink.{initial,populated,validation}.png`

The final full runner completed 28/28 paired captures: 24 pass, 4 unrelated mismatches. The hyperlink rows all passed semantic checks, dimensions, and the pixel threshold. This document does not claim whole-harness 100% parity.

## Implementation

- Reused the shared Windows compact font and window chrome, with dialog-local 26 px input metrics.
- Matched WPF radio glyphs, URL field text behavior, disabled target-slide paint, validation-row occupancy, action-row spacing, button colors, and fixed geometry.
- Added explicit Avalonia tab indices for radios, fields, OK, and Cancel.
- Kept `HyperlinkDialogPlanner` and `MainWindow` result/application routing unchanged.

## Functional Verification

Focused Avalonia tests passed 7/7, including result propagation to the selected shape, slide-target editing, command routing, WPF dialog metrics/chrome contract, tab order, default/cancel flags, and invalid-to-valid dialog lifecycle.

Final paired capture source paths:

- WPF: `freep/FreeP.App.Host/bin/Release/net10.0-windows10.0.19041.0/FreeP.App.Host.exe`
- Avalonia: `freep/FreeP.App.Avalonia/bin/Release/net10.0-windows10.0.19041.0/FreeP.exe`
- Runner: `tools/FreeP.RenderCompare/bin/Release/net10.0-windows10.0.19041.0/FreeP.RenderCompare.dll`
