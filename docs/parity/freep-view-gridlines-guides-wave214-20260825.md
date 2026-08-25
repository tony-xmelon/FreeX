# FreeP View gridlines and guides — 2026-08-25

## Scope

FreeP's existing **View > Show > Gridlines** and **Guides** ribbon toggles now produce visible slide-canvas aids in both WPF and Avalonia, in addition to their existing snapping behavior.

## Change

- Gridlines use the existing PowerPoint-compatible 1/12-inch snap pitch. At low zoom, the visual grid is coarsened to keep spacing legible and bounded.
- Guides render vertical and horizontal center lines across the current slide.
- Both aids are screen-space canvas chrome, refreshed from the live zoom and fit transform, and are drawn behind slide content so they never alter object rendering or export output.

## Dependency

None. The implementation uses the existing shared `SlideTransformCore` and `SnapEngine` geometry.

## Verification

The shared aid planner tests transform geometry, hidden states, and low-zoom density. Existing WPF and Avalonia slide-canvas suites verify the renderer paths and content compositing.
