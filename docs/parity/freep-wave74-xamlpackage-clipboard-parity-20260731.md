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

Wave 74 started with the bounded import behavior already implemented by the shared parser and
thin host adapters. The follow-up slices add native table-cell style and hyperlink propagation
where the existing projection was incomplete, while keeping the host adapters shared.

## Native table cell styles

The shared XamlPackage parser now carries the native table-cell formatting that the editable
slide-table model can represent. `Background` maps to the existing solid cell fill,
`Padding` maps from XAML DIPs to point insets, `BorderBrush` and `BorderThickness` map to the
four existing cell borders, and `VerticalContentAlignment`/`VerticalAlignment` maps to the
shared top, middle, or bottom cell anchor. WPF and Avalonia therefore preserve the same
editable table semantics for XamlPackage and RTF paste. The in-canvas text projection remains
flattened because `TextBody` has no inline-table node. XamlPackage `Image` Width/Height DIPs
now also survive as EMU picture extents, matching the existing RTF image insertion contract;
images without authored dimensions continue to use normal insertion bounds.

XamlPackage `Hyperlink` elements and `NavigateUri` attributes now populate the existing
`Run.Hyperlink` model, including the optional tooltip. The shared URI allowlist accepts only
`http`, `https`, `mailto`, `ftp`, and local `file` targets, so unsupported schemes remain plain
text. This keeps XamlPackage paste behavior aligned with the existing RTF hyperlink path and
the shared PPTX hyperlink writer.

## List marker semantics

XamlPackage `List`/`ListItem` content now maps to the existing paragraph list model. Disc,
circle, square/box, decimal, alpha, and Roman marker styles are preserved, nested lists carry
their level, and an authored `StartIndex` applies only to the first item in that list. A list
item's later paragraphs remain ordinary continuation text; unknown marker styles are left
unbulleted instead of being guessed.

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
- Shared parser coverage proves valid XamlPackage hyperlinks and tooltips survive while an
  unsafe `javascript:` target is blocked; WPF and Avalonia host paste tests consume the same
  run-level hyperlink payload.
- Shared parser coverage proves bullet, decimal, alpha, Roman, nested-level, and start-index
  semantics; paired WPF/Avalonia paste tests consume the existing paragraph list model.

## Deliberate residuals

This closes the bounded XamlPackage table/image/hyperlink/list import path, not full FlowDocument parity.
Resource dictionaries, arbitrary FlowDocument controls, inline picture/object runs in the rich
editor, nested inline tables, richer unsupported RTF/FlowDocument semantics, IME/RTL behavior,
and PowerPoint-authoritative visual baselines remain deferred. Slide-level XamlPackage image
insertion and native editable table cell styling are covered and are no longer residuals.
