# FreeW Avalonia PDF paragraph surfaces

Date: 2026-08-01
Scope: FreeW Avalonia live paragraph borders and direct PDF export. No package, WPF, FreeP, or FreeX behavior changed.

## Result

Direct PDF export now retains paragraph shading and borders from the already-resolved Avalonia page layout. Each line surface is clipped to its physical page and converted from page-space DIP coordinates to PDF points.

The adapter preserves:

- solid paragraph shading color;
- top, bottom, left, and right edge selection;
- true bottom-only horizontal rules;
- authored stroke color and point width;
- dotted and dashed stroke patterns through open `PdfPath` contours;
- paint order below tables, floating objects, inline media, and body text.

The investigation also found and fixed an Avalonia live-render defect: `ParagraphBorder.BottomOnly` suppressed left/right but still painted the default top edge. The model contract, DOCX writer, WPF host, and character-border planner all define bottom-only as a single lower rail. Avalonia live paint and PDF export now follow that same contract.

## Evidence

`DocumentViewPdfExportTests` verifies a green shaded paragraph with a three-edge red dashed border, a blue dotted bottom-only rule, exact colors/widths/dash arrays, surface-before-text order, valid portable PDF bytes, and more than 100 exact fill-color pixels in the Skia raster. An undecorated document is the no-operation control.

The existing Avalonia B1 render suite remains green as the paired live-render contract.

## Verification

```text
dotnet build freew\FreeW.App.Avalonia\FreeW.App.Avalonia.csproj --configuration Release --no-restore --disable-build-servers -p:BuildProjectReferences=false -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
  Build succeeded. 0 warnings, 0 errors.

dotnet build freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:BuildProjectReferences=false -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
  Build succeeded. 0 warnings, 0 errors.

dotnet test freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --no-restore --filter "FullyQualifiedName~DocumentViewPdfExportTests|FullyQualifiedName~DocumentViewB1RenderTests" --logger "console;verbosity=minimal"
  Passed: 54, Failed: 0, Skipped: 0.
```

## Residuals

- Paragraph shading patterns currently follow the live Avalonia compositor's solid-fill behavior; patterned paragraph shading requires a shared visual plan before PDF can preserve it independently.
- The portable text writer still uses built-in font faces rather than exact Office font embedding.
- This slice proves model, operation, writer, and raster behavior. It does not claim pixel identity against a Word PDF baseline.
