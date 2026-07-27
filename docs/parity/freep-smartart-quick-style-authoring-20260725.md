# FreeP SmartArt Quick Style authoring - 2026-07-25

FreeP now exposes a bounded SmartArt Change Style workflow in both WPF and Avalonia.

## Scope

- All 14 PowerPoint SmartArt Quick Style gallery entries are available from the SmartArt design ribbon:
  Simple Fill, White Outline, Subtle Effect, Moderate Effect, Intense Effect, Polished,
  Inset, Cartoon, Powder, Brick Scene, Flat Scene, Metallic Scene, Sunset Scene, and
  Bird's Eye Scene.
- The shared authoring planner updates the native `dgm:styleDef/@uniqueId` and title metadata.
- If an imported graphic has no style part, the operation creates a deterministic native
  `diagramStyle` part and `qs` relationship so the choice survives save/reopen.
- Host edits use `EditingSession.EditSmartArt` and `ReplaceSmartArtCommand`, so each choice is one
  undo/redo operation.

This is a functional/package-authority slice. It does not claim PowerPoint-authoritative style
rendering for every SmartArt family; unsupported live visual behavior remains on the existing
cached drawing path.

## Verification

- Shared SmartArt authoring planner: 14 native style identifiers/titles covered.
- WPF native style package persistence: 14 gallery entries covered.
- Avalonia legacy command and undo routing: Intense and Cartoon focused headless tests.
- WPF and Avalonia Release builds: 0 warnings, 0 errors.
