# Avalonia Parity Wave 47 Closure

Date: 2026-07-28

This report records the Wave 47 implementation and validation slice for FreeX, FreeW, and FreeP. The wave closes three concrete Avalonia functional gaps and preserves parity through concurrent upstream FreeP and FreeW changes. It does not claim that all Avalonia workflows or visuals have reached 100% WPF parity.

## Implemented Slices

### FreeX

- Added a shared Chart Format `Axis Options` group with the 14 legacy X/Y axis commands for ticks, label font, label angle, line, number format, gridline style, and logarithmic scale.
- Kept the command definitions in `FreeX.Ribbon.Definitions` and reused the shared chart planners from both hosts.
- Extended the Avalonia chart renderer to honor axis label font size, color, angle, and visibility; axis line color and thickness; tick-line color; and minor ticks independently of minor gridlines.
- Corrected chart-type transitions so category axes preserve valid visual styling while clearing unsupported numeric bounds and log scale, while chart types without axes clear axis visuals.
- Regenerated the FreeX command inventory and parity classification for the 14 newly projected commands.

Implementation commits: `91af869f00` and `8356ddde4b`.

### FreeW

- Allowed a nested `DrawingGroup` to participate in grouping with other floating objects.
- Preserved nested group placement when ungrouping.
- Aligned Avalonia floating-object selection and grouping with the valid WPF/model behavior.

Implementation commit: `fd6bb6b180`.

### FreeP

- Added Avalonia Animation Pane actions for move earlier, move later, and remove.
- Routed removal through the shared undoable animation planner used by WPF.
- Preserved shared selection and playback behavior while closing the missing Avalonia action surface.

Implementation commit: `1e392c4760`.

### Integration Repair

Concurrent upstream work made `ContinuousPictureList` a picture-backed SmartArt layout. Two exhaustive insertion tests still omitted its required picture payload. Their shared test input was corrected and the complete insertion-planner class passed.

Integration repair commit: `5b589be4ca`.

## Focused Evidence

The focused Wave 47 validation recorded:

- FreeX chart presentation/layout tests: **180/180 passed**.
- FreeX Avalonia axis runtime/rendering tests: **14/14 passed**.
- FreeX WPF chart command-source tests: **7/7 passed**.
- FreeX chart command tests after capability-guard alignment: **167/167 passed**.
- FreeX Avalonia inventory/parity tests: **23/23 passed**.
- FreeW shared grouped-object model tests: **14/14 passed**.
- FreeW WPF grouped-object host tests: **10/10 passed**.
- FreeW Avalonia grouped-object tests: **23/23 passed**.
- FreeP animation planner tests: **102/102 passed**.
- FreeP WPF Animation Pane tests: **18/18 passed**.
- FreeP Avalonia Animation Pane tests: **8/8 passed**.
- Post-upstream FreeP SmartArt/editing tests: **333/333 passed**.
- Post-upstream FreeW grouped-object/evidence tests: **26/26 passed**.

## Linux Docker Evidence

All Wave 47 Linux runs used the shared `freex-linux-interactive:ubuntu24.04` base image and app images built from the integration source.

### FreeX

- Physical X11 interaction lane: **24 passed**, **0 failed** on the final rerun.
- The first run passed 21/24; three native file/print dialog cases missed their timing windows and passed unchanged against the same published payload on rerun.
- Targeted managed chart-axis lane: **28 passed**, **0 failed**.
- The targeted lane executed all 14 new axis commands and all 14 placement checks with evidence level `executed-production-lifecycle`.

Evidence:

- `artifacts/linux-interactive/freex/interaction-validation/20260728T194348Z/interaction-validation.json`
- `artifacts/linux-interactive/wave47-axis-target/freex/sessions/20260728T200206731Z/validation/interaction-validation.json`

### FreeW

- Physical X11 family lane: **37 passed**, **0 failed**.

Evidence:

- `artifacts/linux-family-interactive/wave47/freew/freew/sessions/20260728T195724565Z/family-validation/family-x11-results.json`

### FreeP

- Physical X11 family lane: **22 passed**, **0 failed**.

Evidence:

- `artifacts/linux-family-interactive/wave47/freep/freep/sessions/20260728T200005684Z/family-validation/family-x11-results.json`

These runs prove the recorded command and physical-input lifecycles. They are not pixel-diff acceptance evidence.

## Repository Gates

- Repository preflight passed on the final integrated source.
- The full Release build checkpoint completed with **0 warnings and 0 errors**.
- Post-upstream focused builds covered the subsequently changed FreeP and FreeW projects.
- The final default test checkpoint recorded **33,125 total**, **32,992 executed and passed**, **0 failed**, and **133 not executed** across 19 TRX files.

Generated command, functional-parity, surface-catalog, cross-app dashboard, and FreeP whole-window evidence files were refreshed and passed their generated-document checks.

## Remaining Work

### FreeX

- Complete matched-size, matched-DPI WPF/Avalonia visual acceptance for chart-axis controls and the wider full-window, Backstage, ribbon, dialog, context-menu, grid, formula-bar, sheet-tab, and footer surfaces.
- Continue executable review of capability guards and the remaining deeper spreadsheet workflows.

### FreeW

- Decide whether Avalonia needs the WPF-only separate page-box Page Edit surface; Avalonia currently edits the live Print Layout representation.
- Add child-level editing inside grouped objects without requiring ungroup.
- Expand authoritative Word-rendered visual baselines for page composition, drawing objects, tables, charts, SmartArt, WordArt, and watermarks.

### FreeP

- Calibrate Animation Pane visuals against PowerPoint/WPF and expand authoritative playback evidence.
- Continue PowerPoint-authoritative visual and workflow baselines for media, charts, SmartArt, comments, proofing, accessibility, recording, captions, animation, and export.

### Cross-App

- Continue replacing host-specific implementations with shared planners, models, resources, themes, and assets where behavior is genuinely common.
- Keep physical Linux interaction evidence separate from authoritative visual acceptance.
- Address the 133 default-lane rows that remain unexecuted when their platform, benchmark, or external prerequisites are available.

Wave 47 materially advances functional parity and leaves all executed closure gates green. The overall Avalonia-to-WPF goal remains active because authoritative visual acceptance and several deeper workflows remain incomplete.
