# FreeW manual soft-hyphen package parity

## Gap

Word stores an authored optional break as `w:softHyphen` between run text fragments. FreeW previously ignored
that element while reading and wrote U+00AD only as literal text, so a Word-authored manual hyphen could vanish
after an unrelated edit and save.

## Slice

- The DOCX reader reconstructs `w:t`, `w:delText`, `w:softHyphen`, and `w:tab` in authored child order.
- `w:softHyphen` maps to the model's U+00AD soft-hyphen character at its exact run-text offset.
- The writer splits modeled text at U+00AD and emits schema-native `w:softHyphen` elements.
- Plain text runs retain the existing single-`w:t` path and do not gain optional breaks.

This is the durable package prerequisite for interactive manual hyphenation. It does not by itself add the
per-word accept/skip dialog.

## Verification

- `SoftHyphenRoundTripTests`: 2/2.
- Full `FreeW.Core.IO.Tests`: 1187/1187.

The package test performs an unrelated body-text edit and two writes, checking child order, exact text
fragments, reopened model text, and a plain-text no-soft-hyphen control.
