# FreeP multi-selection handle parity Wave 88

Date: 2026-08-01

## Implemented

FreeP WPF and Avalonia now expose one selection box for multi-selection resize and
rotate handles. The individual selected-shape outlines remain visible, but handles are
owned by the axis-aligned union box so both hosts start the same group gesture.

The shared `CanvasGesturePlanner` owns the transform plan in both hosts:

- Resize applies the existing handle direction, screen-to-slide conversion, grid and
  shape snapping, Alt bypass, minimum group size, and proportional placement/size
  scaling to every captured selected shape.
- Rotate computes one start-grip-to-current-grip delta around the group center, applies
  optional Shift 15-degree snapping, rotates every shape center, and preserves each
  shape's own dimensions while adding the delta to its rotation.
- Both hosts use the same 3 px drag-start and 1 px commit thresholds, preview cleanup,
  Escape/capture-loss cancellation, and stale-release state clearing.
- `EditingSession.ApplySelectedTransforms` filters against the live selection and
  commits all effective resize and rotation commands as one `Transform Shapes` undo
  batch.

## Verification

- Focused shared planner tests (`CanvasGesturePlannerTests`): `15/15` passed.
- Focused WPF host transform test: `1/1` passed.
- Focused Avalonia host transform test: `1/1` passed.

The paired host tests cover group-handle hit testing, multi-shape resize, multi-shape
rotation, and one-step undo restoration for both operations.

## Residuals

- Group bounds follow the existing axis-aligned selection rectangles; rotated members
  do not introduce a new oriented-bounds model in this wave.
- During a drag, the adorner previews the transformed group box. Individual selected
  objects are committed from the shared per-shape plan when the gesture completes.
- The full repository/default and Docker validation lanes are outside this checkpoint;
  no Docker command was run.
