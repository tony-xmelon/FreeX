# FreeW WPF paginated table cell-spacing surface (2026-08-01)

## Scope

WPF pagination segments deliberately set `Table.CellSpacing` to zero because the native WPF
property expands both axes and changes fixed-width Word pagination. For cells with explicit border
plans, the cell fill nevertheless remained on the outer `TableCell`, painting across the serialized
`w:tblCellSpacing` gutter. The fill now moves to the existing inner content-and-border host only on
that forced-zero pagination route. Text, borders, column widths, row measurement, and pagination are
unchanged. Ordinary flow tables and no-spacing pagination segments retain their previous ownership.

## Provenance

- Fixture SHA-256: `C34F1005A7542B2771E62CE47090745CF68C8B99B369AA9DF3910A2C08659EAB`
- Word 16: isolated visible COM `ExportAsFixedFormat`, short flat PDF staging path
- Word PNG SHA-256 pages 1-3:
  - `EAF96D09C35F9B0634E31559CCA513594D7B7806E23A93AD65957647743F7DF6`
  - `947C1FA4BDB2B17D9241B073A33F00EDC12F8713242D310CA3EDEE564142C3B9`
  - `661C254455080E5DCB11A30B93238A2E62C4EEFE88015BAEC4F8264262BF9C6E`
- Candidate PNG SHA-256 pages 1-3:
  - `712EED854F7B69D818F980B545D3C29D33A760898559C9A9E68956E4FDA9BCD7`
  - `FE002D0D8982A4EB8BB3478BB72FC9F7123D6A71941108D1CAC96D66E133EE73`
  - `C5CA392124299D9FAC2EBD5BF3073CC3ADF60BBB427989FB84F7956EEFDCFF95`

Word exported all three pages and quit its owned process cleanly. The complete one-document export
and raster operation finished in 7.6 seconds.

## Evidence

Mean absolute RGB channel delta against the matching Word PNG:

| Page / region | Before | After | Change |
|---|---:|---:|---:|
| Page 1 whole | 7.4041% | 7.2950% | -0.1091 pp |
| Page 1 table | 10.2680% | 10.0991% | -0.1689 pp |
| Page 2 whole | 10.0808% | 9.9019% | -0.1789 pp |
| Page 2 table | 14.4095% | 14.1326% | -0.2769 pp |
| Page 2 first seam | 13.0046% | 12.3465% | -0.6581 pp |
| Page 3 whole | 7.6441% | 7.5189% | -0.1252 pp |
| Page 3 table | 10.6421% | 10.4484% | -0.1937 pp |

Changed-pixel coverage also fell from 16.53% to 14.31% on page 1, 22.61% to 19.19% on page 2,
and 16.64% to 14.61% on page 3.

The ordinary positive-spacing `table-layout-complex` control and both pages of the no-spacing
`table-pagination-repeat-header` control are SHA-256 byte-stable. A broader ownership change was
rejected because it regressed the ordinary flow table from 3.1734% to 3.1945%.

## Rejected crisp-stroke probe

Disabling WPF edge antialiasing on the custom border overlay increased exact `#1F4E79` coverage on
page 2 from 8,564 to 22,474 pixels and reduced changed-pixel coverage, but worsened whole-page mean
delta from 10.0808% to 10.4954%. It was reverted. Word's border raster is not equivalent to globally
aliasing every custom edge.

## Verification

- Focused pagination/flow ownership contracts: 2/2
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh candidate render: 3/3 target pages and 3/3 control pages
- Word COM export: 3/3 target pages plus 3/3 control pages, clean owned-process exits

## Process rule

When a host suppresses native cell spacing for pagination, apply the serialized gap at the physical
surface owner rather than changing row or column measurement. Gate the exact forced-zero route,
the complete affected page sequence, an ordinary positive-spacing table, and a no-spacing paginated
control. Exact-color coverage alone is diagnostic and cannot replace mean-delta and full-page gates.
