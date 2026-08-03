# FreeW custom XML list-binding refresh

Date: 2026-08-04

## Result

FreeW now refreshes XML-mapped drop-down and combo-box content controls when a DOCX opens or when a caller explicitly refreshes the preserved custom XML data store.

Word stores a list entry's programmatic `Value` in mapped custom XML while displaying that entry's authored text. The resolver now applies the same two-layer behavior:

- a mapped value that matches `w:listItem/@w:value` displays the corresponding `w:displayText`;
- an unmatched combo-box value remains visible as custom free text;
- unresolved bindings still preserve the serialized display;
- rich-text, picture, date, and checkbox binding semantics remain outside this narrow textual-list path.

The existing `RefreshBoundPlainTextControls` API remains source-compatible and delegates to the expanded `RefreshBoundTextControls` pass. `DocxReader` invokes the expanded entry point after the complete preserved custom XML graph is available.

Microsoft's Word object-model documentation confirms that a list entry's `Value` is the value sent to custom XML while its text is the user-visible label:

- https://learn.microsoft.com/en-us/dotnet/api/microsoft.office.interop.word.contentcontrollistentry.value
- https://learn.microsoft.com/en-us/office/vba/api/word.xmlmapping.setmapping

## Evidence

`DataBoundContentControlRoundTripTests` covers:

- mapped drop-down stored value to display text;
- mapped combo-box stored value to display text;
- unmatched combo-box free text;
- explicit refresh after replacing the custom XML item bytes through the legacy API;
- all prior plain-text, namespace, attribute, block-control, and package-retention cases.

Focused result: 10/10 passed.

## Process rule

For bound list controls, keep source value and display label separate. Resolve the custom XML value first, then translate only exact authored list values to display text; do not flatten rich-text or non-text control bindings through the plain-text path.
