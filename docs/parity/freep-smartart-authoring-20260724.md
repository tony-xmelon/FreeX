# FreeP SmartArt authoring slice

FreeP now exposes a functional SmartArt Change Colors workflow in both WPF and Avalonia.

- Theme Accents, Monochromatic Accent 1-6, and Grayscale presets are registered as ribbon commands.
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
and undo/redo restoration. The planner color-preset tests pass **6/6**, WPF SmartArt tests pass
**145/145**, Avalonia SmartArt/ribbon tests pass **30/30**, and the ribbon definition profile passes
**22/22**. The generated command inventory now reports **251 total / 249 shared** commands with
zero actionable host gaps.
