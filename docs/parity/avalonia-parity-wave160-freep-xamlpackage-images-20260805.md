# Avalonia FreeP rich clipboard Wave 160

Date: 2026-08-05

## Scope

Wave 159 established the shared WPF XamlPackage writer and proved its text and
table subset with native `TextRange.Load`. WPF native copy also carries inline
image package parts, but the shared Avalonia writer was still resource-free.

## Implemented

- Inline model image runs now emit WPF-compatible `InlineUIContainer` and
  `BitmapImage` references in document order.
- Image bytes are stored as `Xaml/ImageN.<extension>` package parts with the
  document relationship, root relationship, and content-type defaults emitted
  by native WPF copy.
- The shared parser accepts both ordinary `Image Source` values and native
  nested `Image.Source/BitmapImage UriSource` values, including `./` package
  references.
- Avalonia production copy continues to publish the private FreeP payload,
  standard RTF, XamlPackage, and Unicode text together.

## Verification

Focused foreground serial commands used:

- `dotnet test freep\\FreeP.App.Presentation.Tests\\FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ExternalRichTextClipboardTests.SerializeXamlPackage_RoundTripsInlineImagePartsInDocumentOrder"`: 1/1 passed.
- `dotnet test freep\\FreeP.App.Host.Tests\\FreeP.App.Host.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~SharedXamlPackage_WithInlineImage_IsAcceptedByNativeWpfTextRangeLoader"`: 1/1 passed.
- `dotnet test freep\\FreeP.App.Rendering.Avalonia.Tests\\FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~AvaloniaRichTextEditorTests.ClipboardCopyTransfer_WithInlineImage_PreservesAllProductionFormats"`: 1/1 passed.
- `dotnet test freep\\FreeP.App.Presentation.Tests\\FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ExternalRichTextClipboardTests"`: 56/56 passed.
- `dotnet test freep\\FreeP.App.Host.Tests\\FreeP.App.Host.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~WpfRichTextClipboardAdapterTests"`: 20/20 passed.
- `dotnet test freep\\FreeP.App.Rendering.Avalonia.Tests\\FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~AvaloniaRichTextEditorTests.ClipboardCopyTransfer_PublishesXamlPackageAlongsidePrivatePayloadAndRtf|FullyQualifiedName~AvaloniaRichTextEditorTests.ClipboardCopyTransfer_WithInlineImage_PreservesAllProductionFormats"`: 2/2 passed.
- `dotnet build FreeP.slnx --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`: passed with 0 warnings and 0 errors.

The native WPF test loaded the shared package through `TextRange.Load`, found
the ordered text, `InlineUIContainer`, and text sequence, and verified the
24x12 image and decoded 1x1 bitmap. The Avalonia test read the actual
production `DataTransfer` and verified private payload bytes, RTF, XamlPackage
image bytes, and Unicode text.

## Residuals

This remains a bounded inline-image slice. OLE data, unsupported FlowDocument
controls, and broader Office-specific package resources remain in the private
FreeP payload. The package writer maps the common WPF-decoder image MIME types
used by the model; unsupported image types remain private. Desktop
clipboard-manager validation remains outside this slice.
