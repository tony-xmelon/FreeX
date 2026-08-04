# FreeP Summary Zoom Target Ordering - 2026-08-04

## Function slice

Summary Zoom target membership was already undoable and persisted in the order
provided by the shared editor. Both desktop dialogs, however, presented a fixed
section list and returned selected targets in catalog order, so users could not
author a different Summary Zoom sequence.

WPF and Avalonia now expose `Move Up` and `Move Down` controls. The visible list
order is projected through `SummaryZoomTargetPlanner.SelectOrderedTargets`, then
continues through the existing `SetSummaryZoomTargets` command and native XML
rewrite. No renderer or preview behavior was changed.

## Verification

- Shared Summary Zoom planner: 9/9 focused tests.
- WPF host Zoom parity: 4/4 focused tests.
- Avalonia host Zoom parity: 4/4 focused tests.
- `FreeP.App.Host` Release build: 0 warnings, 0 errors.
- `FreeP.App.Avalonia` Release build: 0 warnings, 0 errors.

This is a functional authoring slice; no PowerPoint COM visual claim is made.
