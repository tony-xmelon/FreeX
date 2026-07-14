# FreeP Media Caption Shared Sidecar Retention - 2026-07-14

This bounded no-COM slice deepens PowerPoint-native media caption package fidelity for the shared WPF/Avalonia FreeP PPTX path.

Covered:

- PowerPoint-authored caption sidecars reused by multiple media relationships now materialize once in the saved PPTX package.
- Multiple slide relationships can retain their original PowerPoint caption relationship ids while targeting the same native `ppt/media/...` WebVTT sidecar.
- Save/reopen keeps the shared sidecar path, bytes, relationship targets, labels, language metadata, and shared transcript-planner descriptors.
- The writer still avoids package-path collisions by generating a distinct caption part only when a modeled track wants to write different bytes to an already-written path.

Validation:

- `freep/FreeP.App.Host.Tests/MediaFieldsTests.cs`
- Test: `Media_PowerPointNativeCaptionPackage_SharedSidecarAcrossSlides_WritesOnePackagePart`

Remaining:

- This is a synthetic package baseline, not a Microsoft PowerPoint COM-backed baseline.
- Broader real-deck PowerPoint-native media/caption package baselines still need representative authored decks.
- Real microphone and camera capture implementations remain separate follow-up work.
