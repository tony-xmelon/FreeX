# FreeP Presenter Recording Media Artifact Manifest - 2026-07-05

This slice advances presenter recording/media backend depth by carrying package-ready recording artifact metadata out of transient slideshow review state and into the shared `Presentation` model. It now includes generated WebVTT narration/camera caption artifacts alongside captured media payload artifacts.

Parity improved:

- `Presentation.RecordingMediaArtifacts` now stores persisted narration/camera artifact descriptors: kind, source slide, suggested file name, content type, package path, byte length, SHA-256, duration, host, and status.
- `SlideShowRecordingReviewPlanner.ApplyPersistableArtifacts` projects only truly persistable recording media and caption artifacts into the shared model, so WPF and Avalonia route through the same policy.
- Recording review rows now generate package-ready WebVTT narration/camera caption payloads under `ppt/media/recording-captions/` when the backing narration/camera artifact is captured.
- `PptxPackageWriter` writes the manifest to `ppt/media/recordingArtifacts.xml`, materializes captured payload bytes at their declared `ppt/media/...` package paths, and `PptxPackageReader` reloads both metadata and payload bytes without requiring local PowerPoint COM.
- WPF and Avalonia slideshow teardown both call the shared planner. Their current deferred capture adapters still do not claim fake persisted media artifacts.
- PowerPoint-native media caption package coverage is tracked separately in `docs/parity/freep-powerpoint-native-media-caption-package-baseline-2026-07-05.md`; this manifest remains the FreeP-generated recording artifact contract.

Remaining gaps:

- Real OS microphone/camera adapters are still needed.
- PowerPoint COM-backed recording capture baselines are still needed for recorded narration/video review workflows.
- PowerPoint-authoritative recording media baselines still require a COM-capable PowerPoint lane.
- Real microphone/camera adapters remain deferred; the covered path is package authoring for captured backend payloads.
