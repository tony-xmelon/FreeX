# FreeW linked OLE object retention

## Gap

The DOCX reader discarded `o:OLEObject` runs whose `Type` was `Link`. Saving an otherwise unchanged Word
document could therefore remove a linked Excel or other OLE object from the body.

## Slice

- `EmbeddedObject` now represents either package-local payload bytes or an external linked target.
- The reader retains the external relationship target, ProgID, VML presentation icon, and rendered size.
- The writer emits `Type="Link"` and an OLE relationship with `TargetMode="External"`.
- Linked objects do not create a fabricated `word/embeddings/oleObject*.bin` part or `bin` content type.
- Clone/undo paths retain the linked target and independently copy the presentation image.

FreeW preserves linked-object semantics and presentation but does not open, activate, or refresh the external
OLE source.

## Verification

- `EmbeddedObjectRoundTripTests`: 9/9.
- Full `FreeW.Core.IO.Tests`: 1185/1185.
- `EmbeddedObjectTests`: 8/8.

The package contract covers an unrelated body-text edit followed by two writes. On both writes it asserts the
external URI and `TargetMode`, `Type="Link"`, ProgID, icon relationship and media bytes, absence of an embedded
payload part, and successful reopen.
