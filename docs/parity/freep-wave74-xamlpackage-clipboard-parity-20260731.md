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

## Evidence added or exercised

- WPF rich-editor custom-v2 precedence over XamlPackage, RTF, and plain text:
  `WpfRichTextClipboardAdapterTests.TryPasteDataObject_CustomPayloadPrecedesXamlPackageAndRtf`.
- Avalonia rich-editor custom-v2 precedence over XamlPackage, RTF, and plain text:
  `AvaloniaRichTextEditorTests.ClipboardPaste_CustomPayloadPrecedesXamlPackageRtfAndPlainText`.
- Avalonia system clipboard round-trip of the WPF-compatible XamlPackage platform alias:
  `PresentationClipboardInteropTests.Avalonia_data_transfer_round_trips_wpf_xamlpackage_platform_format`.
- Existing paired parser and slide-level coverage continues to prove formatted paragraphs,
  tables, one image, and ordered multi-image insertion through WPF and Avalonia.

## Deliberate residuals

This closes bounded XamlPackage import, not full FlowDocument parity. Resource dictionaries,
arbitrary FlowDocument controls, inline picture/object runs in the rich editor, richer
unsupported RTF/FlowDocument semantics, IME/RTL behavior, and PowerPoint-authoritative visual
baselines remain deferred. Slide-level XamlPackage image insertion is covered and is no longer a
residual.
