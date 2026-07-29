# FreeP external RTF object-result paste

## Scope

External RTF embedded objects are not editable OLE payloads in the FreeP slide
model, but Word and Office producers commonly include a visible `\\result` or
`\\objresult` fallback beside the binary object data. The shared RTF planner now
suppresses object class/data destinations while routing that explicit fallback
through the normal formatted-text path.

This prevents an object paste from silently dropping user-visible content. The
existing validated PNG/JPEG `\\pict` extraction remains unchanged, including its
slide-level picture fallback.

## Verification

- `ExternalRichTextClipboardTests`: 20/20.
- WPF `Paste_ExternalRtfObject_UsesVisibleResultText`: 1/1.
- WPF `OsClipboardServiceTests`: 44/44.
- The host Release build completed with 0 warnings and 0 errors.

## Boundary

The binary OLE payload is intentionally not activated or embedded as an editable
PowerPoint object. Unsupported object data still degrades safely to its visible
result when the producer supplies one; objects without a visible result remain
non-editable and are ignored.
