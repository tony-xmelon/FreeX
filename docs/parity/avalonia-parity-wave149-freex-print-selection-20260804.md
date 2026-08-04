# Avalonia parity Wave 149: single-cell print selection

Date: 2026-08-04
Base: `origin/main` at `8ac8f6e0f4`

## Gap closed

Avalonia's Print dialog and File > Export hid the Selected Range option unless the
selection was wider or taller than one cell. WPF treats any present selection as a
valid selection scope, and the shared print planner already supports a one-cell
`GridRange`; selecting A1 therefore could not reach the existing selected-range
print/export path. Both Avalonia entry points now use the same presence check.

## Evidence

`AvaloniaPrintSelectionParityTests` covers a one-cell range and the no-selection
case. The existing `PrintJobPlannerTests.CreatePlan_SelectedRangeScope_UsesSuppliedRange`
continues to cover the downstream selected-range plan.

## Boundary

This closes selected-range availability for the portable Print and Export dialogs.
The live Print Preview settings rail still does not repaginate from a selection
override, and native printer-properties UI remains platform-owned; those remain
separate follow-up boundaries rather than being presented as portable parity.
