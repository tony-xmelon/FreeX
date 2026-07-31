# FreeW Print Endnote Overflow Physical Page

## Scope

`HeaderFooterPaginator` previously overlaid all endnotes in the final page's
bottom margin. A full final body page therefore clipped or omitted endnote text,
and Print Preview/printing retained the body-only page count.

The print paginator now measures the final body raster against the shared
endnote-region height. Fitting endnotes remain on the final body page. Overflow
adds one physical page that inherits page size, margins, page border, watermark,
header, and footer ownership before painting the endnote region near the top
margin.

## Functional Evidence

- Exact imported fixture: `freew-fidelity-corpus/files/review/endnotes.docx`
- Microsoft Word page count: `3`
- FreeW Print Preview/print paginator before: `2`
- FreeW Print Preview/print paginator after: `3`
- Short fitting control: body page count unchanged; endnotes remain on the final body page

## Verification

- Focused overflow and fitting contracts: 2/2
- `HeaderFooterPaginatorTests`: 8/8
- Release WPF host build: 0 warnings, 0 errors
