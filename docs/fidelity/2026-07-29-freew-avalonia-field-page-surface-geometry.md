# Avalonia Field Page-Surface Geometry

The four-page `field-page-number-variants` page-shot lane used fixed viewport
offsets of 1100, 2200, and 3300 DIP. Those values did not match the shared
print-layout page origins: page three was captured 24 DIP above its physical
surface, clipping its header and disguising the actual paragraph-boundary
layout.

`FreeW.PageLayoutShot` now derives the viewport offset from
`DocumentViewLayoutPlanner.BuildSurfacePlan(...).PageTopDip(pageNumber - 1)`
for pages 2-4 of this source-backed field scenario. The original page-surface
crop continues to remove only page chrome, so both images remain `816x1056`.

This is an evidence-provenance correction, not a renderer calibration. It
improves the valid page-four comparison from `9.2021` to `5.4834` mean absolute
channel delta and leaves pages one/two unchanged (`13.4250`/`13.2103`). The
correct page-three capture is worse than the clipped capture (`19.3934` to
`21.6943`) because it reveals the real remaining owner: Avalonia permits the
first line of body paragraph 34 at the bottom of page two while Word moves the
full paragraph to page three. A first-line-only widow-control probe was rejected
because it over-reserved an empty page; the remaining work needs a complete
paragraph line plan.

Verification:

- `dotnet test freew\\FreeW.App.Avalonia.Tests\\FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~VisualEvidencePageLayoutShotSourceTests` (`9/9`)
- `dotnet build freew\\tools\\FreeW.PageLayoutShot\\FreeW.PageLayoutShot.csproj --configuration Release` (`0` warnings, `0` errors)
- fresh source-backed field capture using the matching cached Word PNG corpus.
