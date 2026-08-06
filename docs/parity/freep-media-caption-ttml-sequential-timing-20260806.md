# FreeP TTML Sequential Caption Timing - 2026-08-06

FreeP now honors TTML/DFXP `timeContainer="seq"` for nested caption containers. Child timing begins at the previous resolved child end, then applies the child's own `begin` offset; `dur` and `end` still clamp to the containing body/div boundary. Parallel containers retain the existing inherited `begin`/`end`/`dur` behavior.

This prevents sequential cues from overlapping at the container origin and keeps the transcript plan used by playback, caption authoring, and export consistent with the sidecar timing model.

Verification:

- `PresentationMediaTranscriptPlannerTests`: 21/21 focused.
- `FreeP.App.Presentation.Tests`: 3854/3854.
- New regression: a one-second cue followed by a 250 ms offset, 500 ms cue resolves to 0-1000 ms and 1250-1750 ms.
