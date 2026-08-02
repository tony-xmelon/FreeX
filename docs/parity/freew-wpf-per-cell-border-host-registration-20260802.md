# FreeW WPF per-cell border host registration (2026-08-02)

## Scope

- Fixture: `freew-fidelity-corpus/files/tables/04-custom-borders.docx`
- Reference: fresh Word 16.0 PDF export rasterized at 816x1056
- Candidate: `FreeW.FidelityRender` Release, `--composite`
- Render provenance: `wpf-composite-renderer`
- Word PNG SHA-256: `DFECBE76ECA76A371A1ECA9C4D1AD381650B85C1300F70038C460CE08FD8B854`

## Finding

WPF placed the custom `TableCellBorderChrome` inside the cell's four-DIP horizontal content padding. This shifted the border and glyph surface inward and doubled the visible gap between adjacent custom-bordered cells. The ordinary table route does not use this chrome.

The WPF host now removes horizontal `TableCell` padding only when a visible per-cell border plan owns the surface, and translates that border/content host four DIPs left to compensate for WPF's remaining content inset. Vertical padding, row cadence, table grid widths, ordinary cells, and package border metadata are unchanged.

## Evidence

| Metric | Current main | Candidate | Delta |
|---|---:|---:|---:|
| Whole page | 1.2074% | 1.1687% | -0.0387 pp |
| Table ROI `(80,115)-(600,270)` | 12.1978% | 11.7840% | -0.4138 pp |

`05-cell-shading.docx`, which has no `w:tcBorders`, remained byte-identical before and after:

- SHA-256: `02B4658694DAF2B96E92259630853D8E7CD9B583592C0D48FCFC4B675FFC12A1`
- All other table-corpus fixtures also contain zero `w:tcBorders`; only `04-custom-borders.docx` enters the changed branch.

## Rejected probes

- Normalizing literal newlines inside `w:t` to spaces and reallocating content-autofit widths matched horizontal text intent but collapsed Word's taller row envelope; whole page regressed to 1.2954%.
- Setting WPF `Table.CellSpacing=0` joined horizontal borders but also collapsed row cadence; whole page regressed to 1.2241%.
- Padding-only and translated normalized-text variants remained above the current-main score and were reverted.

## Verification

- `DocumentViewRoundTripTests`: 55/55 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Fresh candidate render: 1/1 page emitted at 816x1056.
- Source contract covers the custom cell edge registration and an ordinary neighboring cell retaining its four-DIP inset.
