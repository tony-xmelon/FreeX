# FreeW Nested Group Shape Formatting

## Scope

FreeW could select direct and nested grouped shapes, move/resize/rotate them, edit their text, and edit
custom-geometry points. Drawing Format Change Shape, Alt Text, fill, outline, style preset, extended fill,
and effects commands still resolved only a top-level `Run.Shape`, so those actions silently did nothing for
a selected grouped child.

The shared formatting commands now accept the same root-relative child path used by grouped-child geometry
and text commands. WPF and Avalonia detect a selected nested Shape and pass that path for:

- solid fill and no fill;
- preset geometry through Change Shape;
- trimmed or cleared alternative text;
- exact width and height through the Shape Size dialog and gallery presets;
- outline color, width, and dash;
- Shape Styles gallery presets;
- gradient, pattern, and no-fill descriptors;
- shadow, glow, reflection, soft-edge, and bevel effect bundles.

Each command changes only the selected leaf, preserves siblings and owning group geometry, and remains a
single undoable edit. The existing native DrawingML grouped-shape writer persists the result, and save/reopen
tests verify the selected leaf's preset geometry, `docPr` description, fill, outline, dash, width, and glow
while the sibling remains unchanged.

## Verification

- shared nested formatting command test: 1/1;
- WPF grouped-child selection/format/undo test: 1/1;
- Avalonia grouped-child selection/format/undo test: 1/1;
- grouped-shape DOCX save/reopen test: 1/1;
- WPF Release host build: 0 warnings, 0 errors;
- Avalonia Release host build: 0 warnings, 0 errors.

## Remaining Scope

This slice does not add child-local wrapping. Wrapping remains owned by the floating group container.
