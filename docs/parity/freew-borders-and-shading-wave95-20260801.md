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

Focused verification is recorded with `BordersAndShadingDialogVisualParityTests`, covering geometry/action order, metadata, open and tab-specific focus, invalid-width validation, and WPF source parity.

Fresh route-scoped WPF/Avalonia captures passed the content gate for all six states and removed every semantic difference. Changed pixels improved from 11.52% to 11.28% for initial, populated, and Borders; from 15.16% to 14.15% for Page Border; from 8.20% to 7.08% for Shading; and from 11.64% to 11.38% for validation. All six remain honest visual mismatches because native tab, field, and text rendering still differ. Evidence is retained under `artifacts/freew-dialog-harness/wave95-borders`; no generated inventory or global theme/ribbon file was changed.
