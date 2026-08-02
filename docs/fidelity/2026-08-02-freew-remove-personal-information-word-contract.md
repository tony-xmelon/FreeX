# FreeW remove-personal-information Word contract

## Word evidence

- Source fixture: `freew-fidelity-corpus/files/tracked-changes-with-comments.docx`.
- Controlled input: short-path DOCX with core creator `Core Alice`, last modifier `Core Bob`, comment authors `Editor` / `Lead Author`, initials `ED` / `LA`, and revision author `Lead Author`.
- Input SHA-256: `8A732B3662E798A1A64B5D9B71350D65CB0007445ACD2211FDF65050C3B8D009`.
- Word automation: open the exact input, set `Document.RemovePersonalInformation = true`, then `SaveAs2(..., wdFormatDocumentDefault)`.
- Word output SHA-256: `8673FDEC10D55E20199477D6387136274BA0CBE4C0B2154C7BBCC404C220A1A8`.

Word's saved package established these rules:

- Remove `dc:creator` and clear `cp:lastModifiedBy`.
- Rewrite WordprocessingML `w:author` values to `Author` for comments and tracked revisions.
- Rewrite comment `w:initials` values to `A`.
- Retain `w:removePersonalInformation` in `word/settings.xml`.

## FreeW implementation

`DocxWriter` applies the same policy at generated XML serialization boundaries for core properties, the main document, headers/footers, footnotes/endnotes, and comments. It does not mutate the in-memory `TextDocument`, and the disabled-setting control preserves all authored metadata.

Verification on current source:

- Focused `RemovePersonalInformationRoundTripTests`: 12/12.
- Full `FreeW.Core.IO.Tests`: 1262/1262.

Process rule: recover privacy-setting semantics from a controlled Word save with known author values; do not infer metadata scope from the setting name alone.
