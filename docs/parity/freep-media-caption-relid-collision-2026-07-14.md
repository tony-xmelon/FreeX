# FreeP Media Caption Relationship-Id Collision Evidence - 2026-07-14

This bounded no-COM slice deepens PowerPoint-native media caption package fidelity for the shared WPF/Avalonia FreeP PPTX path.

Covered:

- A valid PowerPoint-style source package can use a caption relationship id that later collides with FreeP's generated poster-image relationship id during save.
- The PPTX writer keeps the native caption sidecar package path and bytes, remaps the caption relationship id away from the writer-owned media relationship id, and keeps all slide relationship ids unique.
- The `p20media:caption` metadata is retargeted to the remapped caption relationship id, so save/reopen still exposes the caption label, language, bytes, and shared transcript descriptor.
- The proof is package-level and renderer-neutral: WPF and Avalonia consume the same shared reader/writer model without host-specific media caption policy.

Validation:

- `freep/FreeP.App.Host.Tests/MediaFieldsTests.cs`
- Test: `Media_PowerPointNativeCaptionPackage_CollidingRelationshipId_RetargetsCaptionMetadata`

Remaining:

- This is a synthetic package baseline, not a Microsoft PowerPoint COM-backed baseline.
- Broader real-deck PowerPoint-native media/caption package baselines still need representative authored decks from a COM-capable baseline host.
- Real microphone, camera, playback, and capture-device behavior remain host-adapter follow-up work.
