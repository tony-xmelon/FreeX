# FreeP Avalonia Windows capture capability

## Scope

Avalonia's Windows video-export projection previously treated MediaComposition as proof that
narration and camera capture were available. It now consumes device-backed microphone and camera
flags from the shared Windows capability record, matching the WPF host's readiness contract.

Encoder availability and export behavior are unchanged. A missing device is reported as an
unavailable capture feature rather than as a selectable but nonfunctional workflow.

## Verification

- Windows capability device-present and device-absent tests cover microphone and camera flags.
- Existing Windows native print/video handoff tests remain in the same Avalonia test class.
- No rendering or PowerPoint raster-fidelity claim is made by this slice.
