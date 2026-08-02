# FreeW document-default advanced typography retention

## Scope

FreeW already models, edits, reads, writes, and renders Word's Advanced Font typography
properties on ordinary runs. They were not copied from or emitted back to
`w:docDefaults/w:rPrDefault/w:rPr`, so a Word read/save cycle could silently discard
document-wide typography inherited by otherwise-unformatted runs.

This slice retains:

- `w:spacing`, `w:kern`, and `w:position`
- `w14:ligatures`
- `w14:numForm` and `w14:numSpacing`
- `w14:stylisticSets/w14:styleSet`

Core WordprocessingML properties remain before font size and the `w14` extension region;
OpenType properties are emitted after all core run properties.

## Verification

- Focused `DocDefaultsRoundTripTests`: 7/7 passed.
- Combined document-default, typography, and broad DOCX round-trip gate: 253/253 passed.
- The focused contract asserts raw `styles.xml` values/order and the reopened model.
- `git diff --check`: clean.

The focused command rebuilt the Release test artifact after its assertion changed. The
combined gate then used that exact artifact with `--no-build`.
