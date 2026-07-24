# FreeP SmartArt authoring slice

FreeP now exposes a functional SmartArt Change Colors workflow in both WPF and Avalonia.

- Theme Accents, Single Accent, and Grayscale presets are registered as ribbon commands.
- The shared Design ribbon now exposes those commands with localized labels in both profiles.
- When an imported SmartArt package omits `diagramColors`, Change Colors now creates a
  deterministic native colors part and relationship so the edit survives save/reopen.
- The shared authoring planner updates the live `SmartArtColorMetadata.Palette` and the native
  `diagramColors` XML part, so the change is preserved through save/reopen.
- The edit is committed through `EditingSession.EditSmartArt` and `ReplaceSmartArtCommand`, giving
  the operation one undo/redo unit and regenerating the current drawing cache for both hosts.
- The implementation intentionally leaves SmartArt quick-style authoring for a separate slice;
  this change is limited to the PowerPoint Change Colors behavior.

Verification covers the shared planner, WPF host, and Avalonia host, including native-part mutation
and undo/redo restoration.
