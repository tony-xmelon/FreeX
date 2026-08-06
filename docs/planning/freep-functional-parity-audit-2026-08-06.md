# FreeP Functional Parity Audit - 2026-08-06

This is a current-main function-first correction to older FreeP parity handoff notes. It is not a claim of full Microsoft PowerPoint parity and intentionally does not reopen the visual-fidelity lane.

## Verified Current Paths

- Windows video export has a real `MediaComposition` path. It consumes the shared PNG frame package, adds delayed narration tracks, adds captured camera video as picture-in-picture overlays, renders MP4, and validates `ftyp`/`moov`/`mdat` output.
- WPF delegates to that Windows encoder when the capability reports `windows-media-composition`.
- Avalonia uses the same Windows encoder on Windows and keeps the ffmpeg path on Linux.
- Windows OLE in-place activation exists in the WPF host and in the Avalonia Windows native-control bridge. Portable and non-Windows routes retain the external-file activation fallback.
- Recording artifacts and PowerPoint media-caption sidecars are retained in the presentation model and PPTX package. They are not silently discarded on save.

Focused current-main verification on `424a2bf0f5`:

| Area | Result |
| --- | ---: |
| Recording backend/native output contracts | 21/21 |
| WPF video export adapter | 7/7 |
| Avalonia Windows print/video handoff | 7/7 |
| Shared Backstage evidence planner | 2/2 |

## Actual Remaining Function Boundaries

- Live microphone/camera capture still depends on OS devices, permissions, and host session state; deterministic injected payloads are not a substitute for live-device evidence.
- Recording caption artifacts are preserved and planned as media metadata. The ffmpeg mux path now materializes the package-owned WebVTT tracks as slide-offset timed `mov_text` streams; the Windows `MediaComposition` path remains bounded because its current API adapter has no timed-text stream implementation.
- Native printer-dialog execution remains host/driver dependent even though print packages and physical page ranges are implemented.
- PowerPoint-authoritative COM recording/export baselines and broader real-deck media/caption baselines remain external evidence work.
- Advanced chart families, deep animation authoring/playback semantics, and other package features explicitly marked unsupported remain bounded feature-depth work.

The current command-surface inventory has no actionable WPF/Avalonia command-id gap. The remaining work is therefore depth, external capability, and package/media execution rather than another missing ribbon route. Visual parity work stays paused at the user's direction.

