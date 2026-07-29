# Avalonia parity wave 52: FreeW grouped-child editing

Date: 2026-07-29

## Closed slice

- FreeW Avalonia now hit-tests the rendered children of a floating drawing
  group in front-to-back order, including the parent group's rotation and
  flip transform plus the direct child's local transform.
- A child click keeps the owning group as the active floating object for
  group-level arrange and ungroup behavior, while exposing the selected child
  identity and drawing the selection outline/handles around that child.
- `RotateSelectedFloating` and `FlipSelectedFloating` route to the selected
  child's local transform when a group child is active. The new
  `SetDrawingGroupChildRotationCommand` records the previous child transform,
  so the operation participates in the existing undo bus without changing the
  group's transform.

## WPF authority

The WPF host remains the reference for group composition, child-local offsets,
front-to-back child order, and preserving the outer group as the owning
selection. Its current group visual intentionally disables child selection;
that is the residual this Avalonia slice closes functionally while preserving
the WPF group-level command contract.

## Validation

- `dotnet test freew/FreeW.Core.Model.Tests/FreeW.Core.Model.Tests.csproj --configuration Release --filter FullyQualifiedName~DrawingGroupModelTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
  passed 15/15.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~DocumentViewFloatingSelectionTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
  passed 25/25, including hit-test identity, child rotation, and undo.

## Remaining FreeW grouped-child work

- Child-local move and resize gestures are not yet routed through group-local
  coordinates.
- Child formatting, text-box editing, edit-points mode, and full nested-group
  path selection remain separate slices.
- The WPF host still exposes group-level selection only; a WPF child-edit
  baseline must be established before claiming cross-platform visual parity for
  child handles and contextual commands.
