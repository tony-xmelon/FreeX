# Wave 206 — FreeP Outline View

## Scope

This slice closes the missing PowerPoint-style Outline View command on FreeP's
View ribbon and provides the corresponding native WPF and Avalonia workspace
surface. It has no external dependency. Ink/Draw behavior and map-chart
fidelity remain outside the active parity scope.

## Change

`Outline View` is now a fourth exclusive presentation view alongside Normal,
Slide Sorter, and Notes Page. A shared planner projects each visible slide's
title placeholder and visible text paragraphs, retaining paragraph hierarchy.
Both native hosts render that projection in the left workarea pane; selecting
an outline slide drives the existing shared slide selection workflow and keeps
the canvas and ribbon state synchronized.

The outline surface is intentionally read-only for this slice. Text authoring
continues through the existing canvas editor, so this does not claim the
separate direct-outline text-editing experience as complete.

## Evidence

The fresh WPF View-ribbon capture is retained at
`artifacts/wave206-freep-outline-view/view-ribbon.png`; it shows Outline View
in the Presentation Views group next to Normal, Slide Sorter, and Notes Page.
The generated command inventory now reports 709 commands, all present in both
WPF and Avalonia profiles.

## Verification

- `FreeP.App.Presentation` Release build: passed, zero warnings/errors.
- `FreeP.App.Host` Release build: passed, zero warnings/errors.
- `FreeP.App.Avalonia` Release build: passed, zero warnings/errors.
- Focused outline/view/ribbon workflow suite: 45 passed, 0 failed.
- `Generate-FreePCommandParityInventory.ps1` and `-Check`: passed.
