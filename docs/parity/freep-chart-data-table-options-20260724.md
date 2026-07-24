# FreeP Chart Data Table Options - 2026-07-24

## Scope

Chart Data Table Options is now a shared authoring workflow in WPF and
Avalonia. It can show or hide the data table and edit horizontal borders,
vertical borders, the outline border, and series legend keys.

The workflow uses one undoable `SetChartDataTableOptionsCommand`. When an
existing `c:dTable` is edited, its authored fill, border, and text-style
payload is retained. The existing PPTX writer/reader round-trips the updated
visibility and border flags.

## Verification

- Presentation planner/command tests: **2/2**.
- WPF host dialog/shared-planner tests: **2/2**.
- Avalonia dialog and ribbon-registration tests: **2/2**.
- Ribbon definition profile tests: **18/18**.
- Presentation, WPF host, Avalonia, and ribbon Release builds: **0 warnings/errors**.
- Generated command inventory: **246 total**, **244 shared**, and **0 actionable gaps** in either host.

## Remaining chart function scope

Advanced chart-area styling and richer data-editing semantics beyond the shared
grid remain open. PowerPoint-authoritative chart visual baselines are still
required for exact rendering claims.
