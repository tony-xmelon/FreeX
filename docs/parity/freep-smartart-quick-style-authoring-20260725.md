# FreeP SmartArt Quick Style authoring - 2026-07-25

FreeP now exposes a bounded SmartArt Change Style workflow in both WPF and Avalonia.

## Scope

- Simple, Moderate, and Intense Quick Style presets are available from the SmartArt design ribbon.
- The shared authoring planner updates the native `dgm:styleDef/@uniqueId` and title metadata.
- If an imported graphic has no style part, the operation creates a deterministic native
  `diagramStyle` part and `qs` relationship so the choice survives save/reopen.
- Host edits use `EditingSession.EditSmartArt` and `ReplaceSmartArtCommand`, so each choice is one
  undo/redo operation.

This is a functional/package-authority slice. It does not claim PowerPoint-authoritative style
rendering for every SmartArt family; unsupported live visual behavior remains on the existing
cached drawing path.

## Verification

- Shared SmartArt authoring planner: 34/34 focused tests.
- WPF native style package persistence: 3/3 focused tests.
- Avalonia command and undo routing: 1/1 focused headless test.
- WPF and Avalonia Release builds: 0 warnings, 0 errors.
