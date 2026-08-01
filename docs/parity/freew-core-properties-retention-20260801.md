# FreeW Word core-properties retention

Date: 2026-08-01

## Gap

FreeW modeled twelve common `docProps/core.xml` properties and rebuilt that part on every save.
Word-authored properties outside that model, including `cp:lastPrinted`, `cp:revision`,
`dc:identifier`, and `cp:contentType`, were therefore deleted even when the user changed only an
unrelated modeled field.

## Slice

- Publish the exact shared set of core-property element names represented by
  `CoreDocumentProperties`.
- Capture the original core-properties root only when it contains an unmodeled child. Ordinary
  FreeW-authored packages therefore retain the existing empty-preservation invariant.
- Rebuild modeled properties from the current document model, then merge each distinct unmodeled
  source property back through the shared OPC preservation helper.
- Deep-copy the original core snapshot through safe document clone/merge paths.

## Evidence

The package fixture injects four Word core properties outside FreeW's model, reopens the DOCX,
changes its modeled title, and saves twice. Both saved packages must contain the edited title,
exactly one copy of every unmodeled property with its exact source value, and byte-equivalent XML
elements between the first and second saves.

The focused preservation-owner gate also covers no-spurious-preserved-state contracts, so a normal
package without unsupported core children remains unchanged in that respect.

## Verification

- Adversarial edited/second-save package contract: 1/1.
- Core-properties and preserved-package owner tests: 19/19.
- Complete `FreeW.Core.IO.Tests`: 1180/1180.

## Residuals

- FreeW still does not expose these retained values in the document-properties UI; this slice prevents
  package data loss while modeled fields remain editable.
- Root-level lexical details such as namespace prefix spelling are not treated as user data. The
  retained child elements preserve their names, attributes, and values semantically.
