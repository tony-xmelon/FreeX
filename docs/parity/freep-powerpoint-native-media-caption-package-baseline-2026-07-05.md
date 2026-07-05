# FreeP PowerPoint-Native Media Caption Package Baseline - 2026-07-05

This slice adds a focused no-COM package baseline for PowerPoint-style media captions. It is separate from FreeP-generated presenter recording WebVTT artifacts.

Covered:

- A PowerPoint-authored media shape with a slide relationship of type `http://schemas.microsoft.com/office/2011/relationships/mediaCaption` is read into `MediaCaptionTrackInfo`.
- The original caption sidecar bytes from `ppt/media/captions1.vtt` are captured by the package snapshot and retained through a modeled slide edit.
- Save output writes a PowerPoint-style `p20media:caption` element with `r:embed`, `lang`, and `label` metadata plus a slide relationship to the regenerated caption package part.
- `[Content_Types].xml` includes the `vtt` default content type as `text/vtt`.
- Native media caption packages do not create `ppt/media/recordingArtifacts.xml` or entries under `ppt/media/recording-captions/`, keeping this contract distinct from FreeP recording artifact authoring.

Validation:

- `freep/FreeP.App.Host.Tests/MediaFieldsTests.cs`
- Test: `Media_PowerPointNativeCaptionPackage_ReadSaveReopen_PreservesBytesAndRelationshipContract`

Remaining:

- PowerPoint COM-backed recording capture baselines are still needed for actual Microsoft PowerPoint narration/camera workflows.
- Real microphone/camera device adapters remain outside this package baseline.
