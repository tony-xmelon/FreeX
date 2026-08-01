# FreeW WPF paginated table cell-spacing registration (2026-08-01)

## Scope

WPF fixed-width pagination suppresses native `Table.CellSpacing` and paints explicitly bordered
cell surfaces inside the host's four-DIP cell padding. After the fill-ownership correction, each
non-first surface still began one serialized spacing unit too far right. The forced-zero pagination
route now uses `w:tblCellSpacing` to register only the physical fill and border surface:

- the first surface retains half of the authored outer reservation;
- each later surface extends left by one authored spacing unit;
- the final surface retains one authored spacing unit at the outer right edge.

Text, cell padding, column widths, row measurement, page scheduling, and ordinary flow tables are
unchanged.

## Provenance

- Fixture SHA-256: `949877FF8A2EA979DC77266C8CDC7A9DEED92F9D5D7BF966A800B9044DF05900`
- Word 16: isolated visible COM `ExportAsFixedFormat`, short flat PDF staging path
- Word PNG SHA-256 pages 1-3:
  - `EAF96D09C35F9B0634E31559CCA513594D7B7806E23A93AD65957647743F7DF6`
  - `947C1FA4BDB2B17D9241B073A33F00EDC12F8713242D310CA3EDEE564142C3B9`
  - `661C254455080E5DCB11A30B93238A2E62C4EEFE88015BAEC4F8264262BF9C6E`
- Candidate PNG SHA-256 pages 1-3:
  - `61E1482C31B2A8D5CEECFCB1D743B8999DE1A764D22E9DA76B15A82E03BBF903`
  - `1517802691C6A6E454B0ADB03E9755A2324EFD6B4E46AB2DB4ED2A622E3E3CD9`
  - `F6FB6AC810290155DA4444DEF08DCB7C0FAE7C23C3D80E54E6181E0C36E1AC01`

The same Word PNG hashes were reproduced from the regenerated package. All three Word documents in
the target/control batch exported and their owned Word processes quit cleanly.

## Evidence

Mean absolute RGB channel delta against the matching Word PNG, relative to the accepted inner-surface
baseline:

| Page / region | Before | After | Change |
|---|---:|---:|---:|
| Page 1 whole | 7.2950% | 7.1767% | -0.1183 pp |
| Page 1 table | 10.0991% | 9.9161% | -0.1830 pp |
| Page 1 combined seams | 10.8719% | 10.6196% | -0.2523 pp |
| Page 2 whole | 9.9019% | 9.7021% | -0.1998 pp |
| Page 2 table | 14.1326% | 13.8236% | -0.3090 pp |
| Page 2 combined seams | 15.2611% | 14.8301% | -0.4310 pp |
| Page 3 whole | 7.5189% | 7.4017% | -0.1172 pp |
| Page 3 table | 10.4484% | 10.2670% | -0.1814 pp |
| Page 3 combined seams | 11.0313% | 10.7834% | -0.2479 pp |

The ordinary positive-spacing `table-layout-complex` page and both pages of the no-spacing
`table-pagination-repeat-header` control remain SHA-256 byte-stable.

## Verification

- Focused pagination/flow ownership contracts: 2/2
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh current-main candidate render: 3/3 target pages and 3/3 control pages
- Fresh Word COM batch: 3/3 documents, clean owned-process exits

## Process rule

When native spacing is suppressed for pagination, derive physical surface registration from the
serialized spacing rather than altering logical columns or text padding. Keep internal and outer
edge ownership distinct, gate the complete page sequence, and require ordinary positive-spacing and
no-spacing pagination controls to remain byte-stable.
