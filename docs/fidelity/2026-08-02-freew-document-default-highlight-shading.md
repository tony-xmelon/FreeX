# FreeW document-default highlight and shading retention

## Scope

Both FreeW renderers already cascade `RunFormatting.HighlightColorHex` and patterned
`CharacterShadingHex` from `TextDocument.DefaultRun`. The DOCX reader parsed those
properties on ordinary runs, but the `docDefaults` merge and writer omitted them.

This slice retains:

- named `w:highlight` defaults, including FreeW's existing solid `w:shd` fallback
- patterned `w:shd` defaults with their fill and `ShadingPattern`

The writer keeps `w:highlight` before underline and `w:shd` after underline, matching
the existing CT_RPr ordering used for ordinary runs. Character-border defaults remain a
separate serialization contract and were not changed.

## Verification

- Focused `DocDefaultsRoundTripTests`: 9/9 passed.
- Combined document-default, highlight, character shading, typography, and broad DOCX
  round-trip gate: 297/297 passed.
- Tests inspect raw `styles.xml` ordering/values and reopen the saved model.
- `git diff --check`: clean.

The focused command built the Release artifact. The adjacent gate used that exact
artifact with `--no-build`.
