# FreeW external subdocument anchor retention

## Problem

Word master documents place `w:subDoc` anchors in paragraph content and resolve each anchor through an
external `subDocument` relationship. FreeW previously ignored the anchor and relationship, so opening and
saving a master document permanently detached its linked chapter/subdocument locations.

## Implementation

- `SubDocumentReference` is a textless ordered run mark carrying the exact external target.
- The reader accepts only relationships using the required `subDocument` type with `TargetMode="External"`.
- Direct anchors and anchors nested in inline custom XML, content controls, hyperlinks, bidirectional
  containers, and tracked-change wrappers follow the existing ordered paragraph recursion.
- Table-cell paragraphs receive the same relationship map as body paragraphs.
- The writer assigns deterministic `rIdSubDocumentN` identifiers, emits `w:subDoc` in run order, and writes
  the exact target through an external `subDocument` relationship.
- Strict Open XML save/load maps the relationship type between its strict and transitional URI families.
- Comment, combine, compare, insert-from-file, mail-merge, revision-edit, and table-header clone paths retain
  the anchor mark.

## Evidence

The package contract imports two anchors in one paragraph: one inside inline custom XML and one inside a
content control. Their targets use a relative path and a `file:` URI. After editing neighboring text and two
read/write cycles it asserts:

- the anchors remain in exact text/subdocument/text/content-control/text order;
- both exact targets remain attached to the corresponding emitted IDs;
- both relationships retain the required type and `TargetMode="External"`; and
- the content-control owner remains attached to its anchor.

An independent model contract verifies Insert Text from File clones the subdocument run independently.

Verification:

- focused transitional + Strict Open XML subdocument contracts: 2/2;
- full `FreeW.Core.IO.Tests`: 1191/1191;
- focused insert-from-file model contract: 1/1;
- full `FreeW.Core.Model.Tests`: 1553/1553;
- Core IO test consumer Release build: 0 warnings/errors.

This slice preserves and re-emits external master-document anchors. Loading and rendering the external
document's live contents inside FreeW remains a separate master-document feature.
