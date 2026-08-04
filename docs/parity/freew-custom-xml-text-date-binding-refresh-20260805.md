# FreeW custom XML text date-binding refresh

## Scope

Word's `w:storeMappedDataAs` controls how a bound date picker exchanges data
with custom XML. `text` means the mapped value is the displayed value without
date translation, and omission defaults to `text`. FreeW previously refreshed
only `date` and `dateTime`, leaving text-backed date controls stale.

The resolver now copies the mapped XML text into the complete date-control run
range when storage is `text` or omitted. It deliberately preserves `w:date`'s
existing `fullDate`, format, locale, calendar, and storage metadata because an
arbitrary display string does not establish a new semantic date.

Microsoft's Word enumeration documents `wdContentControlDateStorageText` as text
storage/retrieval, while the Open XML SDK remarks specify that omitted
`storeMappedDataAs/@w:val` defaults to `text`:

- https://learn.microsoft.com/en-us/office/vba/api/word.wdcontentcontroldatestorageformat
- https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.wordprocessing.sdtdatemappingtype.val

## Verification

Exact package tests cover explicit `text` and omitted storage with a non-date
display value across two runs. They assert the shared control owner, unchanged
`fullDate`, canonical saved XML, reopened display/model state, and Microsoft 365
schema validity. Invalid `date` and `dateTime` inputs remain unchanged controls.

## Process rule

Apply the source format's translation contract at the binding boundary. A text
mapping owns display text, not date inference; preserve semantic date metadata
unless the source supplies a typed date value.
