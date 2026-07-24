# FreeP custom Edit Points

FreeP now exposes imported custom/freeform geometry vertices through the shared
Edit Points mode in WPF and Avalonia.

## Scope

- Existing `a:custGeom` paths are enumerated without changing their authored path data.
- `MoveTo` and `LineTo` vertices receive draggable handles in the shared planner.
- Pointer coordinates are converted from slide DIP space into the path's authored `w`/`h`
  coordinate space and committed through `SetCustomGeometryPointCommand`.
- The existing custom-geometry writer/read path preserves the edited coordinates on save and
  reopen.
- Curved-segment control points and vertex insertion/deletion remain deferred to a later
  Edit Points slice.

## Verification

- Shared custom-vertex planner and mutation tests pass.
- Presentation command tests cover apply, undo, and redo.
- Existing custom-geometry package round-trip tests retain exact segment coordinates.
- WPF host and Avalonia adorner routes compile and focused interaction tests remain green.
