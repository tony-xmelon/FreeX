# FreeP ChartEx Display-Label Ownership

## Functional gap

The shared Chart Options command edited `ChartShape.DataLabels`, but native
ChartEx packages store display labels below each `cx:series`. The dialog could
therefore appear to apply a label change while save/reopen discarded it.

## Fix

ChartEx display-label options are now mirrored to every native series owner.
The planner reads the first series label set when a ChartEx chart has no
chart-level label object, and command undo restores the complete prior
per-series label state. Classic charts retain their chart-level ownership.

## Verification

- Chart command/planner focused tests: 137/137.
- Full FreeP presentation tests: 3790/3790.
- Native chart host tests: 122/122.
- WPF host consumer built as part of the host test lane.
- Avalonia Release consumer build: 0 warnings, 0 errors.
- Package round-trip test verifies value labels, number format, separator, and
  undo for a native ChartEx chart.

This slice is functional/package parity work; it makes no visual-fidelity
claim.
