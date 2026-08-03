# FreeW custom XML checkbox-binding refresh

Date: 2026-08-04

## Result

FreeW now refreshes XML-mapped checkbox content controls from the authoritative custom XML value when a DOCX opens or when a caller invokes the existing refresh API.

The resolver accepts the XML Schema boolean lexical forms `true`, `false`, `1`, and `0`. A successful mapping updates both layers that Word owns:

- the semantic checkbox `Checked` state serialized as `w14:checked/@w14:val`;
- the visible checked or unchecked glyph, including authored `w14:checkedState` and `w14:uncheckedState` code points.

Every run in the same structured-document-tag range receives one shared updated control instance. Invalid boolean text leaves the cached display and semantic state unchanged, rather than guessing from non-schema values such as `yes`.

## Evidence

`DataBoundContentControlRoundTripTests` covers all four valid XML boolean lexical forms, custom checked/unchecked glyphs, invalid-value preservation, serialized `w14:checked` state, and reopened-model state. The prior plain-text and list-binding cases remain in the same focused gate.

## Process rule

For mapped stateful controls, refresh model semantics and visible content together, then assert the serialized package and reopened model. Do not treat a changed display glyph alone as functional parity.
