# FreeP SmartArt Authoring Tail 2 - 2026-07-24

This slice exposes five additional SmartArt layouts that the reader already admits to
the shared live layout engine but that were previously import-only from the authoring
surface:

- `basicChevronProcess`
- `closedChevronProcess`
- `bendingProcess`
- `blockCycle`
- `nonDirectionalCycle`

Each layout has a shared authoring preset, localized WPF/Avalonia ribbon command, native
diagram-layout ID, and the existing undoable editing-session route. The layouts use the
bounded shared process/cycle geometry already exercised by the live renderer; this slice
does not claim exact PowerPoint polygon, block, or gear geometry.

The authoring path is intentionally symmetric: WPF and Avalonia register the same command
IDs, both update the live model and native layout part, and the existing undo/redo session
owns the mutation. The command inventory now reports 238 total IDs, 236 shared, and zero
actionable host gaps.

## Verification

- Shared planner native-layout matrix: includes all five new IDs
- Generated command inventory: 238 total, 236 shared, 0 actionable host gaps
- WPF and Avalonia command-registration matrices cover every new command
- `SmartArtEditingPlannerTests`: 66/66
- `FreePRibbonDefinitionProfileTests`: 18/18
- WPF host SmartArt/ribbon registration filter: 36/36
- Avalonia headless SmartArt registration filter: 14/14
