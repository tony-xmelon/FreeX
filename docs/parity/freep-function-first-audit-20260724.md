# FreeP Function-First Audit - 2026-07-24

This audit deliberately excludes further pixel calibration. It checks whether the
current product has actionable command or host-function gaps before another visual
slice is selected.

## Current command surface

The generated inventory at `docs/parity/freep-command-parity-inventory.json` reports:

- 187 command IDs total.
- 185 shared across WPF and Avalonia.
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
  pane routes; full PowerPoint SmartArt regeneration and style authoring remain a
  separate scope.
- On Windows, WPF and Avalonia use `FreeP.App.Recording.Windows` and WinRT
  `MediaCapture` for local camera MP4 capture. The cross-platform recording project
  intentionally retains a no-Windows-runtime deferred fallback for tests and non-Windows
  targets; that fallback is not the Windows product path.
- Recent function slices cover hidden-slide state, notes export, media capture and
  insertion, accessibility/review panes, printing, and grouped DrawingML package
  round-trip behavior.

## Remaining function scope

The remaining gaps are depth and application compatibility, not missing ribbon IDs:

- broader SmartArt layout-family support and full PowerPoint-authoritative SmartArt
  regeneration/style editing;
- advanced chart authoring/layout semantics beyond the current supported model;
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
