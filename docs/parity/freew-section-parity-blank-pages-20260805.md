# FreeW Even/Odd Section Physical Page Parity

## Scope

Word `EvenPage` and `OddPage` section breaks can require an automatically inserted blank physical
page. FreeW previously treated both as an ordinary next-page boundary, so print preview, PDF, and
XPS omitted the parity page and subsequent physical page counts were wrong.

## Implementation

- `HeaderFooterPagePlanner.BuildPhysicalPagePlan` expands body pages into physical page slots.
- A slot with no body-page index is an explicit parity blank; it does not add a dummy model block.
- The print-only section-aware paginator materializes the blank as a read-only, model-free page.
- Body blocks, footnotes, endnotes, and editable header/footer slots remain owned by real pages.
- Block page assignments are remapped to physical slots before PAGE/NUMPAGES resolution, while an
  explicit section page-number restart remains authoritative.
- Paged editing keeps its existing body-page sequence; physical expansion is enabled only for
  print, preview, PDF, and XPS pagination.

## Verified Sequences

For a section transition after physical page 1:

| Break | Physical sequence | PAGE on next body | NUMPAGES |
| --- | --- | ---: | ---: |
| `EvenPage` | body, body | 2 | 2 |
| `OddPage` | body, blank, body | 3 | 3 |

Planner coverage also verifies transitions after two body pages: `EvenPage` inserts page 3 so the
new section starts on page 4, while `OddPage` starts directly on page 3.

## Gates

- Shared header/footer and page-number planner tests: 21/21.
- WPF PrintLayout, header/footer, note-region, and harness-schema tests: 46/46.
- Consuming `FreeW.App.Host` Release build: 0 warnings, 0 errors.
- Every planned physical page is requested from the final `DocumentPaginator`; no slot resolves to
  `DocumentPage.Missing`.

No Word COM raster baseline is required for this slice: it changes functional pagination and page
ownership, with exact physical sequences asserted through the same paginator used by print/PDF/XPS.
