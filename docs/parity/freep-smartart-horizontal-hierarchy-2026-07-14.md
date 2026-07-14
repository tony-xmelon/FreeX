# FreeP SmartArt Horizontal Hierarchy Parity Slice - 2026-07-14

## Scope

This slice admits PowerPoint SmartArt `horizontalHierarchy` as a bounded shared live-layout layout. The planner remains renderer-neutral: parsed SmartArt data is converted into ordinary `SlideShape` rounded rectangles plus line connector ops consumed by the existing WPF and Avalonia compositor paths.

## Implemented

- `horizontalHierarchy` is now classified as live-layout-supported by the PPTX reader.
- The shared SmartArt layout engine places root/parent nodes on the left, child/report nodes in right-hand depth columns, and deeper descendants farther right.
- Connectors are emitted through the existing shared slide-shape connector model.
- Unsupported hierarchy-family siblings remain on cached `dsp:drawing` fallback.

## Evidence

- `freep/FreeP.App.Presentation.Tests/SmartArtLayoutTests.cs` covers direct layout geometry and compositor consumption over cached fallback.
- `freep/FreeP.App.Host.Tests/SmartArtTests.cs` covers reader classification and shared compositor ops from a minimal PPTX package.
- `tools/Generate-FreePCommandParityInventory.ps1` records this as workflow evidence in the generated FreeP command parity inventory.

## Remaining Work

Exact PowerPoint geometry/effects, richer hierarchy-family variants, SmartArt authoring regeneration for layout/style/color parts, and authoritative PowerPoint PNG baselines remain deferred.
