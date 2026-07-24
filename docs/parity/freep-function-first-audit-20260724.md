# FreeP Function-First Audit - 2026-07-24

This audit deliberately excludes further pixel calibration. It checks whether the
current product has actionable command or host-function gaps before another visual
slice is selected.

## Current command surface

The generated inventory at `docs/parity/freep-command-parity-inventory.json` reports:

- 258 command IDs total.
- 256 shared across WPF and Avalonia.
- 0 actionable missing WPF commands.
- 0 actionable missing Avalonia commands.
- 2 intentional shell/profile variances: Undo and Redo are routed through WPF
  routed commands/keyboard bindings while Avalonia exposes generated ribbon entries.

The inventory is command-surface evidence, not a claim that every PowerPoint feature
is complete.

## Verified function paths

- Selection, marquee, move, resize, rotate, nudge, snapping, and source-then-target
  Format Painter are implemented in both hosts.
- Animation pane trigger, duration, delay, effect options, reorder, and playback
  mutations route through shared typed planners in both hosts.
- SmartArt text-pane editing has shared node mutations, outline rebuilding, and host
  pane routes; the currently modeled layout preset catalog is now reachable through
  both WPF and Avalonia contextual galleries. Full PowerPoint-authoritative SmartArt
  regeneration, style authoring depth, and the long tail of layout families remain a
  separate scope.
- On Windows, WPF and Avalonia use `FreeP.App.Recording.Windows` and WinRT
  `MediaCapture` for local camera MP4 capture. The cross-platform recording project
  intentionally retains a no-Windows-runtime deferred fallback for tests and non-Windows
  targets; that fallback is not the Windows product path.
- Recent function slices cover hidden-slide state, notes export, media capture and
  insertion, accessibility/review panes, printing, and grouped DrawingML package
  round-trip behavior.
- The print Backstage path now accepts a shared custom slide-range string such as
  `2,4-6` (including validation, hidden-slide filtering, and package disabled reasons)
  through both WPF and Avalonia host adapters. The hosts consume the shared parser;
  neither owns a divergent range grammar.
- WPF Backstage and both Avalonia print projections expose an Apply-range input. The
  selected range rebuilds the shared preview/package plan, and the native print handoff
  retains that same request instead of falling back to all slides.
- Chart insertion now exposes every modeled chart family through the shared insertion
  planner and both host ribbons, including stacked and 100% stacked variants, line
  markers, area, scatter, doughnut, radar, bubble, stock, surface, and 3-D surface.
- Chart data editing now also supports PowerPoint's Switch Row/Column operation in both
  WPF and Avalonia. The shared planner transposes category labels, series names, and
  nullable value gaps before the existing single-step ReplaceChartData undo command.
- Chart data editing now also changes the selected chart type in both WPF and Avalonia.
  The same batch command preserves the type change in PPTX output, creates valid X/value
  payloads when moving to Scatter or Bubble, and restores those coordinates on undo.
- Chart authoring now also exposes a shared Chart Options dialog in both hosts. Title,
  legend placement, value-label placement/visibility, and category/value major gridlines
  commit through one undoable command and round-trip through the existing chart package
  writer.
- Chart authoring now also exposes a shared Axis Options dialog in both hosts. Category and
  value axes can edit titles, automatic or explicit minimum/maximum scale, major/minor units,
  number formats, and major gridline visibility through one undoable command. The values
  round-trip through the existing chart axis reader/writer.
- Chart authoring now also exposes a shared Series Options dialog in both hosts. Each series
  can edit smooth-line state, secondary-axis assignment, line width, marker symbol, and marker
  size through one undoable command; the existing chart reader and writer preserve those values
  through PPTX round-trip.
- Chart authoring now also exposes a shared Point Options dialog in both hosts. A selected
  series/category point can edit fill, outline color/width, marker symbol, and marker size
  through one undoable command; existing point-style and point-color payloads round-trip through
  the PPTX reader and writer.
- Chart authoring now also exposes a shared Chart Layout Options dialog in both hosts. Plot-area
  and legend manual layouts can edit the layout target, factor/edge modes, and x/y/width/height
  through one undoable command; existing manual-layout values round-trip through the PPTX reader
  and writer.
- Chart authoring now also exposes a shared Data Table dialog in both hosts. It can show or hide
  the chart data table and edit horizontal, vertical, outline, and legend-key settings through one
  undoable command; existing `c:dTable` payloads and authored chart styling survive the update.
- Chart display options now expose the full modeled chart-level data-label components in both
  hosts: values, percentages, category names, series names, legend keys, placement, number format,
  and separator. The same undoable command creates or updates the `c:dLbls` payload and preserves
  it through PPTX round-trip.
- Chart display options now also expose bar/column gap width (0-500%) and overlap (-100% to 100%)
  in both hosts. Blank values preserve automatic chart behavior; explicit values share one undoable
  command and round-trip through `c:gapWidth` and `c:overlap`.
- SmartArt authoring now exposes the specialized layouts already supported by the live
  shared layout engine: alternating process, arrow ribbon, circle process, funnel process,
  vertical process, segmented process, chevron process, basic/closed-chevron process,
  bending process, descending block list, radial Venn, target list, stacked Venn, gear cycle,
  text cycle, block cycle, non-directional cycle, vertical bullet list, titled matrix,
  and hierarchy3.
  Each route updates the native diagram layout part and the live model, then remains
  undoable through the shared editing session in both hosts.
- Hierarchy authoring now also exposes Horizontal Hierarchy and Organization Chart, using
  the existing shared tree layout paths rather than leaving those PowerPoint layout choices
  as import-only behavior.
- WPF and Avalonia slideshow playback now surface parsed media caption cues from the active
  playback clock; the shared planner owns cue interval semantics and both host controllers
  retain their own native overlay lifecycle.

## Remaining function scope

The remaining gaps are depth and application compatibility, not missing ribbon IDs:

- the remaining long tail of SmartArt layout families and full PowerPoint-authoritative
  SmartArt regeneration/style editing beyond the now-expanded live preset catalog;
- advanced chart authoring/layout semantics beyond the current supported model, including
  richer chart data editing beyond the shared grid and PowerPoint-specific chart-area styling
  beyond manual layout geometry;
- deeper presenter/review/accessibility workflows and application-specific dialog
  behavior;
- broader media/presenter integration and platform-specific capture/export behavior, including
  real-device capture and PowerPoint-authoritative media/caption baselines;
- PowerPoint COM-backed workflow validation on a machine where that comparison path is
  available.

## Process decision

Do not select another renderer-only calibration from stale comments such as
“viewer-only”, “Tab navigation is not implemented”, or “animation timing is stubbed”.
Choose the next slice from a reproducible function gap with a host workflow and
round-trip assertion, then add visual evidence only when the function path is proven.
