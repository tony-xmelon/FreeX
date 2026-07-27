# FreeP Slide-Level Rich Clipboard Paste Wave 22

Date: 2026-07-27

## Function slice

The Windows clipboard bridge already captured FreeP RichText and WPF XamlPackage payloads,
but slide-level Paste only considered native selection, image, and plain text. It now routes
valid RichText payloads first, then XamlPackage FlowDocument payloads, into one undoable text-box
insertion. The inserted shape clones the shared `TextBody`, so run formatting, paragraph
properties, and the tab-delimited XamlPackage table projection survive the clipboard boundary.

Existing precedence remains: current in-app selection, external native selection, image, rich
text, XamlPackage, plain text, then internal clipboard fallback. Invalid rich payloads fall back
through the same chain rather than blocking Paste.

## Verification

- Shared clipboard planner and model path covered by host tests.
- WPF `OsClipboardServiceTests`: focused Release run covers rich-text and XamlPackage insertion.
- Existing image, native-selection, text, and internal clipboard precedence remains covered.
- Rich text is inserted through the existing `AddShapeCommand` path, preserving undo behavior.

## Remaining scope

XamlPackage embedded images, resource dictionaries, and arbitrary FlowDocument controls still
need a shape/inline-object clipboard contract. They are not silently converted into a text box.
