# Avalonia Parity Wave 50: FreeW Object Text Direction

## Scope

This slice started with a bounded source comparison of the WPF and Avalonia FreeW
document hosts around the two documented residual areas: Page Edit and richer
grouped-child/object editing.

Page Edit was already present on both hosts. Avalonia also already had group and
ungroup commands, multi-selection, grouped-child rendering, shape edit points, and
floating-object transforms. The highest-confidence concrete gap was the WPF Drawing
Format > Text Direction route for text-box shapes.

## Closed behavior

- Avalonia registers the existing WPF-compatible `Horizontal`, `Rotate 90`, and
  `Rotate 270` ribbon command IDs.
- The Avalonia editor routes those commands through the shared
  `SetShapeTextDirectionCommand`, preserving undo/redo behavior.
- Avalonia carries `ShapeTextDirection` from the shared drawing-object visual plan
  into the floating-shape renderer.
- Rotated text is transformed around the shape center while the shape geometry,
  outline, effects, selection, and object-level rotation remain unchanged.

## Verification

- WPF focused test: `ShapeEditPointsInteractionTests.SetSelectedShapeTextDirection_updates_text_box_model_for_wpf_route`
- Avalonia focused tests: `DocumentViewFloatingShapeTests.Selected_floating_text_box_text_direction_uses_shared_undo_command` and
  `CommandRegistryTests.Drawing_text_direction_commands_are_registered_for_all_wpf_modes`
- Linux physical evidence was not added in this slice: the existing FreeW Linux
  physical harness does not provide a stable seeded text-box selection and contextual
  ribbon route for this command. The behavior is covered at the host/editor and
  shared-command boundaries instead.

## Remaining limitations

- Full visual screenshot comparison for rotated text in the Linux Docker harness is
  still outstanding.
- Grouped-child direct selection/editing remains a separate, larger interaction slice;
  this change preserves the existing grouped-child rendering and group-level editing.
- Page Edit remains functionally covered by the existing Avalonia live Print Layout
  surface and its current parity tests; a dedicated Linux physical Page Edit evidence
  row is still useful for future visual validation.
