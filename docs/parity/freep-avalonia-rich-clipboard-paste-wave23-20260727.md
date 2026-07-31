# FreeP Avalonia Rich Clipboard Paste Wave 23

Date: 2026-07-27

## Function slice

Avalonia already published and read the shared RichText and WPF XamlPackage clipboard formats,
but its slide-level paste service considered only native selection, image, and plain text. It now
uses the same precedence and shared `TextBody` insertion path as WPF: in-app selection, native
selection, image, RichText, XamlPackage, plain text, and internal fallback.

RichText and XamlPackage payloads become one undoable text-box shape with run formatting,
paragraph structure, and tab-delimited table rows retained. Invalid payloads continue through
the existing fallback chain.

## Verification

- Avalonia `PresentationClipboardInteropTests`: 21/21
- New cases cover RichText precedence, formatting retention, XamlPackage table projection,
  and existing native/image/text/internal routes remain green.
- Avalonia Release test build: clean, 0 warnings/errors.

## Remaining scope

XamlPackage image payloads are now preserved for slide-level picture insertion in both hosts.
Resource dictionaries, arbitrary FlowDocument controls, and inline picture/object runs inside
the renderer-neutral rich editor still need a richer object contract.
