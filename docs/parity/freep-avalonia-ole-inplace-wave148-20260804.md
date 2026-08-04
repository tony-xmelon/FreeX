# FreeP Avalonia OLE In-Place Editing, Wave 148

## Mismatch

WPF handled a double-click on an embedded OLE shape through `WpfOleInPlaceHost` before falling back to `OleActivationService`. Avalonia's canvas handler called the external activation service directly, even though Avalonia already had a Windows `NativeControlHost` implementation for inline OLE runs. That made embedded Excel/Word/PowerPoint objects open externally instead of entering the slide surface when their registered OLE server supported in-place activation.

## Change

Avalonia now mirrors the WPF route for unrotated, unflipped OLE shapes. A stage-level native OLE overlay hosts the embedded server, commits edited bytes back to the existing `OleObjectInfo.EmbeddedBytes` payload, and closes before slide/editor refreshes. If native creation declines or fails, the host invokes the existing external activation fallback. Unsupported rotations/flips continue to use external activation without flattening the fallback picture or native package payload.

## Evidence

- `AvaloniaOleActivationRoutingTests` covers in-place-first routing and external fallback behavior.
- Existing `OleMathRoundTripTests` covers exact OLE embedded-byte PPTX round-trip and ZIP emission.
- Focused Release commands and results are recorded in the Wave 148 task handoff.
