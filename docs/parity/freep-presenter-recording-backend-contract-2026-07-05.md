# FreeP Presenter Recording Backend Contract - 2026-07-05

This slice advances PowerPoint recording parity by replacing boolean-only narration/camera capture evidence with a shared recording capture backend contract in `FreeP.App.Presentation`.

Parity improved:

- `ISlideShowRecordingCaptureBackend` now defines the shared seam that WPF, Avalonia, or a future device service can implement for narration audio and camera video capture.
- Recording segments now carry package-ready captured media descriptors: suggested file name, content type, package path, byte length, SHA-256, and persistable/deferred state.
- `SlideShowRecordingReviewPlanner` and presenter session summaries now report captured, deferred, and PPTX-persistable media artifact counts.
- `SlideShowDeterministicRecordingCaptureBackend` provides hardware-free evidence for capture-backed transcript/review tests while real microphone/camera adapters remain unavailable.

Current adapter policy:

- WPF and Avalonia slideshow windows still register deferred host capabilities, so they do not claim real device capture.
- The shared backend contract is ready for thin host adapters to plug in actual microphone/camera capture and PPTX media authoring without duplicating presenter policy.

Remaining gaps:

- Real OS microphone/camera backend adapters are still needed.
- Captured narration/video bytes are not yet authored into PPTX media parts by the package writer.
- PowerPoint COM-backed recording baselines still require a COM-capable machine.
