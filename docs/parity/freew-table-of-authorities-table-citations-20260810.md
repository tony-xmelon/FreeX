# FreeW Table of Authorities: Table-Cell Citations

## Word contract

Word's Table of Authorities collects hidden `TA` fields from the main document story. A mark remains in
that story when it is inside a direct or nested table cell, and its generated entry uses the physical page
containing the owning table row.

## Previous gap

`TableOfAuthorities.CollectCitations` and the occurrence builder inspected only top-level paragraphs.
Valid marks inside tables were omitted after DOCX reopen and during Insert, Refresh, and Update Fields.
The WPF and Avalonia page resolvers also accepted only a top-level block/run location, so they could not
assign different pages to marks in different rows of a paginated table.

## Implementation

- Reused the canonical main-story paragraph traversal for top-level, direct-cell, and recursively nested
  table paragraphs.
- Added an address-aware TOA resolver API while retaining the existing public block/run resolver overloads
  for source compatibility.
- Routed WPF and Avalonia Insert, Refresh, and Update Fields through the address-aware region planner.
- Resolved table marks from the owning table's first physical page plus the shared outer-row pagination
  offset. Page labels use the document's section restart, numbering format, and chapter-prefix plan.
- If live host pagination is unavailable, the shared table plan supplies a table-only fallback only when
  the table's first page is independently known from placement, an explicit boundary, or block-zero
  ownership. It does not assume page 1 for an unplaced table after flowing content.
- Kept explicit page-break and section-break fallback advancement limited to top-level paragraphs; table
  cell paragraphs do not create synthetic page boundaries.

Nested tables still inherit their owning outer row's page because neither renderer independently
paginates a nested table across pages.

## Verification

- Model generation collects top-level, nested-cell, direct-cell, and following marks in serialized story
  order and forwards exact recursive addresses.
- DOCX round-trip retains direct and nested table marks and rebuilds both TOA entries after reopen.
- WPF and Avalonia refresh an existing TOA from marks in early and later table rows with distinct page
  references, exact `IV, V` formatted labels, and removal of the stale prior entry.
- Legacy resolver tests remain green alongside the new address-aware planner contract.
