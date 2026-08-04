# FreeP Waterfall Total Authoring

Date: 2026-08-04

## Scope

FreeP now models PowerPoint waterfall total points as zero-based
`ChartShape.WaterfallTotalPointIndices`. The shared compositor uses those points as
zero-based anchors: a total column spans from zero to the running value and does not
consume its source value as an increment. Later increments continue from the same
running value.

The WPF and Avalonia chart context menus expose `Set as Total` / `Clear Total` for a
waterfall point. The mutation is one undoable presentation command and preserves the
difference between no authored total list and an explicitly empty list.

## Package Behavior

The reader recognizes current PowerPoint `ChartEx` waterfall parts and imports
`cx:series/cx:layoutPr/cx:subtotals/cx:idx` into the shared model, including connector
visibility and chart data.

FreeP's existing writer still emits its established classic chart part. For FreeP
round-trip, authored totals are stored in a namespaced chart extension and reopen
correctly. Native ChartEx export, including its required alternate-content frame and
workbook/style sidecars, remains a separate package-family task and is intentionally
not claimed here.

## Verification

- Waterfall planner, renderer, command, and undo tests: 4/4 focused tests.
- Waterfall PPTX package round-trip: 1/1 focused host test.
- WPF Release build: 0 warnings, 0 errors.
- Avalonia Release build: 0 warnings, 0 errors.

The native ChartEx read path was compiled with both desktop hosts. Visual calibration
was deliberately not expanded in this function-first slice.
