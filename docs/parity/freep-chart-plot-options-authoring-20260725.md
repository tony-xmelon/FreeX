# FreeP Chart Plot Options Authoring - 2026-07-25

## Scope

FreeP now exposes the chart `gapWidth` and `overlap` values that were already preserved by
the chart package reader/writer and consumed by the renderer, but previously had no authoring
workflow.

## Behavior

- The existing shared Chart Options planner carries both values as a working copy.
- Bar/column gap width accepts 0-500 percent; overlap accepts -100 to 100 percent.
- Blank values remain `null`, preserving PowerPoint's automatic chart defaults.
- WPF and Avalonia expose the same controls and validation.
- Commit and undo are one `SetChartDisplayOptionsCommand` step.
- PPTX output continues to use the existing `c:gapWidth` and `c:overlap` writer paths.

## Verification

- Presentation planner and command tests: 4/4 focused.
- WPF chart-focused host tests: 91/91.
- Avalonia chart-focused tests: 27/27.
- The existing package round-trip coverage asserts authored gap/overlap values and schema order.

This slice is functional parity evidence; it makes no new raster-fidelity claim.
