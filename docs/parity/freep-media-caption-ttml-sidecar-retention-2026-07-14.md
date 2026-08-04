# FreeP TTML Caption Sidecar Retention - 2026-07-14

Scope: bounded FreeP media/caption package evidence for PowerPoint-authored TTML caption sidecars. This is no-COM WPF/Avalonia parity evidence through the shared PPTX reader/writer and transcript planner; it does not claim a PowerPoint-native visual or playback baseline.

Evidence added:

- `freep/FreeP.App.Host.Tests/MediaFieldsTests.cs` now covers a PowerPoint-style media shape with an internal `mediaCaption` relationship targeting `ppt/media/ttml/native-caption.ttml`.
- The fixture carries an explicit `application/ttml+xml` content-type override and TTML payload bytes.
- After a modeled slide edit, FreeP preserves the original sidecar path, bytes, relationship id, relationship target, `p20media:caption` metadata, and content-type override.
- The sidecar remains separate from FreeP generated recording artifacts: no `ppt/media/recordingArtifacts.xml` and no `ppt/media/recording-captions/` entries are written.
- The shared transcript planner recognizes basic TTML/DFXP sidecars, parses authored paragraph cues with clock or unit timing, and preserves the native package payload unchanged.

Update 2026-07-20:

- Focused planner coverage proves clock timing, `dur` timing, nested-span text flattening, and whitespace normalization for imported TTML cues.
- The host package round-trip test proves a PowerPoint-style native TTML caption remains byte-identical while planning as an available one-cue transcript after load and save.

Update 2026-08-04:

- Internal caption replacement now preserves the existing WebVTT, SRT, TTML, or DFXP
  format, package path, and relationship id unless an explicit supported source path
  selects another format.
- New internal tracks continue to default to WebVTT. TTML output is generated through
  the shared planner with XML escaping and is immediately consumable by the existing
  TTML transcript path.

Remaining gaps:

- No local PowerPoint COM caption/playback baseline is available on this machine.
- Real-deck PowerPoint-native media/caption corpus breadth is still deferred.
- TTML visual styling/layout semantics and PowerPoint-authoritative caption baselines remain
  deferred. Frame/tick rates, inherited timing contexts, playback, and native format-preserving
  internal authoring are covered by the shared planner/package paths.
