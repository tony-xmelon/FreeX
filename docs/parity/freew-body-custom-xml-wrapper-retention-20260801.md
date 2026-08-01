# FreeW body custom XML wrapper retention

## Problem

WordprocessingML permits `w:customXml` at document-body level around visible blocks. FreeW previously
ignored that wrapper and all of its children, so opening and saving an otherwise valid document deleted
the enclosed paragraphs and tables.

Inline `w:customXml` inside a paragraph remains intentionally flattened into ordinary formatted runs.
This slice changes only body-level wrapper ownership.

## Implementation

- `BlockCustomXml` retains `w:element`, `w:uri`, and the optional `w:customXmlPr` payload.
- Consecutive imported blocks from one wrapper share the same metadata instance.
- The reader materializes wrapped paragraphs, tables, content controls, and altChunk blocks in authored order.
- The writer regroups shared blocks into one outer `w:customXml`, preserving nested body content-control groups.
- Document combine, compare, merge, and mail-merge cloning paths retain wrapper ownership.

## Evidence

The package contract covers a body wrapper containing a paragraph followed by a table, plus an ordinary
paragraph edited outside the wrapper. Two read/write cycles preserve:

- all three visible blocks and their order;
- the shared wrapper identity for the enclosed paragraph and table;
- exact `w:element` and `w:uri` values;
- the `w:customXmlPr/w:attr` payload; and
- the unrelated outside edit.

Verification:

- focused `CustomXmlContentRoundTripTests`: 2/2;
- full `FreeW.Core.IO.Tests`: 1188/1188;
- full `FreeW.Core.Model.Tests`: 1552/1552.

This is package and functional parity and does not require a Word COM visual baseline.
