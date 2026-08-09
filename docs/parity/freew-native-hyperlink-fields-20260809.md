# Native Hyperlink Field Activation

## Scope

FreeW now activates Word-authored `HYPERLINK` fields instead of rendering their
cached result as inert text. Both complex field sequences and `w:fldSimple`
forms project their navigable semantics onto the existing run hyperlink model:

- the field filename/address becomes an external target;
- `\l` becomes an internal bookmark when no filename is present;
- a filename plus `\l` becomes that address with the requested location;
- `\o` becomes the link ScreenTip.

WPF renders the imported field result as its native hyperlink inline, and
Avalonia carries the same target through its glyph/link hit-testing path.

## Package Ownership

The raw `ComplexField.Instruction` remains authoritative. Save emits the
original `w:fldChar` sequence or `w:fldSimple` instruction rather than replacing
it with a generated `w:hyperlink` wrapper or relationship. This preserves
unsupported Word switches such as `\m`, `\n`, and `\t` for later Word updates
while FreeW consumes only the semantics it models.

Microsoft documents the HYPERLINK filename/address and the `\l` location and
`\o` ScreenTip switches in [Field codes: Hyperlink field](https://support.microsoft.com/en-US/Word/field-codes-hyperlink-field).

## Verification

- Shared field parser: 5/5
- DOCX round-trip regression class: 229/229
- WPF document-view round-trip regression class: 62/62
- Avalonia hyperlink/bookmark regression class: 33/33

The package test covers an external URL, an internal bookmark, and a URL plus
location. It asserts the projected targets before and after save/reopen and
checks the serialized XML retains native field form without generated hyperlink
elements.
