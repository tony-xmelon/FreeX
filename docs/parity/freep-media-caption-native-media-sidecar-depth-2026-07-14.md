# FreeP Media Caption Native Media Sidecar Depth - 2026-07-14

This bounded no-COM slice deepens PowerPoint-native media/caption package fidelity for the shared WPF/Avalonia FreeP PPTX path.

Covered:

- Imported embedded video media now records its original `ppt/media/...` package path in the shared model.
- Save after a modeled slide edit reuses the original embedded media sidecar path when the captured package bytes still match the model bytes.
- Nested PowerPoint-authored media paths and caption sidecar paths now keep their package entries, relationship targets, relationship ids, caption labels/languages, and shared transcript descriptors after save/reopen.
- Writer-owned media relationship targets now use the same relative-path helper as caption sidecars, so nested `ppt/media/...` package paths do not flatten during save.

Validation:

- `freep/FreeP.App.Host.Tests/MediaFieldsTests.cs`
- Test: `Media_PowerPointNativeMediaAndCaptionPackage_SemanticEdit_PreservesAuthoredSidecarPaths`
- Focused media/caption class: `MediaFieldsTests`
- Shared planner class: `PresentationMediaTranscriptPlannerTests`

Remaining:

- This is a synthetic package baseline, not a Microsoft PowerPoint COM-backed baseline.
- Broader real-deck PowerPoint-native media/caption package baselines still need representative authored decks from a COM-capable baseline host.
- Real microphone, camera, playback, and capture-device behavior remain host-adapter follow-up work.
