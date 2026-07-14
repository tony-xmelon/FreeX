# FreeP SmartArt Labeled Hierarchy Parity Slice - 2026-07-14

## Scope

This slice admits PowerPoint SmartArt `labeledHierarchy` as a bounded shared live-layout layout.
The planner remains renderer-neutral: parsed SmartArt hierarchy data is converted into ordinary
`SlideShape` rounded rectangles plus line connector ops consumed by the existing WPF and Avalonia
compositor paths.

This is intentionally a shared hierarchy approximation. It does not claim true PowerPoint
label geometry, label-specific spacing, or effect fidelity.

## Implemented

- `PptxPackageReader` marks `labeledHierarchy` as live-layout supported.
- The existing shared hierarchy-family planner emits live boxes and connectors for parsed root and child nodes.
- WPF and Avalonia consume the same shared compositor draw ops; there is no renderer-local SmartArt policy.
- Other unsupported hierarchy-family siblings remain on cached `dsp:drawing` fallback.

## Evidence

- `freep/FreeP.App.Presentation.Tests/SmartArtLayoutTests.cs` covers compositor consumption over cached fallback.
- `freep/FreeP.App.Host.Tests/SmartArtTests.cs` covers reader classification and shared compositor ops from a minimal PPTX package.
- `tools/Generate-FreePCommandParityInventory.ps1` records this as workflow evidence in the generated FreeP command parity inventory.

## Remaining Work

Exact PowerPoint label geometry/effects, richer hierarchy-family variants, SmartArt authoring
regeneration for layout/style/color parts, and authoritative PowerPoint PNG baselines remain deferred.
