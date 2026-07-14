# FreeP SmartArt Table Hierarchy Parity Slice - 2026-07-14

## Scope

This slice admits PowerPoint SmartArt `tableHierarchy` as a bounded shared live-layout layout.
Parsed SmartArt hierarchy data is converted into ordinary `SlideShape` rounded rectangles plus
line connector ops consumed by the existing WPF and Avalonia compositor paths.

This is intentionally a shared hierarchy approximation. It does not claim exact PowerPoint table
grid geometry, cell styling, spacing, or effect fidelity.

## Implemented

- `PptxPackageReader` marks `tableHierarchy` as live-layout supported.
- The existing shared hierarchy-family planner emits live boxes and connectors for parsed root and child nodes.
- WPF and Avalonia consume the same shared compositor draw ops; there is no renderer-local SmartArt policy.
- Other unsupported hierarchy-family siblings remain on cached `dsp:drawing` fallback.

## Evidence

- `freep/FreeP.App.Presentation.Tests/SmartArtLayoutTests.cs` covers compositor consumption over cached fallback.
- `freep/FreeP.App.Host.Tests/SmartArtTests.cs` covers reader classification and fallback policy from minimal PPTX packages.
- `tools/Generate-FreePCommandParityInventory.ps1` records this as workflow evidence in the generated FreeP command parity inventory.

## Remaining Work

Exact PowerPoint table hierarchy grid geometry/effects, SmartArt authoring regeneration for
layout/style/color parts, and authoritative PowerPoint PNG baselines remain deferred.
