# FreeW Borders and Shading Parity - Wave 95

This slice tightens the Avalonia `Borders and Shading` dialog against the WPF authority for the high-delta states: initial, populated, Borders, Page Border, and validation.

## Implementation

- Keeps the WPF 420px three-tab arrangement and shared planner/apply contract.
- Applies the compact shared chrome to border width fields and edge checkboxes so row heights use the WPF-sized controls.
- Restores focus-and-select behavior on the paragraph width field when the dialog opens.
- Keeps invalid widths in the dialog and displays the shared validation message without closing the surface.
- Adds explicit Escape cancellation and stable automation IDs for the dialog, tabs, fields, edge toggles, validation message, and OK/Cancel actions on both hosts.
- Preserves localized action names and WPF default/cancel semantics.

## Verification

Focused verification is recorded with `BordersAndShadingDialogVisualParityTests`, covering geometry/action order, metadata, open focus/selection, invalid-width validation, and WPF source parity.

The existing paired evidence remains the baseline for this family: initial/populated/Borders/validation are approximately 11.5% changed pixels, and Page Border is approximately 15.16%. Remaining visual delta is expected from Avalonia versus WPF template and text rasterization differences; no generated inventory or global theme/ribbon files were changed in this slice.
