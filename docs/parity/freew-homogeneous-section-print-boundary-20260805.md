# FreeW homogeneous section print boundary

Date: 2026-08-05

## Scope

Word starts a same-geometry `NextPage` section on a new page. FreeW retained the section in the
document model, but Print, Print Preview, PDF, and XPS cloned the WPF document through XAML. That
clone removed the private paragraph tag carrying the section marker. Because homogeneous sections
do not require the section-aware geometry/header-footer paginator, the real output path lost the
boundary.

## Change

- `PrintLayout.BuildPaginatedDocument` now restores page-type section boundaries immediately after
  cloning, before footnote composition and paginator decoration.
- `PaginationEngine.ApplySectionBreakFlags` maps top-level model paragraphs to rendered body
  paragraphs through coalesced WPF lists instead of assuming one top-level WPF block per model
  block.
- The mapper declines uncertain paragraph sequences rather than moving a section boundary to the
  wrong block.

## Evidence

- Homogeneous `NextPage`: the second rendered paragraph owns `BreakPageBefore` and the print
  paginator produces exactly two pages.
- Homogeneous `Continuous`: no synthetic boundary and exactly one page.
- Two coalesced list items before the section marker: the correct post-section paragraph owns the
  boundary and the paginator produces exactly two pages.
- Focused compiling test lane: 15/15.
- Print/pagination/preview no-build lane: 48/48.

No Word COM export is required for this functional ownership slice; its contract is the authored
section kind and the resulting paginator page sequence.

## Remaining boundary

`EvenPage` and `OddPage` currently gain a page boundary but do not yet synthesize Word's parity blank
page. A section whose first block is a table also needs a separate block-owner implementation.
