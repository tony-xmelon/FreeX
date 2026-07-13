# FreeP Media Caption Content-Type Depth - 2026-07-14

This bounded no-COM slice deepens PowerPoint-native media caption package fidelity for the shared WPF/Avalonia FreeP PPTX path.

Covered:

- Caption sidecar content types are now read from `[Content_Types].xml` overrides before falling back to extension defaults.
- PowerPoint-authored caption parts with native override content types, such as `application/vnd.ms-powerpoint.media.caption+vtt`, keep that package metadata in `MediaCaptionTrackInfo`.
- The shared transcript planner receives the retained content type while still using caption bytes and source extension to build available transcript descriptors.
- Save/reopen continues to preserve the original caption sidecar path, bytes, relationship target, and content-type override without creating FreeP recording artifact manifests.

Validation:

- `freep/FreeP.App.Host.Tests/MediaFieldsTests.cs`
- Test: `Media_PowerPointNativeCaptionPackage_PreservesCaptionSidecarContentTypeOverride`

Remaining:

- This is a synthetic package baseline, not a Microsoft PowerPoint COM-backed baseline.
- Broader real-deck PowerPoint-native media/caption package baselines still need representative authored decks.
- Real microphone and camera capture implementations remain separate follow-up work.
