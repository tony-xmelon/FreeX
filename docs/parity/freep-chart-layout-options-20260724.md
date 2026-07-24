# FreeP Chart Layout Options - 2026-07-24

## Scope

Chart Layout Options is now a shared function workflow in both WPF and Avalonia.
The dialog edits either the plot-area or legend manual layout, including the
layout target, factor or edge modes, and X/Y/width/height values. The workflow
uses one undoable `SetChartLayoutOptionsCommand` and preserves the existing
`PlotAreaManualLayout` and `LegendManualLayout` package payloads on PPTX
round-trip.

The WPF and Avalonia dialogs are thin host adapters over the shared planner and
editing-session command. Ribbon registration is present in both generated
profiles.

## Verification

- Presentation planner and command tests: 73/73.
- WPF host chart-dialog tests: 24/24.
- Avalonia headless chart-dialog and ribbon tests: 4/4.
- Ribbon definition profile tests: 18/18.
- Presentation, WPF host, Avalonia, and ribbon Release builds: 0 warnings/errors.
- Generated command inventory: 245 total, 243 shared, 0 actionable gaps in either host.

## Remaining chart function scope

This slice covers manual plot-area and legend geometry. Remaining chart work is
advanced chart-area styling and richer data semantics beyond the shared grid,
plus PowerPoint-authoritative visual baselines where exact rendering matters.
