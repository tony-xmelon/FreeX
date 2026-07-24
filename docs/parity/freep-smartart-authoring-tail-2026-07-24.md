# FreeP SmartArt Authoring Tail - 2026-07-24

This slice exposes four SmartArt layouts that were already supported by the reader and
shared live layout engine but were still import-only from the authoring surface:

- `segmentedProcess`
- `chevronProcess`
- `gearCycle`
- `textCycle`

Each layout now has a shared `SmartArtLayoutPreset`, a command ID and localized ribbon
entry in both WPF and Avalonia. Executing a command routes through the existing shared
editing session, updates the live model and native diagram layout part, and remains
undoable. The render engine continues to use its existing bounded process/cycle geometry;
this slice does not claim exact PowerPoint polygon or gear-tooth visual parity.

## Verification

- `SmartArtEditingPlannerTests`: 61/61
- `FreePRibbonDefinitionProfileTests`: 18/18
- WPF host SmartArt/ribbon slice: 31/31
- Avalonia `MainWindowHeadlessTests.SmartArt`: 14/14
- Generated command inventory: 233 total, 231 shared, 0 actionable host gaps
