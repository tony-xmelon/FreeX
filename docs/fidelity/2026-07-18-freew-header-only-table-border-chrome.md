# Header-Only Table Border Chrome

## Scope

`table-pagination-repeat-header.docx` carries an explicit complete
`w:tblBorders` payload of six matching `single/0.5pt/auto` edges, while its
header cells own the non-default double/thick navy borders. WPF previously
ignored the table-level payload for generic FlowDocument chrome and selected
the blue catalog-style fallback instead. Word resolves this payload's `auto`
token to black.

The WPF path now gives that payload precedence only when all of the following
are true:

- the table has a header row and at least one body row;
- all six table-border edges are present, `single`, `0.5pt`, and share one
  color token; and
- every header cell has an explicit border payload while every body cell does
  not.

Mixed, partial, thicker, or body-custom table borders continue through their
existing host paths. This prevents a generic table color calibration from
overriding richer per-cell ownership.

## Cached Word Evidence

The compared target is the persistent matching 816 x 528 Word COM corpus
(`FreeW-WordBaselineSurfaceRefresh-20260717`). The active external Word COM
wrapper was deliberately not reused or interrupted; fresh COM confirmation is
still required before integration.

| Fixture | Page | WPF before | WPF after |
| --- | ---: | ---: | ---: |
| `table-pagination-repeat-header` | 1 | 4.6486% | 4.5222% |
| `table-pagination-repeat-header` | 2 | 3.7978% | 3.6768% |

Controls were byte-stable against the same current-main renderer artifact:

- `table-layout-complex` page 1;
- `table-page-composition-stress` pages 1-3.

## Verification

- `TableStyleGalleryTests`: 10/10 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Target and control renders used `--configuration Release --no-build` after
  the renderer artifact was rebuilt.
