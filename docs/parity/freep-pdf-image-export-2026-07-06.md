# FreeP PDF Image Export Slice - 2026-07-06

## Scope

- Added a shared `PdfImage` draw op for fixed-layout PDF image placement.
- Extended `PortablePdfWriter` to emit PNG/JPEG image XObjects and place them from the shared draw-op model.
- Extended `SkiaPdfWriter` to render the same shared image op instead of ignoring it.
- Mapped FreeP `SlideShapeKind.Picture` and picture-backed shapes to `PdfImage` at modeled slide bounds.

## Supported Depth

- PNG: dependency-free managed decode for 8-bit non-interlaced grayscale, RGB, palette, grayscale-alpha, and RGBA. Alpha is flattened by ignoring the alpha channel in this fixed-layout portable path.
- JPEG: embedded as DCT XObjects for 8-bit grayscale and RGB JPEG images.
- Unsupported image content types are skipped by the shared writer rather than emitted as corrupt PDF resources.

## Evidence

- `dotnet test tests\Free.Shared.Pdf.Tests\Free.Shared.Pdf.Tests.csproj --configuration Release --filter FullyQualifiedName~PortablePdfWriterTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
- `dotnet test freep\FreeP.App.Host.Tests\FreeP.App.Host.Tests.csproj --configuration Release --filter FullyQualifiedName~PresentationPdfExporterTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

## Remaining PDF Export Gaps

- Arrowhead export for connector line ends remains.
- Broader rotated shape/text fidelity remains beyond image placement rotation support.
- Picture crop, transparency, non-rectangular picture frames, and color effects remain deeper fidelity work.
