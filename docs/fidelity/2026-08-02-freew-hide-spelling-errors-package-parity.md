# FreeW hide-spelling-errors package parity

## Scope

FreeW now models WordprocessingML `w:settings/w:hideSpellingErrors` as
`TextDocument.HideSpellingErrors`.

## Package contract

- Missing `w:hideSpellingErrors` means false.
- An empty element or `w:val="1"`, `true`, or `on` reads as true.
- `w:val="0"`, `false`, or `off` reads as false.
- A true model value writes the canonical empty `w:hideSpellingErrors` element.
- A false model value is omitted, including when overlaying a preserved settings part.
- The overlay is inserted between `w:gutterAtTop` and `w:hideGrammaticalErrors` in CT_Settings order.

This canonicalization preserves Word's boolean semantics: explicit off and omission are equivalent, so no
separate presence state is required.
