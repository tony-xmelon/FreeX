# FreeW WPF paginated spaced-cell content top margin (2026-08-01)

## Scope

WordprocessingML table defaults and per-cell overrides preserve top and bottom cell margins in the
FreeW model, but the WPF fixed-width pagination host did not consume them. On the route where WPF
suppresses positive `Table.CellSpacing`, cell surfaces were aligned but glyph ink remained 6-7 output
pixels above Word.

WPF now resolves `TableCell.Margins`, then `Table.DefaultCellMargins`, then Word's implicit defaults
for that exact route. The resolved top margin is applied as a render-only vertical translation on the
cell content stack. Exact row measurement, pagination, border/fill surfaces, and horizontal placement
remain unchanged. No-spacing pagination and ordinary flow tables keep their existing baseline path.

## Provenance

- Fixture SHA-256: `035CB170AF2E617603754C8F69B5F9A4DB4CB6ECC4FC1CDA3F0E56D368C5E976`
- Word 16: isolated visible COM `ExportAsFixedFormat`, short flat PDF staging path
- Word PNG SHA-256 pages 1-3:
  - `EAF96D09C35F9B0634E31559CCA513594D7B7806E23A93AD65957647743F7DF6`
  - `947C1FA4BDB2B17D9241B073A33F00EDC12F8713242D310CA3EDEE564142C3B9`
  - `661C254455080E5DCB11A30B93238A2E62C4EEFE88015BAEC4F8264262BF9C6E`
- Candidate PNG SHA-256 pages 1-3:
  - `AD4F04BEADD4F760912E58524238216F19ACCFFBFEBC2F668356BFF7486ADB2E`
  - `2AB10098356C347F042EF3AD8B3D2642D96FF1A2C7190DCE65A04EE8CBAB5461`
  - `F30128D304A15D9DB7719331949CC1EBD2F629274120E21186BA49AF3313EB67`

The regenerated package reproduced the same three Word PNG hashes as the preceding surface slices.
All Word target/control documents exported and their owned processes quit cleanly.

## Evidence

Mean absolute RGB channel delta against the matching Word PNG, relative to the accepted spacing-
registration baseline:

| Page / region | Before | After | Change |
|---|---:|---:|---:|
| Page 1 whole | 7.1767% | 6.9059% | -0.2708 pp |
| Page 1 table | 9.9161% | 9.4972% | -0.4189 pp |
| Page 2 whole | 9.7021% | 9.2442% | -0.4579 pp |
| Page 2 table | 13.8236% | 13.1150% | -0.7086 pp |
| Page 3 whole | 7.4017% | 7.3462% | -0.0555 pp |
| Page 3 table | 10.2670% | 10.1812% | -0.0858 pp |

The ordinary positive-spacing `table-layout-complex` page and both no-spacing
`table-pagination-repeat-header` pages are SHA-256 byte-stable.

The measured body cells carry a per-cell `2pt` top override over the table's `3pt` default. The WPF
contract asserts the resolved per-cell value (`2.6667 DIP`), not merely the table default.

## Rejected probes

Applying the margins as `StackPanel.Margin` improved pages 1 and 3 but increased exact row sizes,
regressing page 2 from 9.7021% to 9.8223%. It was replaced by the render-only translation. Applying
the same translation to no-spacing pagination regressed its pages from 4.6596% to 4.7081% and from
4.2031% to 4.3000%, so that broader dispatch was rejected and the positive-spacing guard retained.

## Verification

- Focused spaced/no-spacing pagination contracts: 2/2
- Full `DocumentViewRoundTripTests`: 50/50
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh candidate render: 3/3 target pages and 3/3 control pages
- Fresh Word COM target/control batch: 3/3 documents, clean owned-process exits

## Process rule

For exact-height table rows, serialized cell margins register content inside the existing row; they
must not increase row measurement. Resolve per-cell overrides before table defaults, preserve the
forced-zero-spacing dispatch boundary, and gate every physical page plus positive-spacing flow and
no-spacing pagination controls.
