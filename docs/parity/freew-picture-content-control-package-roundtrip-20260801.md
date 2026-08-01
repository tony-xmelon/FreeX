# FreeW picture content-control package round-trip (2026-08-01)

## Scope

This slice preserves Word run-level picture content controls identified by
`w:sdtPr/w:picture`. It is intentionally limited to the Core Model and DOCX
reader/writer. No host interaction or rendering behavior changes.

## Previous behavior

The reader treated `w:picture` as a plain-text control. When the SDT content was
a DrawingML picture, the image decoder returned an `InlineImage` run without the
inherited control mark. Saving therefore retained the image but discarded the
picture-control identity and its common SDT metadata.

## Implemented contract

- `ContentControlKind.Picture` identifies `w:sdtPr/w:picture`.
- `Run.PictureControl` creates an image run with that identity.
- The reader retains the inherited control on decoded image runs.
- The writer emits the canonical empty `w:picture` property and reuses the
  existing common metadata path for alias, lock, placeholder, placeholder state,
  data binding, temporary state, ID, tag, and appearance.
- Plain, rich-text, checkbox, date, list, combo-box, and repeating-section paths
  remain unchanged.

## Evidence

`PictureContentControlRoundTripTests` builds an exact DOCX ZIP package containing
a valid DrawingML image inside a `w:picture` SDT. It checks the imported model,
serialized XML and media relationship, reopened model, second save, and Office
2013 schema validity. `PictureContentControlModelTests` covers the model factory.
