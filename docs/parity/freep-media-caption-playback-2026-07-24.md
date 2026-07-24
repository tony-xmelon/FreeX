# FreeP Media Caption Playback

## Scope

FreeP already retained PowerPoint media caption tracks and parsed WebVTT, SRT, and TTML cues, but the Avalonia slideshow did not expose those cues while a video played. This slice connects the shared transcript plan to the playback session clock.

## Implemented

- `PresentationMediaTranscriptPlanner.FindActiveCue` uses normalized half-open cue intervals (`start <= position < end`).
- WPF and Avalonia slideshow media slots select the matching available track by media shape id.
- Each host positions a non-interactive caption surface at the lower edge of the media bounds and refreshes from its playback clock on a short dispatcher interval.
- Slide entry passes only caption tracks belonging to the current physical slide.
- Injected playback tests prove activation inside a cue and removal at its end boundary without LibVLC or a real media file; the WPF controller test also proves caption-surface teardown.

## Boundaries

This is functional playback coverage, not a PowerPoint pixel-baseline claim. PowerPoint-authoritative caption styling, positioning, accessibility, and advanced timing semantics remain deferred.

## Verification

- `PresentationMediaTranscriptPlannerTests.FindActiveCue_UsesHalfOpenTimeIntervals`
- `AvaloniaMediaPlaybackAdapterTests.Controller_RefreshesCaptionOverlayFromPlaybackPosition`
- `SlideShowMediaControllerTests.EnterSlide_WithCaptionTrack_CreatesAndTearsDownCaptionSurface`
- Release compilation of the affected Presentation and Avalonia test dependency graphs
