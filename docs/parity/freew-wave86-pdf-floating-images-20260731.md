# FreeW Avalonia PDF floating images - Wave86

Date: 2026-07-31
Scope: FreeW Avalonia direct PDF export only. No FreeX, FreeP, shared PDF vocabulary, or ribbon files were changed.

## Result

`DocumentView.BuildPdfContent()` now exports floating `InlineImage` objects that are visible in the Avalonia print-layout compositor. The exporter consumes the same `DocumentFloatingObjectSnapshot` page-space rectangles and the same behind/in-front z-order planner used by `Render()`.

For each floating image:

- Page, margin, column, and paragraph anchor placement is preserved through the shared layout planner.
- Behind-text images are emitted below body glyphs; in-front images are emitted above body glyphs.
- PNG and JPEG images without pixel effects retain their original encoded bytes.
- Source crop, model transparency, and rotation are carried through the shared `PdfImage` operation.
- Images with corrections, recolor, artistic effects, or other raster effects use the already rendered Avalonia bitmap as a bounded PNG fallback.
- Page ownership uses the snapshot's resolved page-space Y. The PDF media box clips authored edges outside the page, matching normal page compositing.

## Evidence

Focused operation-level evidence in `DocumentViewPdfExportTests` verifies two floating images' page-space coordinates, layer ordering, source crop, opacity, rotation, and direct encoded-byte preservation. A second test renders the resulting `PdfContentDocument` through `SkiaPdfWriter.RenderPagesToPng` and checks the floating image's pixel centroid against its authored page-space placement.

## Verification

```text
dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~DocumentViewPdfExportTests --no-restore --logger "console;verbosity=minimal"
  Passed: 7, Failed: 0, Skipped: 0

dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~DocumentViewFloatingImageTests --no-restore --logger "console;verbosity=minimal"
  Passed: 24, Failed: 0, Skipped: 0
```

Docker and full-repository gates were intentionally not run for this focused agent slice.

## Residuals

- Floating shapes, charts, WordArt, SmartArt, and drawing groups remain outside this PDF draw-op slice; their Avalonia print-layout rendering is unchanged.
- The shared `PdfImage` vocabulary has no reflection or flip fields, so those transforms are not serialized as direct PDF operations. Existing rendered-bitmap fallback preserves pixel effects but does not add those missing transform operations.
- Reflection footprints, decorative picture borders, and complex effect envelopes remain residuals until the shared PDF vocabulary can represent them or the owning object is raster-composited as a bounded page fragment.
- Unsupported or undecodable image bytes remain omitted from direct PDF export, consistent with the existing image operation contract.
