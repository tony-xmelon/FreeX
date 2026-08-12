# FreeW Shared Rich Clipboard Parsing, Wave 169

Date: 2026-08-12
Priority: functional parity and renderer thinning

## Gap

WPF and Avalonia each owned an identical 25-line `TryReadRtfClipboardDocument` implementation in
their large `DocumentView` renderer files. Both adapters independently chose Latin-1 clipboard
byte preservation, invoked `RtfReader`, rejected empty results, and handled the same parse
exceptions. The policy was portable model/IO behavior, not platform rendering or clipboard API
glue.

The duplication made rich-paste behavior liable to drift: changing malformed-input handling,
source code-page preservation, or acceptance criteria in one renderer did not require the other
renderer to change.

## Change

`FreeW.App.Presentation.DocumentView.RichClipboardDocumentPlanner` now owns the RTF clipboard
conversion policy. WPF retains only `System.Windows.Clipboard` access and passes the resulting
string to the planner. Avalonia retains only `IDataObject` access and does the same. Both
renderer-local parser implementations were deleted.

The shared contract preserves the existing behavior exactly:

- null, empty, and whitespace clipboard values are rejected;
- RTF code units are converted through Latin-1 so `RtfReader` can interpret source code pages;
- parsed rich runs, paragraphs, and tables remain model-owned;
- invalid-data and argument failures return `false` without changing the output document.

Existing WPF and Avalonia regression tests now target the shared planner. A portable test pins
Windows-1252 byte decoding, bold/italic run formatting, paragraph boundaries, rejection behavior,
and the architectural rule that neither renderer calls `RtfReader` directly.

## Verification

- Focused portable planner tests: 5/5 passed.
- Full `FreeW.App.Presentation.Tests`: 1372/1372 passed.
- WPF app and test assemblies: Release build passed, zero warnings/errors.
- Avalonia app and test assemblies: Release build passed, zero warnings/errors.
- Repository preflight passed.
- Full `FreeX.slnx` Release build passed with zero warnings and zero errors.
- No UI tests or visual capture hosts were run.
