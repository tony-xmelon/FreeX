# Avalonia FreeP rich clipboard Wave 159

Date: 2026-08-05

## Scope

The WPF `WpfRichTextClipboardAdapter.BuildDataObject` publishes a native
`DataFormats.XamlPackage` in addition to the private FreeP payload, RTF, and
Unicode text. Before this wave, Avalonia's production rich-editor copy transfer
published only the private payload, standard RTF, and Unicode text even though
its paste path already recognized Windows and Linux XamlPackage formats.

## Implemented

- Added a shared bounded XamlPackage writer for renderer-neutral rich text.
- The writer emits the WPF package contract: `Xaml/Document.xaml`,
  `_rels/.rels`, and `[Content_Types].xml`.
- The document uses WPF's `Section` root and projects paragraphs, common run
  formatting, hyperlinks, and supported table/cell styling. Inline-table runs
  become Section- or TableCell-level table blocks; surrounding runs are split
  into adjacent paragraphs in logical order because WPF tables are blocks.
- Font sizes are converted from FreeP points to WPF DIPs on write; the shared
  parser converts them back to points.
- Avalonia copy now publishes the package under the existing platform-specific
  Windows/Linux XamlPackage formats, without removing the private FreeP
  payload, RTF, or Unicode fallback.

## Verification

Focused foreground serial commands used:

- `dotnet test freep\\FreeP.App.Presentation.Tests\\FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ExternalRichTextClipboardTests"`: 55/55 passed.
- `dotnet test freep\\FreeP.App.Host.Tests\\FreeP.App.Host.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~WpfRichTextClipboardAdapterTests"`: 18/18 passed, including native table loading.
- `dotnet test freep\\FreeP.App.Rendering.Avalonia.Tests\\FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~AvaloniaRichTextEditorTests.ClipboardCopyTransfer_PublishesStandardRtfAlongsidePrivatePayload|FullyQualifiedName~AvaloniaRichTextEditorTests.ClipboardCopyTransfer_PublishesXamlPackageAlongsidePrivatePayloadAndRtf"`: 2/2 passed.
- `dotnet build FreeP.slnx --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`: passed with 0 warnings and 0 errors.

The WPF authority test confirms native `BuildDataObject` publishes XamlPackage.
The interoperability tests feed the shared writer's bytes to WPF
`TextRange.Load(stream, DataFormats.XamlPackage)` and verify text, bold
formatting, the 16pt-to-DIP conversion, and a generated table between surrounding
paragraphs. The Avalonia test reads the exact production `DataTransfer` and
verifies all three rich/fallback payloads.

## Residuals

The package is deliberately resource-free. FreeP-only OLE data, package
resources, and other unsupported FlowDocument controls remain in the private
FreeP payload. Table row heights and vertical cell anchors also remain private
because WPF FlowDocument does not expose valid XAML properties for those model
values. Broader Office-specific XamlPackage resource round-tripping and physical
desktop clipboard-manager validation remain outside this slice.
