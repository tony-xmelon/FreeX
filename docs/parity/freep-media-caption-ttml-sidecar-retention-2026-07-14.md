# FreeP TTML Caption Sidecar Retention - 2026-07-14

Scope: bounded FreeP media/caption package evidence for PowerPoint-authored TTML caption sidecars. This is no-COM WPF/Avalonia parity evidence through the shared PPTX reader/writer and transcript planner; it does not claim a PowerPoint-native visual or playback baseline.

Evidence added:

- `freep/FreeP.App.Host.Tests/MediaFieldsTests.cs` now covers a PowerPoint-style media shape with an internal `mediaCaption` relationship targeting `ppt/media/ttml/native-caption.ttml`.
- The fixture carries an explicit `application/ttml+xml` content-type override and TTML payload bytes.
- After a modeled slide edit, FreeP preserves the original sidecar path, bytes, relationship id, relationship target, `p20media:caption` metadata, and content-type override.
- The sidecar remains separate from FreeP generated recording artifacts: no `ppt/media/recordingArtifacts.xml` and no `ppt/media/recording-captions/` entries are written.
- The shared transcript planner surfaces the track as `UnsupportedFormat` with no cues instead of misclassifying the TTML payload as WebVTT/SRT.

Remaining gaps:

- No local PowerPoint COM caption/playback baseline is available on this machine.
- Real-deck PowerPoint-native media/caption corpus breadth is still deferred.
- TTML transcript parsing/rendering remains intentionally unsupported; this slice only proves package retention and honest presenter metadata.
