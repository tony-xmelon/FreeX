# FreeW hide-grammatical-errors package parity

## Scope

FreeW now models WordprocessingML `w:settings/w:hideGrammaticalErrors` as
`TextDocument.HideGrammaticalErrors`.

## Package contract

- Missing `w:hideGrammaticalErrors` means false.
- An empty element or `w:val="1"`, `true`, or `on` reads as true.
- `w:val="0"`, `false`, or `off` reads as false.
- A true model value writes the canonical empty `w:hideGrammaticalErrors` element.
- A false model value is omitted, including when overlaying a preserved settings part.
- The overlay is inserted between `w:hideSpellingErrors` and `w:activeWritingStyle` in CT_Settings order.

This canonicalization preserves Word's boolean semantics: explicit off and omission are equivalent, so no
separate presence state is required.
