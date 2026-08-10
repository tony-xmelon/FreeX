# FreeW Table of Figures: Table-Cell Captions

## Word contract

Word's Table of Figures is a native `TOC \\c "Label"` field over caption `SEQ` fields in the main
document story. Captions remain part of that story when they are inside table cells, including nested
tables, and they contribute to the same label sequence.

## Previous gap

`TableOfFigures.Build` and `Captions.NextCaptionNumber` inspected only top-level body paragraphs.
`ComplexFieldEngine` counted direct table-cell `SEQ` fields but skipped nested tables. This could omit
valid captions from generated entries, allocate a duplicate next caption number, and recompute later
caption fields with the wrong ordinal.

## Implementation

- Added a shared main-story paragraph traversal for top-level paragraphs plus recursively nested table
  cells.
- Kept traversal order aligned with the writer's canonical cell order: nested tables first, then the
  cell's required trailing paragraphs.
- Table-of-figures entries carry a recursive table paragraph address alongside the owning top-level
  table block. Direct and nested captions use the shared pagination plan to resolve their owning outer
  row's physical page. A nested table that itself crosses a page remains limited to that outer-row page
  because nested tables do not yet have an independent live-layout owner in either renderer.
- Reused the same traversal for caption numbering and `SEQ` recomputation.
- WPF now retains authored row height, height rule, and row-break policy across its view-to-model commit,
  so refreshing a field cannot erase the inputs that determine a paginated table row's page.

Caption cross-reference bookmark insertion inside table cells remains a separate ownership/addressing
slice; this change does not claim that path.

## Verification

- Table of Figures includes top-level, nested-table, direct-table, and following captions in serialized
  story order, with one shared native field owner.
- Recursive table addresses are supplied to the page resolver; direct captions in different paginated
  rows receive distinct section-aware page labels in both WPF and Avalonia.
- Next-caption numbering includes nested-table captions.
- `SEQ` recomputation counts nested and direct table captions in the same serialized order.
- WPF paginated-table row metadata survives an editor commit, including repeated-header segments.
