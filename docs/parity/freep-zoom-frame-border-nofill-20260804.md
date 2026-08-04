# FreeP Zoom Frame Border: Explicit No-Fill

Date: 2026-08-04

FreeP now preserves and authors an explicit native PowerPoint Zoom frame border
`a:noFill` state. The state is distinct from an absent border object, survives
the shared model and PPTX reader/writer, participates in the existing undo/redo
command, and is available in both WPF and Avalonia Zoom formatting dialogs.

The compositor treats native `a:noFill` as an intentionally borderless frame,
including when legacy or unknown line-fill payload is present. Clearing the
state returns to the existing border behavior. This slice is function-first;
it adds no new Word/PowerPoint raster baseline claim.

## Verification

- Presentation planner and compositor contracts cover explicit state and native
  outline suppression.
- WPF round-trip coverage verifies XML, undo/redo, and reopen behavior.
- WPF and Avalonia source guards verify the authoring control is present.
