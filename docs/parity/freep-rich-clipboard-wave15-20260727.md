# FreeP Rich Clipboard Wave 15

Date: 2026-07-27

## Scope

This slice covers copy, cut, and paste inside FreeP's in-canvas rich text editors. The WPF baseline is `RichTextBox`/`FlowDocument`; the shared payload is renderer-neutral and lives in `FreeP.App.Presentation`.

## Behavior delivered

- Avalonia's transparent `TextBox` editor intercepts Ctrl+C, Ctrl+X, and Ctrl+V. Internal FreeP clipboard bytes preserve modeled run formatting, paragraph alignment and list metadata, soft-break runs, hyperlinks, fields, math metadata, colors including scheme references, bullet images, tab stops, and the captured typing run.
- Avalonia also publishes ordinary Unicode text and accepts ordinary text from the native clipboard. External rich formats therefore have a predictable plain-text fallback.
- WPF shape and table-cell editors use the same payload for copy, cut, and paste. WPF additionally publishes RTF, XamlPackage, and Unicode text so existing `RichTextBox` and Office interoperability remains available when the FreeP payload is absent.
- Paste replaces the current logical selection, applies the source fragment's first paragraph metadata at the insertion boundary, preserves the remaining destination content, and returns a logical caret position. Plain-text paste creates paragraphs and uses the current typing style.

## Verification

- `FreeP.App.Presentation.Tests`: 27 focused tests passed, including planner/model round trips and rich insertion behavior.
- `FreeP.App.Avalonia.Tests`: 18 clipboard interop tests passed.
- `FreeP.App.Rendering.Avalonia.Tests`: 11 focused editor tests passed.
- `FreeP.App.Host.Tests`: 87 existing clipboard/editor tests passed; 2 WPF rich clipboard adapter tests passed.
- `FreeP.App.Rendering.Wpf` Release build passed with zero warnings and zero errors.

All direct dotnet commands used the required single-process/no-build-server flags. No background build was started.

## Honest residuals

- Avalonia now consumes the bounded shared external RTF and XamlPackage FlowDocument projections before falling back to Unicode text. Unsupported external controls, resource dictionaries, richer FlowDocument behavior, and inline picture/object runs remain outside the renderer-neutral rich-editor model. WPF continues to publish and consume its native rich formats when no FreeP payload is present.
- Advanced polymorphic run effects (`TextFill`, `TextOutline`, shadow, reflection, glow, and soft-edge models) are not serialized in the bounded v1 payload.
- IME composition, RTL editing, and platform-specific clipboard ownership remain delegated to the native Avalonia `TextBox` or WPF `RichTextBox` and are not claimed as cross-renderer parity.
- This slice is covered by model, host, and focused renderer tests; it does not claim a new Linux/Docker visual screenshot baseline.
