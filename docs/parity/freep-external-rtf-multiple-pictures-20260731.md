# FreeP external RTF multiple-picture parity

## Scope

External RTF paste previously retained only the first valid `\\pict` payload. The shared
clipboard payload now preserves every valid PNG or JPEG picture in source order, carries the
list through the in-app JSON clipboard contract, and both WPF and Avalonia paste adapters create
one editable picture shape per payload before the formatted text/table fragment.

The original `ImageBytes` and `ImageContentType` fields remain populated from the first image for
compatibility with existing callers. Exact inline picture-run anchoring is intentionally outside
this slice because the current slide model represents pasted pictures as separate shapes.

## Verification

- `ExternalRichTextClipboardTests`: 21/21
- `OsClipboardServiceTests`: 45/45
- `PresentationClipboardInteropTests`: 27/27
- `FreeP.App.Host` Release build: 0 warnings, 0 errors
- `FreeP.App.Avalonia` Release build: 0 warnings, 0 errors
