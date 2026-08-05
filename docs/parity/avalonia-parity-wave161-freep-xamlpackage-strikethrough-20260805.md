# Avalonia FreeP rich clipboard Wave 161

Date: 2026-08-05

## Scope

Wave 160 added shared WPF-compatible XamlPackage inline-image parts. The
shared parser already understood hyperlinks and `TextDecorations`, and the
WPF converter, Avalonia surface, and RTF writer already preserved model
`Run.Strikethrough`. The shared XamlPackage writer was the remaining loss:
strikethrough-only runs were emitted without decoration, and runs carrying
underline plus strikethrough could not preserve both decorations.

## Implemented

- The shared XamlPackage writer now emits `TextDecorations` for underline,
  strikethrough, or both (`Underline, Strikethrough`) in model run order.
- Existing hyperlink wrapping, image package parts, private FreeP payload,
  RTF, and Unicode text publication remain unchanged.
- Shared round-trip coverage verifies decoration combinations and hyperlink
  metadata without changing text ordering.

## Native evidence

- An actual WPF `RichTextBox` clipboard XamlPackage produced by
  `TextRange.Save` loads through native `TextRange.Load`; its strikethrough
  run is recovered by the shared parser together with its hyperlink.
- A shared-writer package loads through native WPF `TextRange.Load` and
  exposes both underline and strikethrough `TextDecoration` entries.

## Verification

Final focused foreground serial commands:

- `dotnet test freep\\FreeP.App.Presentation.Tests\\FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --no-build --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ExternalRichTextClipboardTests.SerializeXamlPackage_RoundTripsStrikethroughAndHyperlinkFormatting" --logger "console;verbosity=minimal"`: 1/1 passed.
- `dotnet test freep\\FreeP.App.Host.Tests\\FreeP.App.Host.Tests.csproj --configuration Release --no-restore --no-build --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~WpfRichTextClipboardAdapterTests.SharedXamlPackage_WithStrikethrough_IsAcceptedByNativeWpfTextRangeLoader" --logger "console;verbosity=minimal"`: 1/1 passed.
- `dotnet test freep\\FreeP.App.Host.Tests\\FreeP.App.Host.Tests.csproj --configuration Release --no-restore --no-build --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~WpfRichTextClipboardAdapterTests.NativeWpfXamlPackage_PreservesStrikethroughAndSharedPlannerReadsIt" --logger "console;verbosity=minimal"`: 1/1 passed.
- `dotnet test freep\\FreeP.App.Rendering.Avalonia.Tests\\FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --no-restore --no-build --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~AvaloniaRichTextEditorTests.ClipboardCopyTransfer_WithInlineImage_PreservesAllProductionFormats" --logger "console;verbosity=minimal"`: 1/1 passed.

## Residuals

This remains a bounded FlowDocument clipboard projection. FreeP-only OLE
objects, unsupported FlowDocument controls, and broader Office-specific
package resources remain private-payload-only; Wave 161 does not claim those
formats are solved. Unsupported image MIME types also remain private, as in
Wave 160. Desktop clipboard-manager validation remains outside this slice.
