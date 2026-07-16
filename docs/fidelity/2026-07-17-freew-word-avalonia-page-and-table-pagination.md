# FreeW Word Page Surface and Table Pagination

## Scope

The Word-capable machine produced a fresh visible-Word baseline from the generated fixture corpus at
`freew-fidelity-corpus/runs/word-baseline-evidence-20260717`. All 30 fixture DOCX files exported through
the visible Publish dialog; this note concerns the Avalonia comparison lane rather than DOCX open/export.

## Capture Normalization

`FreeW.PageLayoutShot` now crops the actual document surface for the additional generated fixture scenarios
that map to Word PNGs. The evidence therefore compares physical Word-sized pages instead of a large desktop
viewport against a page image. This removes false dimension mismatches from header/footer, review, field,
table, drawing, and backstage scenarios.

## Table Result

The `table-page-composition-stress` fixture exposed three renderer defects:

- Avalonia ignored `TableRowHeightRule.Exact` and sized rows from their wrapped text.
- Legacy built-in paragraph styles carried nonzero spacing without explicit-set flags, which the display
  cascade discarded even though Word applies it.
- `tblCellSpacing` was recorded in evidence but did not occupy visual or pagination space, and repeated
  headers relied on an estimate rather than the measured page break.

Avalonia now honors exact row boxes, applies legacy nonzero style spacing, accounts for vertical cell spacing
in the shared pagination estimate and renderer, and repeats a table header when measured layout moves a row
to another page. In the live Word baseline both engines now show two data rows on page 1 and header plus rows
3-6 on page 2; both report three pages for this fixture.

The strict PNG comparison remains outside tolerance because typography, watermark composition, and fine
table border/cell geometry still differ. The remaining delta is now a renderer-fidelity problem rather than
a capture-size or page-break problem.

## Watermark Interoperability Follow-up

The live Word probe exposed one additional DOCX-format defect in the table fixture: its VML
`fillcolor` and `v:fill/@color` values omitted the CSS `#` prefix. Word therefore interpreted the
configured gray text watermark as white (`Fill.ForeColor.RGB = 16777215`), making it nearly invisible
in the PDF, while FreeW rendered the model's intended gray. The writer now emits `#RRGGBB` VML colors.
A regenerated fixture reports Word's configured gray (`8355711`) through COM and produces a visible
watermark in the visible-publish PDF.

Avalonia also now uses the same fixed `468pt x 117pt` VML text-path box that FreeW writes, centered
relative to the page/margin frame, with Word's non-bold text effect and `fitshape`-style width fitting.
This removes the prior small bold-label approximation. The remaining strict raster delta still includes
header/body typography and table-cell vertical geometry, so this did not claim a full visual pass.

## Verification

- `dotnet test freew\\FreeW.App.Presentation.Tests\\FreeW.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~DocumentViewLayoutPlannerTests"`
  - 27 passed.
- `dotnet test freew\\FreeW.App.Avalonia.Tests\\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~DocumentViewTableStructureTests|FullyQualifiedName~VisualEvidencePageLayoutShotSourceTests"`
  - 34 passed.
- Re-ran `FreeW.PageLayoutShot` and `FreeW.VisualEvidenceSummary` against the fresh visible-Word PNG baseline.
  - The overall strict summary remains nonzero by design; this slice fixed structural pagination and preserved
    the remaining visual deltas for follow-up work.
- `WatermarkOptionsRoundTripTests`: 12 passed.
- Live Word COM probe of the regenerated `table-page-composition-stress.docx`:
  - `Fill.ForeColor.RGB = 8355711`, `Transparency = 0.7799988`, and `Text = TABLE REVIEW`.
- `TextWatermarkLayoutPlanner`: passed, plus the Avalonia table/evidence source lane (35 passed).
