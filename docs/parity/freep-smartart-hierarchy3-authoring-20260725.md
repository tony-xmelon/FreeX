# FreeP SmartArt Hierarchy 3 Authoring - 2026-07-25

The native `hierarchy3` SmartArt layout can now be selected from the shared SmartArt
layout gallery in WPF and Avalonia. The command uses the existing shared hierarchy
layout engine and editing-session undo bus, updates the standard diagram layout part,
and persists through the existing PPTX writer/reader path.

The imported `hierarchy3` cached-render route remains unchanged. This slice adds the
authoring operation without changing the existing imported visual fallback; after the
user selects the layout, the shared planner owns the regenerated live model and cache.

## Verification

- `SmartArtEditingPlannerTests`: 201/201
- WPF SmartArt and ribbon tests: 242/242
- Avalonia SmartArt gallery registration: 1/1
- Ribbon definition tests: 22/22
- Localization tests: 11/11
- Full FreeP Release build: 0 warnings, 0 errors
