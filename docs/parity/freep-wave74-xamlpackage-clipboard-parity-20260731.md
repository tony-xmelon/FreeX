# FreeP Wave 74 XamlPackage clipboard parity

Date: 2026-07-31

## Audit result

The reported Avalonia `XamlPackage` import residual is stale for the bounded content model.
WPF remains the authority, and both host paths now consume the same
`ExternalXamlClipboardPlanner` projection:

- `WpfRichTextClipboardAdapter` resolves FreeP custom v2, `XamlPackage`, RTF, then Unicode text.
- `AvaloniaRichTextEditor` resolves the corresponding custom, Windows/Linux `XamlPackage`,
  RTF, then Unicode text aliases.
- `AvaloniaPresentationSystemClipboard` reads and writes the public WPF-compatible
  `XamlPackage` platform format, while the slide-level paste service applies the shared
  paragraph, table, image, and multi-image projection.

No production change was necessary in Wave 74. The bounded import behavior was already
implemented by the shared parser and thin host adapters. This wave strengthens paired evidence
at the host boundaries and removes stale inventory wording.

## Native table cell styles

The shared XamlPackage parser now carries the native table-cell formatting that the editable
slide-table model can represent. `Background` maps to the existing solid cell fill,
`Padding` maps from XAML DIPs to point insets, `BorderBrush` and `BorderThickness` map to the
four existing cell borders, and `VerticalContentAlignment`/`VerticalAlignment` maps to the
shared top, middle, or bottom cell anchor. WPF and Avalonia therefore preserve the same
editable table semantics for XamlPackage and RTF paste. The in-canvas text projection remains
flattened because `TextBody` has no inline-table node.

## Evidence added or exercised

- WPF rich-editor custom-v2 precedence over XamlPackage, RTF, and plain text:
  `WpfRichTextClipboardAdapterTests.TryPasteDataObject_CustomPayloadPrecedesXamlPackageAndRtf`.
- Avalonia rich-editor custom-v2 precedence over XamlPackage, RTF, and plain text:
  `AvaloniaRichTextEditorTests.ClipboardPaste_CustomPayloadPrecedesXamlPackageRtfAndPlainText`.
- Avalonia system clipboard round-trip of the WPF-compatible XamlPackage platform alias:
  `PresentationClipboardInteropTests.Avalonia_data_transfer_round_trips_wpf_xamlpackage_platform_format`.
- Existing paired parser and slide-level coverage continues to prove formatted paragraphs,
  tables, one image, and ordered multi-image insertion through WPF and Avalonia.
- WPF and Avalonia slide-level native-table coverage now asserts fill, border, inset, and
  vertical-anchor preservation through the shared `TableCellStyles` payload.

## Deliberate residuals

This closes the bounded XamlPackage table/image import path, not full FlowDocument parity.
Resource dictionaries, arbitrary FlowDocument controls, inline picture/object runs in the rich
editor, nested inline tables, richer unsupported RTF/FlowDocument semantics, IME/RTL behavior,
and PowerPoint-authoritative visual baselines remain deferred. Slide-level XamlPackage image
insertion and native editable table cell styling are covered and are no longer residuals.
