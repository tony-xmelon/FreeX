# FreeW custom XML data-binding refresh

Date: 2026-08-02

## Result

FreeW now evaluates Word custom-XML bindings for inline and block plain-text content controls. After the DOCX reader captures the complete `customXml` package graph, the resolver:

- maps `w:dataBinding/@w:storeItemID` through the item's `customXmlProps` relationship and `ds:datastoreItem/@ds:itemID`;
- parses `w:prefixMappings` with the hardened XML reader;
- evaluates the authored XPath with its namespace context;
- refreshes the control's displayed text when a value resolves;
- leaves the serialized display unchanged when the item, relationship, namespace mapping, XPath, or result is missing or malformed.

`CustomXmlDataBindingResolver.RefreshBoundPlainTextControls` is public so a caller that updates a preserved custom XML item can explicitly refresh the bound controls without reopening the document. Reopening a saved document also refreshes automatically, matching Word's authoritative custom-data-store behavior.

## Evidence

- Namespaced element XPath refresh on open.
- Namespaced attribute XPath refresh on open.
- Explicit refresh after replacing the custom XML item bytes.
- Inline and block plain-text content-control paths.
- Missing XPath target preserves the serialized display text.
- Binding metadata and the complete custom XML package graph still survive two writes; reopening replaces edited cached display text with the authoritative XML value.

Verification:

- `DataBoundContentControlRoundTripTests`: 6/6.
- Complete `FreeW.Core.IO.Tests`: 1426/1426.

## Residuals

- Rich-text, picture, repeating-section, and other mapped control kinds retain their package metadata but are not rewritten by this plain-text refresh path.
- FreeW does not yet expose a custom XML editing surface; callers can replace preserved item bytes and invoke the resolver programmatically.
