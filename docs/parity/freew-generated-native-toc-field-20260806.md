# FreeW generated native TOC field - 2026-08-06

## Scope

Make a FreeW-generated table of contents a real Word-updatable `TOC` field while retaining FreeW's
existing cached scope:

- `Title` maps to TOC level 1.
- Heading 1 maps to level 1.
- Heading 2 maps to level 2.
- Heading 3-9 map to level 3.
- The visible `Contents` / `TOCHeading` paragraph remains outside the field.
- A document with no outline entries retains the existing heading-only behavior.

## Word 16 calibration

The first COM candidate used `TOC \o "1-9" \h \z \u`. Word included Heading 1-9 but excluded
`Title`, so that code did not match FreeW's cached result.

A style-map field matched the intended result in a Word-authored source:

` TOC \h \z \t "Title,1,Heading 1,1,Heading 2,2,Heading 3,3,Heading 4,3,Heading 5,3,Heading 6,3,Heading 7,3,Heading 8,3,Heading 9,3" `

The first exact FreeW-package gate then exposed missing source style definitions: Heading 4 and 6
were present as paragraph style ids but absent from `styles.xml`, so Word dropped both rows on update.
FreeW now seeds a canonical Heading 4-9 definition when that level is actually used and missing.
Imported definitions remain authoritative, and field construction substitutes each document's actual
style display name because Word's `\t` switch resolves names rather than ids.

## Exact package gate

FreeW-authored source:

- path during the bounded probe: `C:\fwtoc2\freew-generated-2.docx`
- SHA-256: `DF8DD0209B372FDAA2590E175E4909EAA91E6B7D19A5151A3D6F1CC1221E233C`
- source sequence: Title, Heading 1, Heading 2, Heading 3, Heading 4, Heading 6
- `TablesOfContents.Count`: 1

Word result before update:

`Doc Title\t1 | Chapter One\t1 | Section A\t1 | Detail\t1 | Deep Four\t1 | Deep Six\t1`

Word result after update was the same six rows in the same order. Word added only its normal trailing
field paragraph mark.

## Host retention

WPF's `ParagraphTag` side-band previously retained style, bookmarks, pagination, list, border, and
section metadata but omitted the new spanning-field triplet. A render/edit/commit therefore stripped
the native TOC owner. The same side-band now retains `SpanningFieldStart`, `SpanningFieldOwner`, and
`EndsSpanningField`, covering every native multi-paragraph field rather than special-casing TOC.

Avalonia already retained the model objects through its update path.

## Verification

- `TableOfContentsTests`: 18/18
- generated/imported native TOC package contracts: 2/2
- WPF native-owned refresh plus commit: 1/1
- Avalonia native-owned refresh: 1/1
- Word 16 exact FreeW package update: 6/6 cached rows retained

## Process rule

A syntactically valid field is not functional parity until Word updates the exact package emitted by
the product. Gate field instructions against the product's serialized style catalog, preserve actual
style display names, and verify the editor's render/commit side-band retains field ownership before
accepting the slice.
