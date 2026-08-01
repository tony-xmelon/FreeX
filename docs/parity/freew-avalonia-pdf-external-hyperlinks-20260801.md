# FreeW Avalonia PDF external hyperlinks

## Scope

FreeW's Avalonia PDF adapter already rendered hyperlink text with Word's default blue underline,
but its shared draw-op pages did not carry clickable regions. This slice adds backend-neutral link
overlays to `PdfContentPage`, emits PDF link annotations in both shared writers, and derives the
regions from FreeW's resolved `PlacedChar` layout.

## Ownership

- Link geometry uses the existing top-left, y-down page-space contract shared with raster PDF pages.
- FreeW splits regions on page, line, formatting, URL, anchor, or ScreenTip changes. Adjacent links
  with identical visual formatting therefore remain distinct annotations.
- External URLs become PDF `/Link` annotations. Internal bookmark anchors now resolve through the
  follow-up named-destination slice documented in
  `freew-avalonia-pdf-internal-bookmark-links-20260801.md`.
- The portable writer clips regions to the media box and converts them to PDF y-up coordinates.
- The Skia writer uses `SKCanvas.DrawUrlAnnotation`, preserving its embedded-font content path.

## Verification

- `dotnet build tests\Free.Shared.Pdf.Tests\Free.Shared.Pdf.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
  - 0 warnings, 0 errors.
- `dotnet test tests\Free.Shared.Pdf.Tests\Free.Shared.Pdf.Tests.csproj --configuration Release --no-build --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
  - 97/97 passed.
- `dotnet build freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
  - 0 warnings, 0 errors.
- `dotnet test freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~DocumentViewPdfExportTests" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
  - 33/33 passed.

The FreeW contract covers two adjacent external URLs with different ScreenTips plus an internal
bookmark control. Both portable and Skia output contain the two expected URI actions, while the
bookmark does not become an external annotation.
