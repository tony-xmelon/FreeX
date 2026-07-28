# Multi-page Table Section Header Ownership

## Scope

`table-page-composition-stress.docx` stores its default header on the active
section, not on `TextDocument.FinalSectionHeadersFooters`. The composite
renderer used the final-section header to decide whether a multi-page table
needed header-frame reservation. That check was false even though the generated
table pages correctly resolved and painted the active section's header.

The inconsistent ownership check placed both the header and continuation-table
body too high.

## Change

The multi-page-table header-frame guard now checks the document sections for an
authored default header. The generated-page header resolver remains the
authority for selecting the actual slot; this guard only decides whether to
reserve the authored header frame.

## Matched Word Evidence

Reference: `wordcom-full-native-refresh-20260728`, direct Word PDF raster at
816x528. The candidate used the rebuilt Release FidelityRender composite and
the same reference PNGs.

| Page | Whole page before | Whole page after | Header ROI before | Header ROI after |
| --- | ---: | ---: | ---: | ---: |
| 1 | 9.7794% | 7.5855% | 7.6616% | 4.0811% |
| 2 | 12.5632% | 10.0808% | 15.8625% | 9.2483% |
| 3 | 9.0888% | 7.6441% | 15.8597% | 9.2218% |

The body ROI improved on every page as the continuation table moved into the
reserved header frame.

## Controls

Fresh candidate renders were byte-identical to current main for:

- `f2-hf-basic` pages 1-3;
- `table-layout-complex` page 1;
- `table-pagination-repeat-header` pages 1-2.

## Verification

- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --filter FullyQualifiedName~VisualEvidenceFidelityRenderSourceTests.FidelityRender_ReservesTheAuthoredHeaderFrameForMultiPageTableBodies` passed: 1/1.
- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore -p:BuildInParallel=false -m:1` passed with 0 warnings and 0 errors.
