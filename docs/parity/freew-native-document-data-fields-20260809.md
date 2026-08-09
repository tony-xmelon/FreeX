# Native Document Data Field Updates

## Scope

FreeW now recomputes imported `DOCPROPERTY` and `DOCVARIABLE` complex fields when
the user updates fields with F9. Both the WPF and Avalonia editors use the shared
field engine, so their cached field results now follow the current document and
package state instead of remaining stale.

`DOCPROPERTY` currently resolves the modeled Title, Subject, Author, Keywords,
Comments, LastSavedBy/LastAuthor, Category, ContentStatus, Language, and Version
properties, plus arbitrary preserved custom properties. `DOCVARIABLE` resolves
the preserved `word/settings.xml` `w:docVars` payload. Names are matched without
case sensitivity and quoted field arguments are supported.

The text general-format switches `Upper`, `Lower`, `FirstCap`, and `Caps` are
applied to resolved values. Unknown names, missing values, malformed preserved
XML, and unsupported property families keep the authored cached result rather
than erasing visible document content.

## Source Ownership

Modeled core properties remain authoritative for supported built-in names.
Custom document properties are read from the preserved custom-properties XML,
and document variables are read from the preserved settings XML. The field
engine does not infer either payload from visible cached text.

This follows Word's field and automation contracts:

- [Word field code reference](https://support.microsoft.com/en-us/word/list-of-field-codes-in-word)
- [Word Document.Variables](https://learn.microsoft.com/en-us/office/vba/api/word.document.variables)
- [Word Variable object](https://learn.microsoft.com/en-us/office/vba/api/word.variable)
- [Word built-in document properties](https://learn.microsoft.com/en-us/office/vba/api/word.wdbuiltinproperty)

## Verification

- `ComplexFieldEngineTests`: 65/65
- `ComplexFieldUpdateRoundTripTests`: 3/3
- WPF `ComplexFieldEditorTests`: 13/13
- Avalonia `FieldDisplayParityTests`: 5/5

The package test saves and reopens a document containing built-in, custom, and
document-variable fields, then verifies both the serialized field instructions
and recomputed results.
