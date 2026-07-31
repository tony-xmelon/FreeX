# FreeW Avalonia Shape format dialogs

## Resolved behavior

WPF opens seeded owner-modal dialogs for the Drawing Format Position, Size, and
Alt Text primary commands. Avalonia already supported deterministic value and
preset commands, but normal empty-context button execution was inert.

Avalonia now reuses the existing picture-format dialog implementations through
shape-aware shell callbacks:

- Position opens with the selected Shape's offsets and anchors and applies an
  accepted result through the undoable floating-position command.
- Size opens with the selected Shape's width and height and applies an accepted
  result through the undoable floating-size command.
- Alt Text opens with the current description for either Shape or WordArt and
  applies an accepted result through the target-specific undoable command.

Picture call sites retain their existing titles and behavior. Shape Position
and Size use Shape-specific window titles. Existing explicit value/preset
automation is unchanged; invalid nonempty values remain no-ops.

## Verification

- FreeW.App.Avalonia Release build: 0 warnings, 0 errors.
- PictureDrawingContextualTabTests: 29/29 passed.
- PictureCoreCommandParityTests: 34/34 passed.
- Tests cover seeded target ownership, accepted Position/Size/Alt Text changes,
  cancellation/no mutation, Undo, and WordArt alt-text targeting.

No Word COM export is required for this command/dialog/model behavior slice.
