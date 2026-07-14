# FreeP Presenter Recording Default Camera Encoding Readiness - 2026-07-14

This slice advances the local default no-COM camera recording evidence without claiming that the host can encode real camera video yet.

What is now proved:

- WPF and Avalonia both route default Windows camera capture through the shared recording planner and host recording adapters.
- Both default no-COM camera engines reach camera device handoff and preserve stable `video/mp4` package targets under `ppt/media/freep-recordings/{host}/slide-###-camera.mp4`.
- The shared `SlideShowRecordingCameraEncodingReadinessEvidence` contract records the paired handoff as readiness evidence only when the row has no encoded payload and does not require or claim PowerPoint COM.
- Existing deterministic host-engine tests continue to prove package-ready `.mp4` persistence when a capture engine supplies bytes, while this default-engine slice keeps local real camera encoding separate.

Focused evidence:

- `freep/FreeP.App.Presentation/SlideShowRecordingHostAdapterParityPlanner.cs`
- `freep/FreeP.App.Presentation.Tests/SlideShowRecordingHostAdapterParityPlannerTests.cs`
- `freep/FreeP.App.Host.Tests/WpfWindowsRecordingCaptureBackendTests.cs`
- `freep/FreeP.App.Avalonia.Tests/AvaloniaWindowsRecordingCaptureBackendTests.cs`

Explicitly deferred:

- Actual local default no-COM real camera video encoding that produces non-empty `.mp4` payload bytes.
- Live unavailable-hardware and permission UX evidence on a machine with physical capture devices.
- PowerPoint COM recording baselines.
- Broader real-deck PowerPoint-native media/caption corpus baselines.
