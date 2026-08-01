# FreeW Skia PDF italic faces

## Scope

FreeW's draw-op adapter emits all four `PdfFontFace` values, but the Unicode-capable Skia PDF
writer previously selected only regular or bold typefaces. Italic was rendered as regular and
bold-italic as bold, including text nested inside transforms and effect groups.

The Skia writer now owns one disposable four-face set per export/render operation and selects the
requested regular, bold, italic, or bold-italic typeface for every text draw. The same set is passed
through rotation, clipping, opacity, shadow, glow, soft-edge, reflection, and bevel recursion.

## Verification

- `dotnet build tests\Free.Shared.Pdf.Tests\Free.Shared.Pdf.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
  - 0 warnings, 0 errors.
- `dotnet test tests\Free.Shared.Pdf.Tests\Free.Shared.Pdf.Tests.csproj --configuration Release --no-build --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
  - 98/98 passed.
- `dotnet build freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
  - 0 warnings, 0 errors.
- `dotnet test freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~DocumentViewPdfExportTests" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
  - 33/33 passed.

The focused raster contract proves italic output differs from upright regular output and
bold-italic differs from upright bold output for identical text and geometry.
