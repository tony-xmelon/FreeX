# FreeP Function-First Audit - 2026-07-24

This audit deliberately excludes further pixel calibration. It checks whether the
current product has actionable command or host-function gaps before another visual
slice is selected.

## Current command surface

The generated inventory at `docs/parity/freep-command-parity-inventory.json` reports:

- 225 command IDs total.
- 223 shared across WPF and Avalonia.
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
- SmartArt authoring now exposes the specialized layouts already supported by the live
  shared layout engine: alternating process, arrow ribbon, circle process, funnel process,
  vertical process, descending block list, radial Venn, target list, and stacked Venn.
  Each route updates the native diagram layout part and the live model, then remains
  undoable through the shared editing session in both hosts.
- Hierarchy authoring now also exposes Horizontal Hierarchy and Organization Chart, using
  the existing shared tree layout paths rather than leaving those PowerPoint layout choices
  as import-only behavior.

## Remaining function scope

The remaining gaps are depth and application compatibility, not missing ribbon IDs:

- the remaining long tail of SmartArt layout families and full PowerPoint-authoritative
  SmartArt regeneration/style editing beyond the now-expanded live preset catalog;
- advanced chart authoring/layout semantics beyond the current supported model, including
  richer chart data editing and PowerPoint-specific formatting dialogs;
- deeper presenter/review/accessibility workflows and application-specific dialog
  behavior;
- broader media/presenter integration and platform-specific capture/export behavior;
- PowerPoint COM-backed workflow validation on a machine where that comparison path is
  available.

## Process decision

Do not select another renderer-only calibration from stale comments such as
“viewer-only”, “Tab navigation is not implemented”, or “animation timing is stubbed”.
Choose the next slice from a reproducible function gap with a host workflow and
round-trip assertion, then add visual evidence only when the function path is proven.
