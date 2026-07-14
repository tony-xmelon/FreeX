# FreeP Presenter Recording Camera Handoff - 2026-07-14

This slice advances the remaining FreeP presenter recording parity item for camera/video capture without claiming PowerPoint COM baselines or unavailable hardware proof.

Parity improved:

- WPF and Avalonia Windows recording device catalogs now surface camera descriptors through guarded Windows device-interface enumeration alongside microphone descriptors.
- The shared `SlideShowRecordingCaptureAdapterReadiness` and `SlideShowRecordingHostAdapterParityPlanner` contracts now distinguish paired camera handoff readiness from paired microphone narration handoff.
- WPF and Avalonia host recording backends now route camera start/complete requests through the same capture seam as narration, using `ppt/media/freep-recordings/{host}/slide-###-camera.mp4` package paths and `video/mp4` content type.
- Focused backend tests prove WPF and Avalonia can produce package-ready camera video artifacts when a host engine supplies payload bytes.
- The default no-COM Windows camera engine path records that camera device handoff was reached, then defers encoded video payload capture honestly.

Explicitly deferred:

- Live camera hardware capture and encoded video payload generation remain deferred unless a real host capture engine supplies bytes.
- PowerPoint COM-backed recording baselines remain deferred for a COM-capable machine.
- Broader real-deck PowerPoint-native media/caption corpus baselines remain deferred.

Verification:

- `freep/FreeP.App.Presentation.Tests/SlideShowRecordingHostAdapterParityPlannerTests.cs`
- `freep/FreeP.App.Host.Tests/WpfWindowsRecordingCaptureBackendTests.cs`
- `freep/FreeP.App.Avalonia.Tests/AvaloniaWindowsRecordingCaptureBackendTests.cs`
