# FreeW Avalonia PDF floating AutoShapes - Wave87

Date: 2026-07-31
Scope: FreeW Avalonia direct PDF export only. No Linux harness, shared PDF vocabulary, or unrelated evidence files were changed.

## Result

`DocumentView.BuildPdfContent()` now exports floating AutoShapes using the existing shared drawing-object visual plan and floating snapshot draw order. Direct vector output covers:

- rectangle, text-box, ellipse, rounded-rectangle, and custom/freeform geometry;
- solid fills, linear-gradient fills, outlines, and run-aware shape text;
- page/column/paragraph anchor placement through the existing page-space snapshot geometry;
- merged behind-text and in-front passes, so images and shapes interleave by z-order exactly as the live compositor does;
- shape rotation through the shared PDF rotation group.

## Evidence

`DocumentViewPdfExportTests` verifies emitted vector operations, fill/stroke colors and widths, page-space placement, shape text, merged body-layer ordering, and a real Skia PDF byte stream. `DocumentViewLayoutPlannerTests` verifies shape/image draw-order interleaving in both floating bands.

## Verification

```text
dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~DocumentViewPdfExportTests --logger "console;verbosity=minimal"
  Passed: 8, Failed: 0, Skipped: 0

dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~DocumentViewFloatingShapeTests --logger "console;verbosity=minimal"
  Passed: 28, Failed: 0, Skipped: 0

dotnet test freew/FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj --configuration Release --filter FullyQualifiedName~DocumentViewLayoutPlannerTests --logger "console;verbosity=minimal"
  Passed: 34, Failed: 0, Skipped: 0

dotnet build freew/FreeW.App.Avalonia/FreeW.App.Avalonia.csproj --configuration Release --no-restore
  Build succeeded, 0 warnings, 0 errors
```

## Residuals

- Shape flips are retained by the shared visual plan but the shared PDF draw-op vocabulary has no flip transform; the PDF adapter leaves those transforms unchanged.
- Pattern fills use the existing solid-color fallback because the shared PDF vocabulary has no pattern primitive.
- Shape effects (shadow, glow, soft edge, reflection, bevel) remain outside this vector slice; the established effect fallback contract applies until a bounded raster fragment is requested.
- Outline dash styles retain the existing solid-stroke fallback because PDF draw ops do not carry dash arrays.
