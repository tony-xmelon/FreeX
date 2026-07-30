# FreeW Wave 63: Nested Grouped-Child Edit Points

## Scope

This slice closes the nested leaf `Edit Points` path for FreeW. A selected direct or nested shape now
uses its root-relative child path for custom-geometry conversion and vertex mutation in both WPF and
Avalonia. The shared command bus owns the mutation and undo snapshot, while the hosts only provide
selection, composed-transform rendering, hit testing, and pointer conversion.

## Implemented

- `SetShapeCustomGeometryCommand` and `MoveShapeEditPointCommand` resolve direct shapes or a nested
  `DrawingGroup` child path through `DrawingGroupChildPathResolver`.
- Avalonia renders nested leaf vertex handles through the complete group transform chain and maps a
  dragged page point back through the inverse chain before issuing the shared command.
- WPF accepts a selected nested leaf, creates the same path-aware command target, and positions/drag
  maps handles through the rendered child visual, including composed group transforms.
- Escape/undo remains one-drag granular through the existing host undo lifecycle.
- DOCX serialization is exercised with a nested custom-geometry leaf, including rotation/flip metadata.
- The owned Linux/X11 harness adds a nested edit-points probe and an exact saved-DOCX geometry assertion.

## Verification

- `FreeW.Core.IO.Tests`: 1 passed (`NestedGroupEditPointsRoundTripTests`).
- `FreeW.App.Avalonia.Tests`: 6 passed (`ShapeEditPointsParityTests`, including nested selection,
  transformed handle mapping, undo, and Escape behavior).
- `FreeW.App.Host.Tests`: 6 passed (`ShapeEditPointsInteractionTests`, including the paired nested WPF route).
- Physical command: `tools/Run-FreeWWave63NestedEditPointsValidation.ps1` using only the owned FreeW
  container on port 6093. The generated manifest is written to the requested output directory when the
  Linux/X11 lane is available.

## Remaining nested-group gaps

Nested shape text editing and nested shape formatting are still separate slices. Images, charts,
SmartArt, WordArt, and nested-group container edit points do not gain vertex editing from this change;
only direct and nested leaf `Shape` children are in scope.
