# FreeW checkbox content-control state metadata parity (2026-08-02)

## Scope

This bounded package slice preserves the optional WordprocessingML metadata carried by
`w14:checkbox/w14:checkedState` and `w14:checkbox/w14:uncheckedState`:

- `w14:val`, retained as the authored glyph-codepoint token.
- `w14:font`, retained as the authored font-family token.
- State-element absence remains distinct from a present state element.

The existing `ContentControl.Checked` boolean, checked/unchecked run glyphs, and rendering behavior are
unchanged.

## Model and package behavior

`ContentControlCheckBoxMetadata` contains independently optional checked and unchecked state records.
Each `ContentControlCheckBoxStateMetadata` preserves the optional glyph-codepoint and font strings.
The DOCX reader recovers these values only from the inline `w14:checkbox` owner. The writer emits the
existing canonical `w14:checked` boolean first, followed by only the state elements present in the model.

No numeric or case normalization is applied to `w14:val`; preserving the source token avoids inventing a
canonical form that the existing package conventions do not require.

## Evidence

Focused tests cover:

- Source XML containing both state elements and their two attributes.
- The reopened model and unchanged checked boolean semantics.
- Canonical saved child ordering and exact state tokens.
- A second save with stable checkbox XML.
- An unchecked control with both metadata elements absent across both saves.
- Microsoft 365 Open XML schema validation after each save.

Relevant full `FreeW.Core.Model.Tests` and `FreeW.Core.IO.Tests` suites are required before integration.
