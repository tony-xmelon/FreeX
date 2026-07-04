# FreeP Presenter Recording Review Plan - 2026-07-04

This workflow-depth slice adds a shared recording review/apply plan after the
record/rehearse lifecycle work. It stays in FreeP shared presenter code plus
thin WPF/Avalonia host projections.

Parity improved:

- `SlideShowRecordingReviewPlanner` converts completed recording execution
  segments into renderer-neutral review rows with slide titles, durations,
  timing status, captured/deferred media artifact descriptors, and evidence
  lines.
- Recorded timing rows now distinguish preview-only rehearsal timings, timings
  ready to persist, timings already applied by the host, and missing-slide
  cases.
- WPF and Avalonia slideshow windows expose the same `RecordingReviewPlan`,
  including custom-show source-slide mapping, so hosts can build a PowerPoint-
  style recording review surface without duplicating planner policy.

Remaining gaps:

- Real microphone/camera capture adapters remain deferred.
- Captured narration/video media still is not authored back into PPTX media
  parts.
- PowerPoint-authoritative recording review and recording studio baselines
  still require a COM-capable machine.
