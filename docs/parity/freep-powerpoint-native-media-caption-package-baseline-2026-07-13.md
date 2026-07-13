# FreeP PowerPoint-Native Media Caption Package Baseline - 2026-07-13

This bounded no-COM slice strengthens the shared WPF/Avalonia FreeP media-caption package contract without using Microsoft PowerPoint COM, microphone capture, or camera capture.

Covered:

- PowerPoint-authored internal caption sidecars keep their original `ppt/media/...` package path when the track is read from a source package and saved without re-authoring.
- PowerPoint-authored caption relationship ids are reused when they do not collide with writer-owned slide relationships, including non-FreeP ids such as `rIdPowerPointCaption42`.
- Nested native caption sidecar paths such as `ppt/media/captionTracks/en-US/native-captions.vtt` are preserved, and slide relationships target them with the correct relative OPC path.
- Caption `p20media:caption` metadata keeps the original embed relationship id, language, and label.
- Saved packages continue to exclude FreeP recording artifact manifests for native PowerPoint caption tracks.
- Reopened packages still feed `PresentationMediaTranscriptPlanner`, proving transcript descriptors are available from preserved native sidecar bytes.

Validation:

- `freep/FreeP.App.Host.Tests/MediaFieldsTests.cs`
- Test: `Media_PowerPointNativeCaptionPackage_ReadSaveReopen_PreservesBytesAndRelationshipContract`
- Test: `Media_PowerPointNativeCaptionPackage_WithMultipleCaptionTracks_PreservesCorpusRelationshipSet`
- Test: `Media_PowerPointNativeCaptionPackage_NestedSidecar_PreservesOriginalPathRelationshipIdAndTranscript`

Remaining:

- Broader real-deck PowerPoint-native media/caption package baselines still need representative authored decks.
- PowerPoint COM-backed recording/caption baselines remain deferred on this machine.
- Real microphone and camera capture implementations remain separate follow-up work.
