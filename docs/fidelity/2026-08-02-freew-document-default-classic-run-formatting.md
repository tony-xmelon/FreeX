# FreeW document-default classic run formatting retention

## Scope

Word stores character defaults in `word/styles.xml` under
`w:docDefaults/w:rPrDefault/w:rPr`. FreeW's ordinary run reader already understood the
classic properties below, but the document-default merge and writer retained only a
smaller subset. A read/save cycle could therefore silently discard formatting that
applied to every otherwise-unformatted run.

This slice retains these document-default properties:

- `w:caps` and `w:smallCaps`
- `w:strike`
- `w:u` as the currently supported single-underline model
- `w:vertAlign` for superscript/subscript
- `w:rtl`

The writer emits them in the canonical CT_RPr sequence alongside the already retained
font, bold/italic, double strike, proofing, hidden, color, size, and language properties.

## Verification

- Focused `DocDefaultsRoundTripTests`: 6/6 passed.
- Adjacent document-default, RTL, hidden/web-hidden, no-proof, and double-strike package
  suites: 51/51 passed.
- Broad `DocxRoundTripTests`: 224/224 passed.
- The focused contract inspects raw `styles.xml` child order and reopens the saved DOCX.
- `git diff --check`: clean.

Release artifacts were built by the focused test command; adjacent suites used the same
artifact with `--no-build`.
