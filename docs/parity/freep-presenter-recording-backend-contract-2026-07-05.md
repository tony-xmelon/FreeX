# FreeP Presenter Recording Backend Contract - 2026-07-05

This slice advances PowerPoint recording parity by replacing boolean-only narration/camera capture evidence with a shared recording capture backend contract in `FreeP.App.Presentation`.

Parity improved:

- `ISlideShowRecordingCaptureBackend` now defines the shared seam that WPF, Avalonia, or a future device service can implement for narration audio and camera video capture.
- Recording segments now carry package-ready captured media descriptors: suggested file name, content type, package path, byte length, SHA-256, and persistable/deferred state.
- `SlideShowRecordingReviewPlanner` and presenter session summaries now report captured, deferred, and PPTX-persistable media artifact counts.
- `SlideShowDeterministicRecordingCaptureBackend` provides hardware-free evidence for capture-backed transcript/review tests while real microphone/camera adapters remain unavailable.

Current adapter policy:

- WPF and Avalonia slideshow windows still register deferred host capabilities by default, so normal app launch does not claim real device capture.
- Both slideshow hosts can now consume an injected `ISlideShowRecordingCaptureBackend`; paired host tests use the deterministic backend to prove captured narration/camera payloads flow through review and persistence.
- The shared backend contract is ready for thin OS adapters to plug in actual microphone/camera capture without duplicating presenter policy.

Remaining gaps:

- Real OS microphone/camera backend adapters are still needed.
- PowerPoint COM-backed recording baselines still require a COM-capable machine.
