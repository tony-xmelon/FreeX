# FreeP SmartArt Phased Process authoring

## Scope

This slice closes the authoring and package reachability gap for PowerPoint's native
`phasedProcess` SmartArt layout. It covers insertion, Change Layout routing in WPF and Avalonia,
live Process-family regeneration, and PPTX layout identity preservation on save/reopen.

The live renderer intentionally reuses the existing bounded alternating Process geometry. This is
a functional/package parity slice, not a claim of native PowerPoint raster equivalence.

## Implementation

- Added `SmartArtLayoutPreset.PhasedProcess` and the native layout URI
  `urn:microsoft.com/office/officeart/2005/8/layout/phasedProcess`.
- Added the WPF/Avalonia command registrations and Change Layout ribbon item.
- Admitted the URI to the Process live-layout allow-list and routed it through the shared layout
  engine.
- Added insertion and package round-trip theory coverage.

## Verification

- `FreeP.App.Presentation.Tests` build: 0 warnings, 0 errors.
- `FreeP.App.Host.Tests` build: 0 warnings, 0 errors.
- `SmartArtEditingPlannerTests`: 113/113 passed.
- `SmartArtTests`: 194/194 passed.
- No visual-fidelity claim was made for this slice.
