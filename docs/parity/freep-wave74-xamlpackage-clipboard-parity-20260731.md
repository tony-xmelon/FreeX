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

## Resource brush semantics

The shared parser now resolves deterministic `SolidColorBrush` entries in a FlowDocument
resource dictionary when paragraph or inline `Foreground` uses a `StaticResource` or
`DynamicResource` reference. The resolved color enters the existing run model consumed by both
WPF and Avalonia; unsupported style objects and resource value types remain unexpanded.

The same bounded resource path now resolves `FontFamily` resources and numeric system
resources used by `FontSize` references. Keyed text `Style` resources with supported
`Setter` properties (`FontFamily`, `FontSize`, `FontWeight`, `FontStyle`, `Foreground`,
and `TextDecorations`) are also applied through the same catalog, including cycle-safe
`BasedOn` style chains; direct element properties retain precedence. Values are converted into
the existing run-level font family, point-size, weight, decoration, and color fields, so both
hosts retain common WPF style semantics without expanding arbitrary controls or unsupported
style setters. `BaselineAlignment` is also supported as a semantic script setter.

WPF's inheritable `FlowDirection` now follows the same path. `RightToLeft`/`RTL` and
`LeftToRight`/`LTR` values on the document, paragraph, inline element, or keyed style resolve
into the existing paragraph and run direction fields; a more local value overrides its parent.
This closes basic XamlPackage direction semantics while leaving advanced IME and bidi shaping
behavior to the host text engines.

WPF `TextAlignment` is now resolved through the same inheritance chain. Document-level alignment,
paragraph-local values, and keyed style setters map to the existing `Paragraph.Align` field, with
the nearest local value taking precedence. Center, left, right, justify, and distributed values
are retained by both host paste paths.

Explicit whitespace in XamlPackage inline content is now retained: `Run Text=" "` and
`xml:space="preserve"` inline text become real run content, while pretty-printed indentation
around paragraphs and nested elements remains structural and is ignored.

XamlPackage `BaselineAlignment` now maps to the existing run-level baseline contract:
`Superscript` uses the shared editor offset `10000`, `Subscript` uses `-10000`, and
`Baseline`/`Normal` clears the offset. The mapping applies to direct inline elements and
supported keyed `Style` setters, including `BasedOn` inheritance, so WPF and Avalonia retain
script semantics without inventing a separate XamlPackage text model. XamlPackage does not
carry a numeric baseline percentage, so this is semantic function parity rather than a new
font-raster calibration.

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
- Shared `ExternalRichTextClipboardTests.XamlPackageFlowDocument_PreservesBaselineAlignmentAndStyleInheritance`
  proves direct, inherited, and reset baseline states; WPF and Avalonia paste tests prove the
  same values reach each host editor.
- Shared `ExternalRichTextClipboardTests.XamlPackageFlowDocument_PreservesFlowDirectionInheritanceAndOverrides`
  proves document inheritance plus paragraph and inline LTR overrides; paired WPF/Avalonia paste
  tests consume the same paragraph/run direction values.
- Shared `ExternalRichTextClipboardTests.XamlPackageFlowDocument_PreservesTextAlignmentInheritanceAndOverrides`
  proves document, direct paragraph, and keyed-style alignment precedence; paired WPF/Avalonia
  paste tests consume the resulting `Paragraph.Align` values.

## Inline image runs

Rich XAML and RTF images that occur inside a paragraph are now represented as a single logical
object-replacement run (`U+FFFC`) with source bytes, content type, and authored EMU extents.
The shared rich-text mutation and clipboard codec preserve that run in sequence with surrounding
text. WPF materializes it as an `InlineUIContainer`; Avalonia consumes the same run as a drawable
one-character text run, reserving its authored width for following text while painting the decoded
image. Block-level images remain available
through the existing image-payload fallback for sources that are not paragraph children.

Evidence: `ExternalRichTextClipboardTests.XamlPackageFlowDocument_PreservesInlineImageRunOrderAndExtent`,
`WpfRichTextClipboardAdapterTests.TryPasteDataObject_PreservesInlineXamlImageInsideTextRunSequence`,
and `AvaloniaRichTextEditorTests.InlineImageRun_IsRetainedBySharedVisualPlan` plus
`AvaloniaRichTextEditorTests.InlineImageRun_ReservesAuthoredWidthForFollowingText`.

## Deliberate residuals

This closes the bounded XamlPackage table/image/hyperlink/list import path, not full FlowDocument parity.
Resource dictionaries beyond the supported solid-color, font-family, numeric text, and keyed
text-style resources,
arbitrary FlowDocument controls,
embedded OLE runs, nested inline tables, richer unsupported
RTF/FlowDocument semantics, advanced IME/bidi behavior, and PowerPoint-authoritative visual baselines
remain deferred. Slide-level XamlPackage image insertion and native editable table cell styling
are covered and are no longer residuals.
