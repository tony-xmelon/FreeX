# FreeP Presenter Recording Unavailable Hardware Readiness - 2026-07-14

This no-COM slice strengthens the unavailable-hardware presenter recording evidence without claiming live microphone/camera capture.

What is now proved:

- WPF and Avalonia Windows recording adapters can both report an OS-backed no-device state when no microphone or camera devices are available.
- The shared `SlideShowRecordingUnavailableHardwareEvidence` contract distinguishes paired unavailable hardware from an unregistered/deferred capture adapter.
- The evidence rows require no ready streams, both narration and camera streams marked missing, no device descriptors, and no capture payload.
- The slice explicitly does not claim encoded `.mp4` camera bytes, live hardware success, or Microsoft PowerPoint COM recording baselines.

Focused evidence:

- `freep/FreeP.App.Presentation/SlideShowRecordingHostAdapterParityPlanner.cs`
- `freep/FreeP.App.Presentation.Tests/SlideShowRecordingHostAdapterParityPlannerTests.cs`
- `freep/FreeP.App.Host.Tests/WpfWindowsRecordingCaptureBackendTests.cs`
- `freep/FreeP.App.Avalonia.Tests/AvaloniaWindowsRecordingCaptureBackendTests.cs`

Explicitly deferred:

- Live capture and permission UX on a host with physical microphone/camera devices.
- Actual local default no-COM camera video encoding that produces non-empty `.mp4` payload bytes.
- PowerPoint COM recording baselines.
- Broader real-deck PowerPoint-native media/caption corpus baselines.
