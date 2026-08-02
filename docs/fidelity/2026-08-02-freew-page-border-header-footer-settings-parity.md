# FreeW page-border header/footer settings parity

## Scope

This package/model slice preserves Word's document-global `w:bordersDoNotSurroundHeader` and
`w:bordersDoNotSurroundFooter` settings. It intentionally makes no claim about page-border rendering geometry.

## Model contract

- `TextDocument.PageBordersDoNotSurroundHeader`
- `TextDocument.PageBordersDoNotSurroundFooter`
- Both properties default to `false` and remain independent.
- Compare, combine, plain mail merge, and rule-aware mail merge retain both values.

## DOCX contract

- The reader accepts the standard Word on/off forms: empty element, `1`, `true`, `on`, `0`, `false`, and `off`.
- A fresh save writes an enabled value as a canonical empty element.
- A disabled value is omitted.
- Preserved `settings.xml` parts replace or remove the modelled elements while retaining unmodelled neighbours.
- The writer places the elements in `CT_Settings` order between `w:alignBordersAndEdges` and `w:gutterAtTop`.
- Reopen and second-save tests prove stable model and XML results.

## Verification boundary

The settings are retained independently of whether the current document contains page borders. Word applies their
visual semantics only in conjunction with applicable page-border geometry; renderer integration is a separate slice.
