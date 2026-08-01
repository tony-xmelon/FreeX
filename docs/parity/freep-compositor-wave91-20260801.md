# FreeP compositor Wave 91: multi-selection live preview

## Scope

This slice closes the Wave 90 residual in which group resize and rotate showed only
selection chrome outlines. The shared canvas gesture planner remains host-neutral. A
transient preview composer now clones the resolved draw operation for each selected
member, applies the planned bounds and rotation, and leaves the source operation in its
original painter slot so z-order is unchanged.

Supported preview copies reuse the existing renderer contracts for:

- filled and outlined shapes, including transformed geometry and text layout;
- pictures, including crop, frame, opacity, and image effects;
- tables, including transformed cell frames, fills, borders, and text;
- charts, with the existing chart renderer's resize behavior.

WPF and Avalonia only own preview cache invalidation and call their existing draw paths.
Escape, pointer or mouse capture loss, commit, and disposal clear the transient copies.
The model is not mutated until the existing command commit path runs.

## Verification

Focused regressions cover shared draw-op cloning, filled Avalonia pixels during resize and
rotate preview, and WPF/Avalonia cancellation, capture-loss, commit, and disposal cleanup.

The external physical/UI validation remains orchestrator-owned and was not run here. No
Docker or machine-wide process cleanup was used.

## Residuals

Chart rotation and unsupported draw-op kinds retain the behavior supported by the current
renderer architecture. The preview does not invent new rendering capabilities for those
operations.
