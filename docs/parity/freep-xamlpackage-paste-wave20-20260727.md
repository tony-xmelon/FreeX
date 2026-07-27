# FreeP XamlPackage Paste, Wave 20

## Scope

Avalonia now consumes the common FlowDocument subset carried by WPF's native `XamlPackage`
clipboard format. This closes the cross-host gap where a rich copy from WPF or another WPF
editor degraded directly to plain text in the Avalonia in-canvas editor.

## Behavior

- Clipboard precedence is now FreeP custom v2, XamlPackage, external RTF, then Unicode text.
- The shared bounded package reader discovers XAML document parts inside the ZIP package and
  preserves FlowDocument paragraphs, runs, spans, bold/italic/underline/strikethrough,
  foreground colors, font family/size, paragraph alignment, and common margin spacing.
- WPF's existing native `RichTextBox` publisher is unchanged. Its adapter now uses the same
  shared XamlPackage projection before its RTF fallback, keeping both hosts on one model path.
- Malformed, oversized, resource-only, or unsupported packages return null and continue through
  the existing RTF/plain-text fallback without throwing. Package resources and FlowDocument
  tables/objects are intentionally outside this bounded model projection.

## Verification

- `FreeP.App.Presentation.Tests`: 11 focused external-rich-clipboard tests passed.
- `FreeP.App.Rendering.Avalonia.Tests`: 17 focused rich-editor tests passed.
- `FreeP.App.Host.Tests`: 7 focused WPF rich-clipboard adapter tests passed.
- Shared Presentation Release build completed with zero warnings and zero errors.

This is a functional interoperability slice; it does not claim PowerPoint-authoritative rich
editor raster parity or preservation of XamlPackage resource objects.
