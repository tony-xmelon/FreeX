# FreeW Avalonia PDF watermarks

Date: 2026-08-01
Scope: FreeW Avalonia direct PDF export. No package, WPF, FreeP, or FreeX behavior changed.

## Result

Direct PDF export now retains the text and picture watermarks already owned by the live Avalonia compositor. Both forms use `WatermarkVisualPlanner`, so PDF export shares the existing centered footprint, rotation, opacity, native VML visibility guard, picture scaling, and imported-size semantics.

Text watermarks emit a clipped PDF text layer, wrapped by shared opacity and rotation groups where required. The layer repeats on every laid-out page and remains behind the page border and document content.

Picture watermarks emit a clipped `PdfImage` with the planned bounds, rotation, and effective opacity. PDF intrinsic image geometry comes from a Skia decode of the serialized payload. This matters in headless Avalonia: its bitmap path reported a 16x8 PNG as square during the focused probe, while Skia retained the package-authoritative 2:1 aspect. The live bitmap cache is unchanged.

Imported native VML text-path payloads remain suppressed by the shared planner. PDF export therefore does not resurrect a stale VML label that Word's modern surface does not paint.

## Evidence

`DocumentViewPdfExportTests` covers:

- diagonal semitransparent text on every page;
- watermark-before-border operation order;
- shared clip, rotation, opacity, text, color, and page-center geometry;
- a 16x8 picture retaining 2:1 bounds, diagonal rotation, and 40% opacity;
- valid portable PDF bytes and visible Skia text/picture raster output;
- explicit native VML text-path suppression.

## Verification

```text
dotnet build freew\FreeW.App.Avalonia\FreeW.App.Avalonia.csproj --configuration Release --no-restore --disable-build-servers -p:BuildProjectReferences=false -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
  Build succeeded. 0 warnings, 0 errors.

dotnet build freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:BuildProjectReferences=false -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
  Build succeeded. 0 warnings, 0 errors.

dotnet test freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --no-restore --filter "FullyQualifiedName~DocumentViewPdfExportTests" --logger "console;verbosity=minimal"
  Passed: 19, Failed: 0, Skipped: 0.
```

## Residuals

- The shared portable text operation uses its built-in Helvetica family rather than carrying the authored watermark font family. Font embedding/family selection is a shared PDF vocabulary enhancement.
- Imported native VML text-path geometry remains deliberately suppressed until Word-visible layer ownership is modeled; this slice does not approximate it.
- Direct PDF line-number decorations remain a separate follow-up layer.
- This slice proves model, operation, writer, and raster behavior. It does not claim pixel identity against a Word PDF baseline.
