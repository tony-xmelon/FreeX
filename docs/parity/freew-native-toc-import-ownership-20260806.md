# FreeW native TOC import ownership - 2026-08-06

## Scope

Preserve a Word-authored multi-paragraph `TOC` field as semantic generated content without
claiming the source headings that follow it. Retain nested `PAGEREF` fields in the cached result so
save/reopen does not flatten Word's field structure.

This slice does not author a native field for FreeW-generated TOCs. FreeW currently includes
`Title` and Heading 1-9 in its cached result, while Word's measured default field was
` TOC \o "1-3" `. Native authoring needs a separate instruction/scope calibration so a Word update
cannot silently discard cached entries.

## Word 16 evidence

The source was created through Word COM at the short path `C:\fwtoc1\n.docx`:

- SHA-256: `F73680D4DB25D8936E6D3BDC1A3363CA097A57057A95CC1285C0FFAA92928C5F`
- file length: 13,776 bytes
- headings: Heading 1 `Chapter One`, Heading 2 `Section A`
- `TablesOfContents.Count`: 1
- `Fields.Count`: 3 (outer `TOC` and two nested `PAGEREF` fields)
- outer instruction: ` TOC \o "1-3" `
- cached range: `Chapter One\t1`, `Section A\t1`

The package boundary is significant:

1. TOC1 starts the outer field and contains the first nested `PAGEREF`.
2. TOC2 contains the second nested `PAGEREF`.
3. The outer field end marker is at the start of the following Heading 1 paragraph, before
   `Chapter One`.

Treating paragraph 3 as field-owned causes a refresh to delete the actual source heading.

## Accepted behavior

- Complete nested fields in an outer field's cached-result paragraphs remain intact for the normal
  run-level complex-field reader.
- When an outer field end precedes ordinary content in the next paragraph, semantic ownership closes
  on the preceding result paragraph. The following content remains outside the generated region.
- TOC recognition accepts native spanning-field ownership and a same-paragraph native `TOC` run,
  while retaining TOC styles as the compatibility path.
- The writer canonicalizes the imported boundary by emitting the outer end after the final cached
  result paragraph. It does not emit a field marker into the source heading.

## Verification

- `ComplexFieldRoundTripTests`: 21/21
- `TableOfContentsTests`: 15/15
- WPF native-owned TOC refresh regression: 1/1
- Avalonia native-owned TOC refresh regression: 1/1

The package contract asserts two nested `PAGEREF` fields survive, the first two paragraphs share the
outer `TOC` owner, exactly the second result paragraph closes it, and both source headings remain
unowned after read and save.

## Process rule

For Word-generated multi-paragraph fields, distinguish physical marker placement from semantic
content ownership. A closing marker at the start of ordinary source content belongs to the preceding
cached-result region. Preserve nested result fields independently, and gate refresh against the
source paragraph that immediately follows the field.
