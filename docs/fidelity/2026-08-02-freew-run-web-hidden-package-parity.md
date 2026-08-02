# FreeW Word web-hidden run package parity

Date: 2026-08-02

## Scope

This package/model slice adds Word's web-layout-only hidden run property without making a renderer claim.

- `RunFormatting.WebHidden` defaults to `false` and maps to `w:rPr/w:webHidden`.
- The reader accepts empty, `1`, `true`, and `on` as enabled and `0`, `false`, and `off` as disabled.
- The writer emits enabled state canonically as an empty `w:webHidden` element and omits false state.
- Run, style, and document-default properties place `w:webHidden` after `w:vanish` and before `w:color`
  in the `CT_RPr` sequence.
- Document-default, nested-style, altChunk, and ODT overlays preserve inherited web-hidden state with the
  existing logical-OR semantics used by non-nullable run toggles.
- Immutable record copies and document block cloning retain the property.

## Evidence

Focused model tests cover defaults, record copies, and document block cloning. Focused DOCX tests cover
canonical XML, schema order, all Word on/off lexical forms, true/false behavior, adjacent visible-run
control, document defaults, styles, reopen, second save, and nested altChunk inheritance.

- Focused compiling/no-build gates: model `3/3`; IO `13/13`.
- Adjacent no-build gates: model formatting/merge `24/24`; IO hidden text, styles, defaults, typography,
  altChunk, and ODT `85/85`.
