# FreeW Avalonia table SECTION fields

Avalonia table-cell measurement and painting now share the body complex-field display resolver.
`SECTION` and `SECTIONPAGES` therefore use the table block's live section ordinal and converged
physical page count instead of imported cached text. Field-code display and other supported complex
field resolution also follow the same planner as ordinary body paragraphs.

A multi-page table in section 2 verifies both live values and unchanged model caches.

Verification:

- Exact multi-page table contract: 1 passed.
- `DocumentViewTableEditTests`: 17 passed.
- `DocumentViewHeadlessTests`: 47 passed.
- `dotnet build FreeW.slnx --configuration Release`: 0 warnings, 0 errors.
