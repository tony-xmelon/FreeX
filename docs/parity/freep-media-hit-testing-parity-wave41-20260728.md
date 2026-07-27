# FreeP WPF/Avalonia Media Hit-Testing Parity Wave 41

## Selected functional mismatch

Overlapping slideshow media shapes did not have paired click semantics. The shared
`SlideShowMediaInteractionPlanner` and Avalonia controller reverse the authored shape
order so the topmost media shape receives a click. WPF `SlideShowMediaController`
instead scanned its media slots in authored order, so the bottommost overlapping media
shape toggled playback.

This was a reproducible production behavior mismatch, not a renderer or evidence-only
difference: two overlapping media shapes and one click at their intersection selected
different shape ids on WPF and Avalonia.

## Implementation

- WPF now delegates media click hit-testing to the shared planner and resolves the
  selected media slot by shape id.
- Avalonia continues to use the same shared planner path.
- The WPF controller records the selected shape id for focused authority tests.

## Authority coverage

- Shared: `RendererNeutralDedupPlannerTests.SlideShowMediaInteractionPlanner_UsesLetterboxedBoundsAndTopmostMediaClick`
- WPF: `SlideShowMediaControllerTests.TryHandleClick_UsesTopmostOverlappingMediaShape`
- Avalonia: `AvaloniaMediaPlaybackAdapterTests.Controller_UsesTopmostOverlappingMediaShapeForClicks`

## Residuals

Native media playback remains host-specific by design: WPF uses `MediaElement`, while
Avalonia uses its LibVLC adapter with a poster/fallback path. This slice only closes
the deterministic click-target semantics shared by both hosts.
