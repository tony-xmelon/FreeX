# Wave162 FreeP Avalonia XamlPackage lists

## Scope

FreeP's shared XamlPackage writer now emits native WPF `List` and `ListItem` blocks for supported paragraph list metadata. Adjacent list paragraphs are grouped, nested levels are represented by nested lists under the preceding list item, marker families map to WPF marker styles, and authored auto-number starts map to `StartIndex`.

Supported marker output includes decimal, alphabetic, Roman, disc, circle, and square styles. Auto-number variants that WPF cannot represent with a marker-style enum retain their numbering family; punctuation variants remain the native WPF family representation.

OLE remains unsupported in the external XamlPackage projection. FreeP-only OLE data stays in the private clipboard payload, matching the existing writer contract.

## Evidence

- Shared `ExternalRichTextClipboardTests` round-trips upper Roman numbering, explicit starts, circle and square bullets, nested levels, and a later restart through `SerializeXamlPackage` and `TryParseXamlPackage`.
- `WpfRichTextClipboardAdapterTests.SharedXamlPackage_WithNativeLists_IsAcceptedByWpfTextRangeLoader` loads the package with native WPF `TextRange.Load` and checks top-level, nested, marker, and start-index structure.
- `AvaloniaRichTextEditorTests.ClipboardCopyTransfer_PublishesNativeNestedListsInXamlPackage` verifies the Avalonia `DataTransfer` carries the native XamlPackage and that the shared parser restores list levels and starts.
