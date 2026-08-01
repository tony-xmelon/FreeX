# FreeW data-bound content controls

Date: 2026-08-01

## Result

FreeW now retains the Word metadata that keeps inline and block content controls connected to custom XML after the displayed text is edited:

- `w:id`;
- `w:dataBinding` store item ID, XPath, and prefix mappings;
- `w:placeholder` and `w:showingPlcHdr`;
- `w:temporary`;
- Word 2013 `w15:appearance` and `w15:color`.

The existing modeled alias, lock, tag, control kind, checkbox/date/list properties remain authoritative. The writer reconstructs those modeled properties once and adds the retained Word metadata, avoiding duplicate `w:sdtPr` children. Documents using modern appearance/color metadata receive the required `w15` namespace and markup-compatibility declaration; ordinary documents remain unchanged.

## Evidence

- Inline package test edits the displayed text, verifies every retained property, reopens the file, and requires byte-stable `w:sdtPr` on a second save.
- Block-level package test verifies binding and identity survive an edited paragraph.
- A complete custom-XML package fixture requires `customXml/item1.xml`, its item-properties part, relationships, bytes, binding, and edited display text to survive two writes.

## Residuals

- FreeW preserves and exposes the binding but does not yet evaluate arbitrary XPath expressions to refresh displayed text automatically when custom XML data changes.
- Repeating-section and mapped rich-media content controls remain separate feature slices.
