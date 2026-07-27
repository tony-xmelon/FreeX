# Avalonia Parity Wave 41

Date: 2026-07-28

## Closed Production Slices

### FreeX

The Avalonia Chart Format `Series Color` command now opens the existing full
Chart Series Format dialog, matching the WPF route and shared
`ChartSeriesFormatPlanner`, instead of opening a fill-only picker for the first
series.

### FreeW

The Avalonia `Ctrl+P` route now invokes direct printing, matching WPF and the
shared keyboard command contract, instead of opening Print Preview. The Linux
foreground probe fallback coordinate was also corrected to activate the Print
action rather than the Backstage Print pane.

### FreeP

WPF slideshow media hit testing now delegates to the shared
`SlideShowMediaInteractionPlanner`. Overlapping media therefore resolve through
the same topmost-object rule used by Avalonia, with the shared slot mapped back
to the authored shape by `ShapeId`.

## Verification

- Focused integrated tests: **66/66 passed**.
- Repository preflight: **passed**, including generated parity artifacts,
  project references, conflict-marker checks, FreeP dialog/pane evidence
  (**28/28 across 123 PNGs**), and FreeP whole-window evidence
  (**33/33 paired**).
- Full Release solution build: **0 warnings, 0 errors**.
- Default test solution: **32,783 passed, 17 failed, 133 not executed**.
  The 17 failures are the existing FreeX source-order/portability guard
  baseline and do not cover the three Wave 41 production changes.
- FreeX Linux production capture: `dialog.ChartSeriesFormat` was captured
  successfully at 1280x820 and 96 DPI.
- FreeW corrected Linux foreground print probe: **5 passed, 0 failed,
  2 not proven**. The unproven checks are native GTK/system-window metadata and
  chrome, which the harness does not claim.
- FreeW physical Linux `Ctrl+P`: opened the active Print dialog, submitted a
  **752,914-byte PDF** to the CUPS dry-run printer, and restored owner focus.

## Current Inventory State

- FreeX: **531** functional commands, **0 Avalonia-missing** and **0 classified
  real binding gaps**; **94** paired WPF/Avalonia screenshot surface IDs.
- FreeW: **870** commands, **0 actionable WPF-missing** and **0 actionable
  Avalonia-missing**.
- FreeP: **512** commands, **510 shared-profile**, **0 actionable WPF-missing**
  and **0 actionable Avalonia-missing**; the other two are platform-only.

These counts prove catalog and route coverage, not complete behavioral or
pixel-level parity.

## Remaining Work

- Continue interactive workflow-depth testing across real documents, including
  compound selection/editing, object manipulation, context menus, dialogs,
  keyboard paths, undo/redo, save/reopen, and export/print round trips.
- Run authoritative paired visual comparisons where host rendering remains
  toolkit-owned, especially FreeW drawing/object/chart/table output against
  Word and FreeP output against PowerPoint.
- Validate FreeP microphone and camera workflows on real Linux hardware,
  including non-empty locally encoded MP4 output.
- Broaden FreeP SmartArt, OMML, animation, chart-family, media/caption, and
  PowerPoint PDF/PNG baseline coverage.
- Keep FreeX dialog and shell visual review active despite complete paired
  surface IDs; capture completeness and DPI-normalized dimensions are not
  pixel-fidelity acceptance.

The broad whole-app parity goal remains active.
