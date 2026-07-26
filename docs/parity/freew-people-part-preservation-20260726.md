# FreeW Word People-Part Preservation

Date: 2026-07-26

## Scope

Preserve Word's Office 2013+ `word/people.xml` part, which retains contact
metadata for comment and revision authors.

## Behavior

- FreeW continues to model comment content and thread state independently.
- The reader preserves the author-identity payload, its document relationship,
  its content type, and any local relationship graph verbatim.
- The writer re-emits the payload so Word can retain co-author identity after a
  FreeW save.

## Verification

The focused `PreservedPartsRoundTripTests` regression checks byte-identical
payload retention, rebuilt document relationship and content type, plus a
second complete read/write cycle.
