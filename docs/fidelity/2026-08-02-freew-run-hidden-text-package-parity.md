# FreeW Word hidden-run package parity

Date: 2026-08-02

## Scope

This slice adds the model and DOCX package half of Word hidden text. It intentionally makes no WPF,
Avalonia, pagination, PDF, or visual-rendering claim.

- `RunFormatting.Hidden` defaults to `false` and represents `w:rPr/w:vanish`.
- The DOCX reader accepts the complete Word on/off lexical set through the shared `ReadToggle` path:
  empty, `1`, `true`, and `on` enable the property; `0`, `false`, and `off` disable it.
- The DOCX writer emits enabled state canonically as an empty `w:vanish` element and omits false state.
- Run, style, and document-default writers place `w:vanish` in the `CT_RPr` sequence after the strike
  region and before `w:color`.
- Existing non-nullable boolean inheritance semantics are preserved: hidden state composes with logical
  OR across document defaults and style overlays. A direct false value means no direct hidden toggle and
  cannot erase inherited true state.
- ODT overlay helpers preserve an already-hidden run without adding an ODT serialization mapping.

## Evidence

Focused model tests cover the false default, immutable record-copy retention, and document block cloning. Focused DOCX tests cover
exact XML, canonical order, all lexical forms, true/false behavior, adjacent visible-run control, document
defaults, styles, reopen, second save, and direct-false behavior. Existing nested Word altChunk tests cover
logical-OR flattening across inherited style and document-default formatting.
