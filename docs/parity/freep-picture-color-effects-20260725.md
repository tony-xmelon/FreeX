# FreeP picture color effects

FreeP already preserved and rendered picture color effects from PresentationML, but the authoring
surface exposed crop commands only. This slice adds shared, undoable picture color-effect commands
for both desktop hosts:

- **Grayscale** applies `a:grayscl` to every selected picture.
- **Reset Effects** removes grayscale, bi-level, brightness, contrast, and alpha adjustments while
  preserving the picture crop and frame.

Both commands route through `EditingSession` and `PresentationCommandBus`, so multi-selection edits
remain undoable and redoable as one command per picture. The command keeps crop data independent and
removes `PictureFormat` only when no crop or color effect remains.

Focused verification: FreeP Release solution build, picture command tests, WPF ribbon routing,
Avalonia ribbon registration, and localization resource coverage.
