# FreeP Text Direction Authoring - 2026-07-28

PowerPoint exposes text direction choices for a selected text frame and for table-cell
text. FreeP already preserved `a:bodyPr/@vert`, rendered all six modeled
`TextVerticalType` values, and round-tripped them through PPTX, but neither host exposed
an authoring command.

This slice adds the shared `freep.text-direction` combo with Horizontal, Rotate 90
degrees, Rotate 270 degrees, East Asian vertical, WordArt vertical, and WordArt vertical
RTL choices. Shape selections use one undoable batch command; an active table cell routes
through the corresponding cell command. WPF and Avalonia use the same parser and command
surface.

Evidence:

- `TextVerticalTypeAuthoringTests` covers the user-facing labels and native aliases.
- Presentation command tests cover shape and table-cell apply, undo, and redo.
- Ribbon profile tests verify both generated host profiles expose the same options.
- Host tests verify selected-shape and active-cell routing.
- Existing W18B PPTX vertical-text round-trip and compositor tests remain the package/render
  contract; this is function parity and does not claim a new visual calibration.
