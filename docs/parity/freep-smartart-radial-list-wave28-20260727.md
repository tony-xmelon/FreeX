# FreeP SmartArt `radialList` Shared Layout - Wave 28

## Selection

`radialList` was already admitted by the SmartArt reader and routed through the
shared compositor, but it still used the generic cycle layout. That produced a
closed loop between adjacent items instead of a radial list with independent
items radiating from one center.

## Implemented

- `SmartArtLayoutEngine` now routes `radialList` through a dedicated shared plan.
- All parsed list items remain editable rounded boxes arranged around an ellipse.
- Each item receives a renderer-neutral connector from the shared implicit center;
  no adjacent-item loop is emitted.
- Live geometry is bounded to eight items; larger imported diagrams intentionally
  return to the preserved cached drawing rather than producing unreadable overlaps.
- Existing reader admission and `SmartArtEditingPlanner.RegenerateDrawingCache`
  consume the same plan without host-specific branches.
- WPF and Avalonia use the same ordinary `SlideShape` and connector operations.

## Evidence

- `freep/FreeP.App.Presentation.Tests/SmartArtLayoutTests.cs` verifies radial
  spokes and distinguishes them from a closed cycle.
- `freep/FreeP.App.Presentation.Tests/SmartArtEditingPlannerTests.cs` verifies
  cache regeneration persists four item boxes and four spokes.
- `freep/FreeP.App.Host.Tests/SmartArtTests.cs` verifies reader admission and
  WPF/shared compositor output from a minimal PPTX package.
- `freep/FreeP.App.Avalonia.Tests/MainWindowHeadlessTests.cs` verifies the
  Avalonia command route and undo behavior for the native preset.
- `tools/Generate-FreePCommandParityInventory.ps1` records the slice in the
  generated command inventory.

## Residuals

This is shared functional layout evidence, not a claim of PowerPoint pixel
parity. Exact PowerPoint radial-list node sizing, connector attachment sites,
curved routing, effects, native layout-part regeneration, and authoritative
PowerPoint PNG baselines remain deferred. Imported radial lists with more than
eight visible items retain cached-drawing fallback.
