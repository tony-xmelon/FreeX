# FreeP SmartArt Table Hierarchy Parity Slice - 2026-07-14 / Wave 26 depth

## Scope

This slice admits PowerPoint SmartArt `tableHierarchy` as a bounded shared live-layout layout.
The Wave 26 depth closes the generic-family gap: parsed hierarchy data is converted into a
renderer-neutral table plan with full-width root headers, aligned child-group columns, and
vertical descendant cells. The table definition's no-connecting-lines invariant is preserved.

This is intentionally a shared hierarchy approximation. It does not claim exact PowerPoint table
grid geometry, cell styling, spacing, or effect fidelity.

## Implemented

- `PptxPackageReader` keeps `tableHierarchy` in the bounded live-layout allow-list.
- `SmartArtLayoutEngine` emits shared rectangular cells with no connector shapes for table hierarchy groups.
- `SmartArtEditingPlanner` regenerates the drawing cache from the same table cell plan.
- WPF and Avalonia consume the same shared compositor draw ops; there is no renderer-local SmartArt policy.
- Other unsupported hierarchy-family siblings remain on cached `dsp:drawing` fallback.

## Evidence

- `freep/FreeP.App.Presentation.Tests/SmartArtLayoutTests.cs` covers compositor consumption over cached fallback.
- `freep/FreeP.App.Presentation.Tests/SmartArtEditingPlannerTests.cs` covers cache regeneration parity.
- `freep/FreeP.App.Host.Tests/SmartArtTests.cs` covers reader classification and imported WPF-host composition from a minimal PPTX package.
- `freep/FreeP.App.Avalonia.Tests/MainWindowHeadlessTests.cs` covers Avalonia consumption of the same cell plan.
- `tools/Generate-FreePCommandParityInventory.ps1` is the generator provenance for the refreshed inventory evidence rows.

## Remaining Work

Exact PowerPoint table hierarchy cell sizing, styling, spacing/effects, broader multi-group
semantics, authoring regeneration for layout/style/color parts, and authoritative PNG baselines
remain deferred.
