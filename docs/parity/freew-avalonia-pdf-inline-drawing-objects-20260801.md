# FreeW Avalonia PDF inline drawing objects

Date: 2026-08-01
Scope: FreeW Avalonia direct PDF export. No package, WPF, FreeP, or FreeX behavior changed.

## Result

Direct PDF export now retains inline charts, WordArt, and SmartArt. These object families were already visible in the live Avalonia text flow, while only their floating and grouped variants reached `BuildPdfContent()`.

The adapter now reuses each inline object's resolved page-space rectangle and original model with the same shared visual planner and PDF builders used by floating/grouped objects. This preserves:

- chart scenes, frame, plot geometry, labels, title, and series colors;
- per-glyph WordArt fill, outline, warp, rotation, flips, and effect groups;
- SmartArt layout geometry, connectors, node fills/text, and duplicate-drawing suppression;
- physical page ownership and the live chart -> WordArt -> SmartArt paint order;
- placement after behind-text floating objects and inline images, but before body glyphs.

No second inline paginator or object renderer was introduced. The private live caches retain their original scene/plan data and now also retain the source model needed by the existing PDF builders.

## Evidence

`DocumentViewPdfExportTests` builds a real document containing an inline column chart, FillBlue WordArt, Process SmartArt, and trailing body text. It verifies the recursive PDF tree contains chart title/vector frame, all WordArt glyphs, all SmartArt node labels, and correct object-before-body order. Both portable PDF emission and a nonblank Skia raster are required.

The existing live inline-object suite remains unchanged and passes as the paired control.

## Verification

```text
dotnet build freew\FreeW.App.Avalonia\FreeW.App.Avalonia.csproj --configuration Release --no-restore --disable-build-servers -p:BuildProjectReferences=false -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
  Build succeeded. 0 warnings, 0 errors.

dotnet build freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:BuildProjectReferences=false -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
  Build succeeded. 0 warnings, 0 errors.

dotnet test freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --no-restore --filter "FullyQualifiedName~DocumentViewPdfExportTests" --logger "console;verbosity=minimal"
  Passed: 23, Failed: 0, Skipped: 0.

dotnet test freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --no-restore --filter "FullyQualifiedName~DocumentViewInlineFO4Tests" --logger "console;verbosity=minimal"
  Passed: 36, Failed: 0, Skipped: 0.
```

## Residuals

- Inline AutoShapes and mixed inline-object paragraphs are covered by the follow-up
  `freew-avalonia-inline-shape-pdf-20260801.md`.
- PDF text still uses the shared writer's built-in font faces; exact Office font embedding remains outside this adapter.
- This slice proves model, operation, writer, and raster behavior. It does not claim pixel identity against a Word PDF baseline.
