# FreeP External RTF Embedded Objects

## Scope

External RTF object groups now preserve their object-data bytes and object
class/file hint through the shared clipboard payload. WPF and Avalonia paste
the payload as an editable SlideShapeKind.Ole while retaining the visible
result-text projection.

Older internal clipboard payloads remain valid because the object list is an
optional field in the existing version-2 JSON payload.

## Verification

- ExternalRichTextClipboardTests: 21/21
- OsClipboardServiceTests.Paste_ExternalRtfObject...: 1/1
- PresentationClipboardInteropTests.External_Rtf_object...: 1/1
- FreeP.App.Avalonia.Tests Release build: 0 warnings, 0 errors
- Existing OLE package round-trip coverage remains in OleMathRoundTripTests
  and SlideObjectInsertionPlannerTests.

The supported slice is intentionally limited to bounded RTF object-data
payloads. PowerPoint-authoritative external RTF visual baselines remain a
separate evidence task.
