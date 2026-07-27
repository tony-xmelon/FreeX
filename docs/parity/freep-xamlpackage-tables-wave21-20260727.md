# FreeP XamlPackage Table Paste Wave 21

Date: 2026-07-27

## Function slice

WPF `XamlPackage` clipboard payloads can contain a `FlowDocument` table. The shared
external clipboard planner now projects those tables into the same tab-delimited rows
already used by the RTF path, preserving inline run formatting and cell paragraph line
breaks. Paragraphs outside the table retain their original order and paragraph settings.

The projection is intentionally bounded: rows with more than 4096 cells are rejected as
untrusted input, and the existing package, XML, and output-character limits still apply.
This keeps WPF and Avalonia on one renderer-neutral text-editor contract without inventing
an inline table model for `TextBody`.

## Verification

- `ExternalRichTextClipboardTests`: 13/13
- `WpfRichTextClipboardAdapterTests`: 7/7
- `AvaloniaRichTextEditorTests`: 17/17
- Presentation, WPF host, and Avalonia rendering Release test builds: clean, 0 warnings/errors
- `git diff --check`: clean

## Remaining scope

XamlPackage embedded images, resource dictionaries, controls, and full FlowDocument table
geometry remain outside the text-editor projection. They require a shape/inline-object
clipboard contract rather than silently discarding them into plain text.
