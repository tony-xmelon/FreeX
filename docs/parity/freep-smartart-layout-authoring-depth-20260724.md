# FreeP SmartArt layout authoring depth

## Scope

FreeP now exposes ten SmartArt layout presets through the ribbon, WPF host command registry, and Avalonia command registry. The original Process, Vertical Box List, and Basic Cycle choices are joined by Basic Block List, Stacked List, Basic Pyramid, Radial Cycle, Basic Matrix, Basic Venn, and Basic Hierarchy.

Each command updates the live `SmartArtData` family and native `dgm:layoutDef` unique ID together. The existing layout engine already owns these layout paths, so authoring and reopening a presentation use the same native layout identity rather than a renderer-only approximation.

## Verification

- Presentation planner coverage exercises all ten presets and checks the native layout part.
- Host package round-trip coverage exercises all ten presets and checks the reread family and native layout identity.
- The command IDs are registered in both WPF and Avalonia hosts and surfaced in the SmartArt layouts ribbon group.

## Remaining depth

This slice does not claim full PowerPoint SmartArt gallery coverage. Additional long-tail layout IDs, SmartArt text-pane editing, per-node promotion/demotion, and richer layout-specific constraints remain future work.
