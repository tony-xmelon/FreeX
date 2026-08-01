# FreeW Avalonia PDF line numbers

Date: 2026-08-01
Scope: FreeW Avalonia direct PDF export. No package, WPF, FreeP, or FreeX behavior changed.

## Result

Direct PDF export now retains Word-style line numbers already resolved by the live Avalonia layout. The adapter consumes `BuildLineNumberRenderItems()` rather than building a second sequence, preserving:

- continuous, restart-each-page, and restart-each-section modes;
- authored start and count-by values;
- paragraph-level line-number suppression;
- physical page and column ownership;
- right-aligned gutter placement and vertically centered 8-point gray text.

The PDF operations are inserted after table surfaces and before behind-text floating objects, inline media, and body text, matching the live compositor's decoration pass. Documents with line numbering disabled emit no line-number operations.

## Evidence

`DocumentViewPdfExportTests` covers a continuous sequence starting at 3 with count-by 2 and a suppressed middle paragraph (`3, 5`), exact font/color/gutter placement, operation order before body text, and a disabled control. A multi-page restart fixture verifies that every physical PDF page starts at the authored value 2. A two-section fixture verifies a same-page restart from 4 to 9 at a continuous section break. The focused gate also writes portable PDF bytes and requires visible dark ink inside the rendered Skia page gutter.

## Verification

```text
dotnet build freew\FreeW.App.Avalonia\FreeW.App.Avalonia.csproj --configuration Release --no-restore --disable-build-servers -p:BuildProjectReferences=false -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
  Build succeeded. 0 warnings, 0 errors.

dotnet build freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:BuildProjectReferences=false -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
  Build succeeded. 0 warnings, 0 errors.

dotnet test freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --no-restore --filter "FullyQualifiedName~DocumentViewPdfExportTests" --logger "console;verbosity=minimal"
  Passed: 22, Failed: 0, Skipped: 0.
```

## Residuals

- The shared portable text operation uses its built-in Helvetica face rather than Word's line-number style font. Font-family selection remains a shared PDF vocabulary enhancement.
- This slice proves model, operation, writer, and raster behavior. It does not claim pixel identity against a Word PDF baseline.
