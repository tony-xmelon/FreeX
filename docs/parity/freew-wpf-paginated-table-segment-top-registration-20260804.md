# FreeW WPF paginated table segment top registration

## Scope

The three-page `table-page-composition-stress.docx` already had the correct functional
partition: source rows `[0,1,2]`, `[3,4,5,6]`, and `[7,8]`, with the authored header
repeated on pages 2 and 3. Raw table bands showed every physical segment about one pixel
above Word.

The fixture carries `w:tblCellSpacing=36` twips (`1.8 pt`). Explicit WPF pagination
segments now add half that serialized gutter to the owning `Section.Padding.Top`. The
guard is limited to multi-page planned segments with positive authored cell spacing;
row heights, table margins, horizontal geometry, and the shared pagination planner are
unchanged.

A first probe applied the same value to `Table.Margin.Top`. Fresh renders were
byte-identical on all three pages, proving WPF's effective section layout absorbed that
property. It was reverted before moving the correction to the section owner.

## Matched evidence

Reference: cached Word 16 PNGs at 816x528. Scores are mean absolute RGB channel delta.

| Page | Whole page | Table ROI |
| --- | ---: | ---: |
| 1 | `6.9757% -> 6.3929%` | `12.7718% -> 11.2232%` |
| 2 | `9.2192% -> 8.0869%` | `12.8729% -> 11.1210%` |
| 3 | `7.4221% -> 6.4651%` | `14.5601% -> 12.1589%` |

Every measured header/body-row ROI improved. The weakest change was the final page-2
row, `11.5684% -> 11.5435%`; the strongest was page-2 row 1,
`12.9594% -> 9.7480%`.

Controls were byte-identical against the same freshly built current-main baseline:

- `table-pagination-repeat-header` pages 1 and 2;
- `table-layout-complex` page 1.

The target continued to emit exactly three pages. Focused physical-segment contracts
passed 2/2; Host and FidelityRender Release builds completed with zero warnings/errors.
