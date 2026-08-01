# FreeW WPF paginated spaced-cell content left margin (2026-08-01)

## Scope

The WPF fixed-width pagination route already resolved per-cell and table-default margins for
positive-spacing tables, but consumed only the top margin. The nested WPF `TableCell` and
`BlockUIContainer` hosts also contribute a six-DIP horizontal inset of their own. Applying the full
serialized left margin again would therefore double-count most of the reservation.

For this exact pagination route, WPF now translates the content stack by only the positive remainder
between the resolved Word left margin and the existing host inset. The full resolved top margin is
retained. Logical column widths, row measurement, cell surfaces, borders, and ordinary flow tables
remain unchanged.

## Provenance

- Fixture SHA-256: `57FC318C683F1208A654466C49378902591033A535768BFDA983E34FC197C6BB`
- Word 16: isolated visible COM `ExportAsFixedFormat`, short flat PDF staging path
- Word PNG SHA-256 pages 1-3:
  - `EAF96D09C35F9B0634E31559CCA513594D7B7806E23A93AD65957647743F7DF6`
  - `947C1FA4BDB2B17D9241B073A33F00EDC12F8713242D310CA3EDEE564142C3B9`
  - `661C254455080E5DCB11A30B93238A2E62C4EEFE88015BAEC4F8264262BF9C6E`
- Candidate PNG SHA-256 pages 1-3:
  - `B535E9F82B0C838F5604993ABACA22C815CFA85C632022062C4A747A0916C427`
  - `792A376229BE9F6DE83579B95D4EC368DC5A2A9AFA6263FAAF99C5323779CA73`
  - `A5F9241251D1580C77068E1F29AA62F7FBF4A513D0A65B7A5D39DB3A77AC079F`

The regenerated target reproduced the same three Word PNG hashes as the preceding table slices.
All Word target/control documents exported and their owned processes quit cleanly.

## Evidence

Mean absolute RGB channel delta against the matching Word PNG, relative to the accepted top-margin
baseline:

| Page / region | Before | After | Change |
|---|---:|---:|---:|
| Page 1 whole | 6.9059% | 6.7027% | -0.2032 pp |
| Page 1 table ROI `(65,171)-(749,376)` | 12.8676% | 12.2432% | -0.6244 pp |
| Page 2 whole | 9.2442% | 8.8065% | -0.4377 pp |
| Page 2 table ROI `(65,86)-(749,462)` | 13.1097% | 12.3765% | -0.7332 pp |
| Page 3 whole | 7.3462% | 7.1575% | -0.1887 pp |
| Page 3 table ROI `(65,86)-(749,293)` | 14.2873% | 13.7130% | -0.5743 pp |

The ordinary positive-spacing `table-layout-complex` page and both no-spacing
`table-pagination-repeat-header` pages are SHA-256 byte-stable.

## Bounded probe

The resolved six-point left margin is eight DIPs. Adding four DIPs after the existing host inset
improved all three pages, but only to 6.8742%, 9.1698%, and 7.3074%. Adding the measured two-DIP
remainder improved them further to 6.7027%, 8.8065%, and 7.1575%, so the narrower mapping was kept.

## Verification

- Focused spaced/no-spacing pagination contracts: 2/2
- Full `DocumentViewRoundTripTests`: 50/50
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh candidate render: 3/3 target pages and 3/3 control pages
- Fresh Word COM target/control batch: 3/3 documents, clean owned-process exits

## Process rule

When serialized spacing or margins meet nested host chrome, measure the effective host-owned inset
before applying model geometry. Consume only the unrepresented remainder on the exact render path,
then gate the full affected page sequence plus ordinary-flow and no-spacing pagination controls.
