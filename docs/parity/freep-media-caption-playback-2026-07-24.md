# FreeP Media Caption Playback

## Scope

FreeP already retained PowerPoint media caption tracks and parsed WebVTT, SRT, and TTML cues, but the Avalonia slideshow did not expose those cues while a video played. This slice connects the shared transcript plan to the playback session clock.

## Implemented

- `PresentationMediaTranscriptPlanner.FindActiveCue` uses normalized half-open cue intervals (`start <= position < end`).
- Avalonia slideshow media slots select the matching available track by media shape id.
- A non-interactive caption surface is positioned at the lower edge of the media bounds and refreshes from `IMediaPlaybackSession.Position` on a short dispatcher interval.
- Slide entry passes only caption tracks belonging to the current physical slide.
- The injected playback test proves activation inside a cue and removal at its end boundary without LibVLC or a real media file.

## Boundaries

This is functional playback coverage, not a PowerPoint pixel-baseline claim. WPF has no equivalent native media playback surface in this slice, and PowerPoint-authoritative caption styling, positioning, accessibility, and advanced timing semantics remain deferred.

## Verification

- `PresentationMediaTranscriptPlannerTests.FindActiveCue_UsesHalfOpenTimeIntervals`
- `AvaloniaMediaPlaybackAdapterTests.Controller_RefreshesCaptionOverlayFromPlaybackPosition`
- Release compilation of the affected Presentation and Avalonia test dependency graphs
