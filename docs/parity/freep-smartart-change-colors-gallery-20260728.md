# FreeP SmartArt Change Colors Gallery

FreeP now exposes the complete PowerPoint SmartArt Change Colors catalog in both WPF and
Avalonia. The catalog was enumerated from the installed PowerPoint COM server on 2026-07-28:
38 entries, including the four Colorful ranges and five variants for each Accent 1-6 family.

Each menu route writes the native `dgm:colorsDef/@uniqueId`, title, category, and node fill
palette. The raw colors part remains the package authority, while the live `SmartArtColorMetadata`
is updated for the compositor and subsequent edits. The eight original FreeP command IDs remain
compatibility routes and now resolve to their corresponding native gallery entries.

Focused contracts:

- `SmartArtAuthoringPlannerTests`: all 38 native IDs round-trip through the planner/model.
- `FreePRibbonDefinitionProfileTests`: WPF and Avalonia expose the same 38-item Change Colors menu.
- `FreeP.App.Presentation` Release build: clean.

This slice is functional/package parity. It does not claim PowerPoint-authoritative raster parity
for every color effect; gradient and transparency rendering remains a separate visual-fidelity
work item.
