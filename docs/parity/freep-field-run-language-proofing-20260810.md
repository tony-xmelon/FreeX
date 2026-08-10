# FreeP native field-run language and proofing metadata

## Functional gap

PowerPoint DrawingML fields can carry run-level `a:rPr` language and proofing
state inside `a:fld`. FreeP already preserved those tokens for ordinary
`a:r` runs, but native field runs dropped them during import and rich clipboard
round-trip.

## Change

`FieldRun` now retains `lang`, `altLang`, `dirty`, `noProof`, and `err` from its
nested `a:rPr`. Field-level `a:fld/@dirty` remains separate from the run-level
dirty token. The reader exposes the same values on the containing `Run` for
editing consumers, while the writer emits the authored nullable values without
inventing omitted tokens. Model clones and the in-canvas rich clipboard carry
the metadata unchanged.

## Verification

- `MediaFieldsTests`: `38/38` focused tests passed.
- `InCanvasRichClipboardTests`: `10/10` focused tests passed.
- The consuming WPF host and shared presentation test projects compiled in
  Release while running those focused lanes, with no new warnings or errors.

This is package/editing parity only. It does not claim a new proofing engine or
visual spell-check behavior.
