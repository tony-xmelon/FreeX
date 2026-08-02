# FreeW `w:doNotDisplayPageBoundaries` parity

## Gap

FreeW preserved an imported `w:doNotDisplayPageBoundaries` element only as unknown settings XML. The setting
was not exposed by `TextDocument`, could not be authored deliberately, and could not be changed while retaining
Word's canonical package form.

## Contract

- `TextDocument.DoNotDisplayPageBoundaries` defaults to `false`.
- The reader accepts the empty element and the `1`, `true`, and `on` forms as enabled.
- The reader accepts `0`, `false`, and `off` as disabled.
- The writer emits the canonical empty `<w:doNotDisplayPageBoundaries/>` element only when enabled.
- The default does not create `word/settings.xml` in a newly authored document.
- A preserved settings part is overlaid at the element's `CT_Settings` schema position without disturbing
  neighboring unmodelled settings.
- Saving, reopening, and saving again produces stable settings XML and the same model value.

## Verification

- `DoNotDisplayPageBoundariesModelTests`: `1/1` passed.
- `DoNotDisplayPageBoundariesRoundTripTests`: `10/10` passed.
- Neighboring document-settings round-trip lane: `81/81` passed.
- `PreservedPartsRoundTripTests`: `17/17` passed.
