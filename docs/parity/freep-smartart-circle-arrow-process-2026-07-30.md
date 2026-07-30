# FreeP Circle Arrow Process SmartArt

FreeP now recognizes PowerPoint's native `circleArrowProcess` SmartArt layout as
a live Process-family authoring route.

- Insert and Change Layout preserve the native layout unique ID through the
  shared WPF and Avalonia ribbon paths.
- The package reader marks imported diagrams as live-layout supported, so text
  edits and cache regeneration use current model nodes instead of stale cached
  drawing shapes.
- The current shared connector primitive is a straight line. Stage placement
  and loop connectivity are live and round-trip safe; PowerPoint's curved
  arrowhead artwork remains a visual-fidelity follow-up until the model gains
  that connector primitive.

Focused verification on the implementation branch:

- `FreeP.App.Presentation.Tests` SmartArt filter: 325/325
- `FreeP.App.Host.Tests` SmartArt filter: 240/240
- `FreeP.App.Avalonia.Tests` SmartArt filter: 21/21
