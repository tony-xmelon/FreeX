# FreeW Avalonia body SECTIONPAGES

Avalonia body paragraphs now resolve Word's `SECTIONPAGES` field from converged physical
pagination. The bounded display-only reflow includes authored page boundaries, even/odd parity
pages, continuous sections sharing a page, and inserted footnote-continuation pages. Field-code
display remains authoritative, and imported cached results are never mutated.

The convergence state is rebuilt for every document layout. Ordinary documents without a visible
body `SECTIONPAGES` field retain the existing single-pass or footnote two-pass route.

Verification:

- Targeted section-page contracts, including long-footnote continuation: 5 passed.
- `DocumentViewHeadlessTests`: 47 passed.
- `DocumentViewNoteRenderTests`: 18 passed.
- `DocumentViewHeaderFooterTests`: 12 passed.
- `dotnet build FreeW.slnx --configuration Release`: 0 warnings, 0 errors.

Table-cell complex fields use a separate cell wrapping path and remain an explicit follow-up.
