# FreeP authored animation timing

## Scope

FreeP preserves shape animation acceleration and deceleration in the shared
playback plan, but the WPF live slideshow previously replaced those values
with hard-coded easing functions. The WPF shape-animation storyboard path now
uses a host adapter that delegates the authored timing envelope to
`SlideShowPlaybackPlanner.ApplyTimingEasing`.

Slide transitions and the slide-wide fallback animation remain on their
existing easing paths. Avalonia's timer-based live shape playback remains a
separate follow-up because it needs the timing values threaded through its
per-frame helper calls rather than a WPF easing-function adapter.

## Verification

- Shared timing contracts: 2/2.
- WPF source contract: 1/1.
- WPF host Release build: 0 warnings, 0 errors.

The source contract checks that the shape storyboard region uses the authored
easing adapter and that its fallback boundary remains distinct.
