# FreeW Avalonia PDF page borders

Date: 2026-08-01
Scope: FreeW Avalonia direct PDF export. No package, WPF, FreeP, or FreeX behavior changed.

## Result

Direct PDF export now retains the page border already shown by the live Avalonia document compositor. The PDF adapter:

- emits the authored color and point width on every laid-out page;
- preserves page-edge and text-area offset geometry, including Word's 24-point default space;
- preserves dotted and dashed stroke patterns;
- emits the second inner rail for double borders;
- places border operations below tables, floating objects, body text, headers, footers, and notes;
- emits no extra operation when the document has no page border.

The conversion is point-native. It mirrors the existing live compositor's 1.5-DIP page-edge registration correction and minimum 0.5-DIP stroke rather than reinterpreting the package payload.

## Evidence

`DocumentViewPdfExportTests` covers a multi-page dashed page-edge border, exact text-offset double-border geometry, operation ordering, and an absent-border control. The multi-page case also writes through `PortablePdfWriter` and rasterizes through `SkiaPdfWriter`; more than 100 exact authored-color border pixels are required in the first rendered page.

## Verification

```text
dotnet build freew\FreeW.App.Avalonia\FreeW.App.Avalonia.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
  Build succeeded. 0 warnings, 0 errors.

dotnet build freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:BuildProjectReferences=false -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
  Build succeeded. 0 warnings, 0 errors.

dotnet test freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --no-restore --filter "FullyQualifiedName~DocumentViewPdfExportTests" --logger "console;verbosity=minimal"
  Passed: 16, Failed: 0, Skipped: 0.
```

## Residuals

- Decorative art borders still follow the live Avalonia compositor's plain-line fallback; implementing Word's art tiles is a separate visual slice.
- Direct PDF watermark and line-number layers remain separate follow-up work.
- This slice proves model, operation, writer, and raster behavior. It does not claim pixel identity against a Word PDF baseline.
