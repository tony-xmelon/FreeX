# FreeP Rich Effects Clipboard Wave 16

Date: 2026-07-27

## Scope

This slice closes the documented rich-editor clipboard gap for modeled inline effects. The
renderer-neutral payload remains the shared path used by the WPF `RichTextBox` adapter and the
Avalonia native-input/custom-rich-surface editor.

## Preserved model state

The version-2 payload preserves every inline effect property currently present on
`FreeP.Core.Model.Run`:

- `TextFill`: `None`, solid, multi-stop linear/radial gradient, picture, and pattern fills,
  including colors, theme references, alpha, gradient stops/kind/angle, image bytes/content type,
  tiling, and pattern colors.
- `TextOutline`: `None`, visible, and gradient-visible outlines, including width, dash style,
  gradient metadata, and both line-end markers.
- `TextShadow`: color/theme reference, alpha, blur, distance, and direction.
- `TextReflection`: alpha, blur, distance, direction, vertical scale, and fade end position.
- `TextGlow`: color/theme reference, alpha, and radius.
- `TextSoftEdge`: radius.

The cloner deep-copies these polymorphic values, nested theme colors, gradient stops, line ends,
and picture bytes before an edit or clipboard fragment can be mutated independently.

## Host behavior

- Avalonia captures effects directly from its renderer-neutral edit buffer and writes the same
  payload bytes to both its application and platform clipboard formats.
- WPF `FlowDocument` has no native DrawingML effect representation. When a reconstructed inline is
  matched to an unchanged source run, the WPF converter carries the source effect state forward
  before the shared codec captures it. This prevents a WPF copy or cut from erasing effects.
- WPF paste and Avalonia paste both apply the shared decoded fragment, so cut/paste preserves the
  same effect objects across hosts.

## Compatibility

The serialized payload is now version 2. Deserialization continues to accept version-1 payloads;
their missing effect properties remain null, while all existing formatting, hyperlink, field,
math, paragraph, and list data continues to decode as before. The clipboard format identifier is
unchanged so existing v1 peers still reach the compatibility decoder.

## Verification

- `FreeP.App.Presentation.Tests`: 5 `InCanvasRichClipboardTests` passed, including exhaustive
  effect/fill/outline round-trip, deep-copy isolation, and version-1 compatibility.
- `FreeP.App.Host.Tests`: 3 `WpfRichTextClipboardAdapterTests` passed, including WPF effect
  preservation through `FlowDocument` capture.
- `FreeP.App.Rendering.Avalonia.Tests`: 12 `AvaloniaRichTextEditorTests` passed, including
  effect capture from the Avalonia editor buffer.
- `FreeP.App.Presentation` Release build passed with zero warnings and zero errors.

All direct dotnet commands used the required serialized/no-build-server flags. No background
builds, machine-wide process kills, Claude changes, or main-branch integration were performed.

## Remaining boundaries

This closes modeled inline-effect preservation inside FreeP's interoperable payload. Avalonia
still does not import arbitrary external RTF/XamlPackage content, and broader IME/RTL behavior,
native framework-editor differences, and PowerPoint-authoritative rich-editor visual baselines
remain separate parity work.
