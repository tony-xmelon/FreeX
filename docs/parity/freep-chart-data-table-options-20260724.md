# FreeP Chart Data Table Options - 2026-07-24

## Scope

Chart Data Table Options is now a shared authoring workflow in WPF and
Avalonia. It can show or hide the data table and edit horizontal borders,
vertical borders, the outline border, series legend keys, solid background and
border colors/width, and default text color, size, family, bold, and italic.

The workflow uses one undoable `SetChartDataTableOptionsCommand`. When an
existing `c:dTable` is edited, blank style fields preserve the authored fill,
gradient/solid border, and text-style payload, while explicit fields apply a
targeted replacement. The PPTX writer/reader round-trips the edited style.

## Verification

- Presentation chart planner/command classes: **78/78**.
- WPF host chart-dialog tests: **24/24**; data-table dialog focus: **2/2**.
- Avalonia data-table dialog focus: **1/1**.
- Ribbon definition profile tests: **18/18**.
- Presentation, WPF host, Avalonia, and ribbon Release builds: **0 warnings/errors**.
- Generated command inventory: **246 total**, **244 shared**, and **0 actionable gaps** in either host.

## Remaining chart function scope

Advanced chart-area styling and richer data-editing semantics beyond the shared
grid remain open. PowerPoint-authoritative chart visual baselines are still
required for exact rendering claims.
