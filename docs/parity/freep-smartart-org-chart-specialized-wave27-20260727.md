# FreeP SmartArt `orgChart` Specialized Shared Layout - Wave 27

## Selection

This slice selects the native SmartArt layout ID `orgChart` (Organization Chart),
which is the hierarchy-family ID used by the FreeP SmartArt corpus fixture. The
existing reader admission and generic hierarchy approximation did not expose the
org-chart-specific assistant box semantics through a dedicated plan.

## Implemented

- `SmartArtLayoutEngine` routes `orgChart` through a dedicated shared plan.
- Root and regular report nodes use shared rounded boxes.
- Imported `dgm:pt type="asst"` nodes use shared rectangular assistant boxes while
  retaining the bounded side-slot placement and parent connector semantics.
- WPF and Avalonia consume the same ordinary `SlideShape` and connector operations;
  no host-specific SmartArt geometry was added.
- `SmartArtEditingPlanner.RegenerateDrawingCache` serializes the same dedicated plan.
- Layout IDs outside the bounded reader allow-list still set
  `IsLiveLayoutSupported=false` and retain cached `dsp:drawing` fallback.

## Evidence

- `freep/FreeP.App.Presentation.Tests/SmartArtLayoutTests.cs` covers dedicated
  assistant box geometry and the shared connector count.
- `freep/FreeP.App.Presentation.Tests/SmartArtEditingPlannerTests.cs` covers
  cache regeneration and persisted assistant shape kind.
- `freep/FreeP.App.Host.Tests/SmartArtTests.cs` covers reader classification,
  assistant metadata, and WPF composition from a minimal PPTX package.
- `freep/FreeP.App.Avalonia.Tests/MainWindowHeadlessTests.cs` covers Avalonia
  composition from the same shared plan.
- `tools/FreeP.RenderCompare/CorpusGenerator.cs` is the corpus provenance for the
  hierarchy/Organization Chart scenario.
- `tools/Generate-FreePCommandParityInventory.ps1` records this workflow evidence
  in the generated parity inventory.

## Residuals

This is functional shared-plan evidence, not a claim of PowerPoint pixel parity.
Exact PowerPoint org-chart connector routing, assistant connector junctions,
box metrics, style/effect fidelity, native authoring regeneration for layout/style/
color parts, and authoritative PNG baselines remain deferred.
