# FreeP custom Edit Points

FreeP now exposes imported custom/freeform geometry vertices through the shared
Edit Points mode in WPF and Avalonia.

## Scope

- Existing `a:custGeom` paths are enumerated without changing their authored path data.
- `MoveTo` and `LineTo` vertices receive draggable handles in the shared planner.
- Pointer coordinates are converted from slide DIP space into the path's authored `w`/`h`
  coordinate space and committed through `SetCustomGeometryPointCommand`.
- Cubic and quadratic segments expose their authored control points and endpoints as
  separate handles; each drag remains one undoable command.
- With a custom vertex active, `Insert` adds a midpoint on the following/closing line and
  `Delete`/`Backspace` removes a line vertex when at least two endpoints remain; both routes
  are shared WPF/Avalonia undoable commands.
- The existing custom-geometry writer/read path preserves the edited coordinates on save and
  reopen.
- Arc control editing remains deferred to a later Edit Points slice.

## Verification

- Shared custom-vertex planner and mutation tests pass.
- Presentation command tests cover apply, undo, and redo.
- Existing custom-geometry package round-trip tests retain exact segment coordinates.
- Curve control coordinates are covered by package round-trip tests.
- Insert/delete commands and session routing are covered by undo/redo tests.
- WPF host and Avalonia adorner routes compile and focused interaction tests remain green.
