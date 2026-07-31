# FreeW Avalonia PDF pattern fills - Wave 89

Date: 2026-08-01
Scope: FreeW Avalonia direct PDF export and the shared PDF draw-op backends. No FreeX, FreeP, shared ribbon, integration report, Docker, or Linux harness changes.

## Result

Floating FreeW shapes now retain real two-colour tiled pattern fills in direct PDF export. The shared `Free.Shared.Pdf` vocabulary carries:

- WPF-aligned preset families for horizontal, vertical, down/up diagonal, cross, dot, brick, and diagonal-cross fills;
- foreground/background colors from `DrawingObjectFillPlan`, including representative percentage presets such as `pct10`, `pct50`, `pct75`, and `pct90`;
- pattern-filled rectangles, ellipses, and arbitrary paths with optional solid or dashed outlines;
- tile dimensions in the caller's coordinate space, preserving the live 8x8 DIP tile and 12x8 brick tile when Avalonia maps to PDF points.

`PortablePdfWriter` emits reusable PDF Type 1 tiling pattern resources. `SkiaPdfWriter` creates the same shared tile geometry as a repeated shader. Rotation and horizontal/vertical flip groups transform the pattern with the shape; shape text remains a later sibling operation and outlines retain their existing dash metadata.

## Evidence

- Shared writer tests cover reused pattern resources across rectangle, ellipse, and path fills, path outlines, WPF family bucketing, and centered rotation/flip transforms.
- Skia tests rasterize a patterned rectangle and verify both foreground and background pixels while retaining a dashed outline.
- `DocumentViewPdfExportTests` builds a real rotated FreeW textbox with a `pct50` fill, checks foreground/background colors and tile scale, verifies outline dash metadata and split text runs, and writes the resulting PDF through Skia.

## Verification

```text
dotnet test tests\Free.Shared.Pdf.Tests\Free.Shared.Pdf.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~PortablePdfWriterTests|FullyQualifiedName~SkiaPdfWriterTests" --logger "console;verbosity=minimal"
  Passed: 51, Failed: 0, Skipped: 0

dotnet test freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~DocumentViewPdfExportTests --logger "console;verbosity=minimal"
  Passed: 10, Failed: 0, Skipped: 0
```

## Residuals

- Pattern fills are covered for the floating shape geometry emitted by the shared visual plan. WordArt pattern fills, groups, charts, SmartArt, and other unclaimed drawing-object families remain outside this wave.
- Shape effects such as shadow, glow, soft edge, reflection, and bevel remain outside the vector PDF vocabulary.
- Office-authoritative raster baselines remain unavailable; the tests prove shared vector semantics and local backend output rather than pixel identity against Word.
