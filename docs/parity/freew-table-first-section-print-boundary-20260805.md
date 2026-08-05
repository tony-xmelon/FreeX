# FreeW table-first section print boundary

Date: 2026-08-05

## Scope

The shared Print/Preview clone now restores page-type section boundaries for paragraph and list
starts. A homogeneous `NextPage` section whose first block was a table still stayed on the preceding
page because the existing owner mapper addressed only rendered paragraphs.

## Change

`PaginationEngine.ApplySectionBreakFlags` now also maps model tables to their first rendered WPF
block. The mapping uses the same shared table layout/pagination plan as `DocumentView`, so a
multi-page table consumes its actual number of top-level section segments while an inline or
floating single-page table consumes one. A section boundary is applied to only the first segment.
WPF's paginator ignores `Table.BreakPageBefore`, so an unsegmented inline table receives a
display-only zero-margin `Section` wrapper that owns the effective boundary.

The mapping is accepted only when its complete top-level block count matches the cloned flow. This
keeps outline-collapsed or unsupported structures from receiving a guessed boundary.

## Evidence

The focused fixture includes a coalesced two-item list before the section marker:

- homogeneous `NextPage` followed by a table: the table owns `BreakPageBefore` and Print produces
  exactly two pages;
- identical `Continuous` control: no table boundary and exactly one page.

## Remaining boundary

`EvenPage` and `OddPage` still require a physical-page planner that can insert a synthetic parity
blank without changing body, footnote, header/footer, or endnote ownership.
