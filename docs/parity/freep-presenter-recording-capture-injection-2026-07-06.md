# FreeP Presenter Recording Capture Injection - 2026-07-06

This slice advances presenter recording parity by letting both slideshow hosts consume the shared `ISlideShowRecordingCaptureBackend` contract instead of being hard-wired to deferred microphone/camera readiness.

Parity improved:

- WPF and Avalonia slideshow windows now keep their public default deferred behavior, but expose internal constructor paths for an injected shared capture backend.
- Paired WPF/Avalonia tests use `SlideShowDeterministicRecordingCaptureBackend` to prove a ready capture adapter flows through host readiness, recording execution, review rows, and close-time recording artifact persistence.
- The captured-media path now has host evidence beyond the shared planner: both shells can persist package-ready narration/camera artifacts when a backend supplies captured payloads.

Current adapter policy:

- Default WPF and Avalonia app launches still report deferred microphone/camera capture until a real OS capture backend is registered.
- The new host seam is ready for a device-backed microphone/camera adapter without duplicating recording policy in either shell.

Remaining gaps:

- Real OS microphone/camera backend adapters are still needed.
- PowerPoint COM-backed recording capture baselines still require a COM-capable machine.
- Broader real-deck PowerPoint-native media/caption corpus baselines remain deferred.
