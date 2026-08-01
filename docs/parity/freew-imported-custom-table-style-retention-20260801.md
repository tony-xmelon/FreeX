# FreeW imported custom table style retention

## Problem

FreeW retained only table-style IDs found in its built-in gallery. A table using a custom Word style lost
its `w:tblStyle` reference on import, while the corresponding `styles.xml` definition was reconstructed
without unmodelled metadata and conditional `w:tblStylePr` bands. An unrelated save therefore detached
the table from its authored first-row, banding, border, and other conditional formatting.

## Implementation

- Imported tables retain their exact authored style ID, including non-catalog IDs.
- Imported table `DocumentStyle` entries preserve the exact `w:style w:type="table"` element.
- The writer re-emits the preserved definition and avoids generating a duplicate catalog definition.
- FreeW-authored catalog styles continue through the existing generated style path.
- Insert-from-file style conflict remapping updates the preserved style's own `w:styleId` and its
  `basedOn`, `next`, and `link` references alongside the model/table references.

## Evidence

The package contract imports a custom style carrying `customStyle`, `uiPriority`, `qFormat`, table borders,
and separate `firstRow` and `band1Horz` fills. After an unrelated body edit and two read/write cycles it
asserts:

- the table still references `CustomBlueGrid`;
- exactly one matching style definition exists;
- all custom metadata and both conditional bands remain present with their authored values; and
- the outside body edit remains intact.

Verification:

- focused imported table-style package test: 1/1;
- full `FreeW.Core.IO.Tests`: 1189/1189;
- focused conflicting-style merge test: 1/1;
- full `FreeW.Core.Model.Tests`: 1552/1552.

This is package and functional parity and does not require a Word COM visual baseline.
