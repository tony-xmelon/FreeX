# XPS Document Properties

## Goal

Bring XPS export closer to the existing PDF export option by honoring the modeled Include Document Properties flag.

## Implementation Notes

- Added failing planner/source tests for XPS option summaries and package property writing.
- Added `XpsDocumentProperties` to map workbook name plus deterministic FreeX metadata into XPS package core properties.
- Wired XPS export to apply metadata before creating the `XpsDocument` writer.
- Architecture decision: PDF and XPS share the same small modeled metadata subset; full Office document-property fidelity remains out of scope.
