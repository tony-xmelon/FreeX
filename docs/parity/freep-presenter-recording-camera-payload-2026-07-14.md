# FreeP Presenter Recording Camera Payload Evidence - 2026-07-14

This slice proves the bounded no-COM camera media payload path for FreeP presenter recording:

- WPF and Avalonia Windows recording capture backends can accept deterministic encoded camera bytes from their host capture engines.
- The shared recording execution planner carries those bytes as `CameraVideo` media artifacts with host-specific package paths under `ppt/media/freep-recordings/wpf/` and `ppt/media/freep-recordings/avalonia/`.
- The shared recording review planner applies those persistable artifacts into `Presentation.RecordingMediaArtifacts`.
- The PPTX writer emits the `.mp4` payload entries plus `ppt/media/recordingArtifacts.xml`, and the PPTX reader reloads matching bytes, content type, length, SHA-256, and package paths.
- The shared readiness planner separately reports paired deterministic encoded-payload evidence from handoff-only default-engine rows, so this package proof does not claim real camera hardware encoding.

Focused evidence:

- `freep/FreeP.App.Host.Tests/WpfWindowsRecordingCaptureBackendTests.cs`
- `freep/FreeP.App.Avalonia.Tests/AvaloniaWindowsRecordingCaptureBackendTests.cs`
- `freep/FreeP.App.Presentation.Tests/SlideShowRecordingHostAdapterParityPlannerTests.cs`

Deferred honestly:

- Live unavailable-hardware capture UX and permission/error evidence.
- Default no-COM WPF/Avalonia camera encoding readiness is covered as handoff-only evidence in `docs/parity/freep-presenter-recording-default-camera-encoding-readiness-2026-07-14.md`; actual local real camera device encoding that produces non-empty `.mp4` payload bytes remains deferred.
- PowerPoint COM recording baselines.
- Broader real-deck PowerPoint-native media/caption corpus baselines.
