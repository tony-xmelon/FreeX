# FreeW Inline Header Image Origin -- 2026-07-28

## Scope

`f2-hf-images.docx` contains two separate inline DrawingML header images: a 128 x 42
DIP left-aligned image on page 1 and a 112 x 37.33 DIP right-aligned image on page 2.
The shared header surface-height calibration fixed the page-1 lower edge, but both
images still started one pixel above Word's header origin.

The composite renderer now offsets only header slots that contain an inline image by
one DIP at the final page-compositing origin. Text-only headers retain the existing
`headerDistance - 1` calibration.

## Evidence

Reference: direct Microsoft Word COM PDF export, rasterized at 96 DPI to 816 x 1056
PNG pages. Candidate and reference use the same fixture and composite render path.

| Page | Metric | Before | After |
|---|---|---:|---:|
| 1 | Whole page mean RGB delta | 1.3326% | 1.2681% |
| 1 | Left header-image ROI `(80,24)-(240,85)` | 7.5297% | 1.8382% |
| 2 | Whole page mean RGB delta | 1.2321% | 1.1846% |
| 2 | Right header-image ROI `(590,24)-(740,80)` | 8.3371% | 3.4629% |

The control is `table-page-composition-stress.docx`, whose three generated table
continuation pages use text headers. All three candidate PNGs were byte-identical to
their prior render; their whole-page and header ROI scores therefore remained:

| Page | Whole page | Header ROI `(80,25)-(740,90)` |
|---|---:|---:|
| 1 | 8.0325% | 6.0684% |
| 2 | 9.9092% | 14.6205% |
| 3 | 7.6605% | 14.6219% |

## Verification

- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~VisualEvidenceFidelityRenderSourceTests" --logger "trx;LogFileName=header-image-origin-tests.trx"` -- 14/14 passed.
- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore` -- 0 warnings, 0 errors.
- Fresh composite renders of `f2-hf-images.docx` and `table-page-composition-stress.docx` completed from the rebuilt Release artifact.

## Guard

Treat header origin as content-owner specific. A global one-DIP shift improves inline
header images but regresses text-only generated-table headers, so retain the image-run
signature guard and score both image and text-header fixtures for future changes.
