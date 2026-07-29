# Section Page Surface Crop Origin

## Scope

`f2-hf-images` renders each physical section page through an isolated one-page
document so the selected section header and footer are authoritative. The
Word reference was exported at 816x1056 through the recovered Word COM
baseline path.

## Defect

The isolated render for physical page two was cropped as though it still
contained physical page two. `CropToDocumentPageSurface` consequently selected
the second print-layout page origin, clamped it against the one-page source,
and removed an additional 24 DIP from the top. The page-two header, body, and
footer were all registered 24 pixels too high.

## Correction

`PageLayoutShot` now supplies page one to the cropper when a section-page
surface is active. Ordinary multi-page captures continue to use their physical
page number. The normal Avalonia and Skia fallback crop paths share the same
resolved crop page number.

## Matched Evidence

Fresh Word target and rebuilt Release PageLayoutShot at 816x1056:

| Page | Whole-page mean channel delta | Header ROI | Body ROI | Lower ROI |
| --- | ---: | ---: | ---: | ---: |
| Section 1 | 1.5100% -> 1.5100% | 2.2532% -> 2.2532% | 2.5226% -> 2.5226% | 0.0400% -> 0.0400% |
| Section 2 | 2.4993% -> 1.3037% | 4.9020% -> 2.2608% | 2.7363% -> 2.0665% | 1.5821% -> 0.0400% |

Section one remains byte-stable. Section two improves across all measured
regions; no Word reference was regenerated during candidate scoring.

## Verification

- `dotnet build freew/tools/FreeW.PageLayoutShot/FreeW.PageLayoutShot.csproj --configuration Release`
  - 0 warnings, 0 errors.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~VisualEvidencePageLayoutShotSourceTests`
  - 9 passed, 0 failed.
