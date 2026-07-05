# FreeP Presenter Recording Media Artifact Manifest - 2026-07-05

This slice advances presenter recording/media backend depth by carrying package-ready recording artifact metadata out of transient slideshow review state and into the shared `Presentation` model.

Parity improved:

- `Presentation.RecordingMediaArtifacts` now stores persisted narration/camera artifact descriptors: kind, source slide, suggested file name, content type, package path, byte length, SHA-256, duration, host, and status.
- `SlideShowRecordingReviewPlanner.ApplyPersistableMediaArtifacts` projects only truly persistable recording artifacts into the shared model, so WPF and Avalonia route through the same policy.
- `PptxPackageWriter` writes the manifest to `ppt/media/recordingArtifacts.xml`, materializes captured payload bytes at their declared `ppt/media/...` package paths, and `PptxPackageReader` reloads both metadata and payload bytes without requiring local PowerPoint COM.
- WPF and Avalonia slideshow teardown both call the shared planner. Their current deferred capture adapters still do not claim fake persisted media artifacts.

Remaining gaps:

- Real OS microphone/camera adapters are still needed.
- The manifest records package-ready metadata, but captured narration/video bytes are still not authored as PPTX media parts.
- PowerPoint-authoritative recording media baselines still require a COM-capable PowerPoint lane.
- Real microphone/camera adapters remain deferred; the covered path is package authoring for captured backend payloads.
