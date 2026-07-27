# Generated Table Page Header Fidelity

## Scope

`table-page-composition-stress.docx` overflows its table onto pages 2 and 3.
The normal `PageBox` composite path rendered the active header and footer, but
the generated-table continuation path rendered only the footer. Microsoft Word
repeats the `PAGE` and `NUMPAGES` header on each continuation page.

## Change

`FreeW.FidelityRender` now resolves both header and footer slots through
`HeaderFooterPagePlanner` for generated table pages and renders them using the
same printable-width frame as normal pages. Header placement is shared between
the normal and generated paths and is one DIP above the stored header distance.
The adjustment aligns Word's header ink band at `y=27..39` with FreeW rather
than the prior `y=28..40` band.

## Word Evidence

Reference: a manually exported Microsoft Word PDF rasterized at 96 DPI to
816x528 PNGs on 2026-07-28. The input was
`freew-fidelity-corpus/runs/current-chart-word-baseline-20260715/fixtures/f2/table-page-composition-stress.docx`.

| Page | Region | Before | After |
| --- | --- | ---: | ---: |
| 1 | whole page | 8.0505% | 8.0325% |
| 1 | header text | 12.1156% | 11.0898% |
| 2 | whole page | 9.9230% | 9.9092% |
| 2 | header text | 11.8876% | 11.1000% |
| 3 | whole page | 7.6743% | 7.6605% |
| 3 | header text | 11.8917% | 11.1080% |

The page 2 and 3 table-body and footer crops were pixel-stable. The visual
comparison also confirms that the continuation-page header fields resolve to
`page 2 of 3` and `page 3 of 3`.

## Verification

- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore`
  passed with 0 warnings and 0 errors.
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --no-build --filter FullyQualifiedName~VisualEvidenceFidelityRenderSourceTests.FidelityRender_GeneratedTablePagesResolveTheirHeaderAndFooterSlots`
  passed: 1/1.
- The rebuilt Release composite emitted all three fixture pages and was scored
  against the matched Word PDF raster.
