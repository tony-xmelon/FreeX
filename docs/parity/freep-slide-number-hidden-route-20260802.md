# FreeP slide-number jumps with hidden slides

The slideshow route intentionally omits hidden slides during ordinary playback, but
PowerPoint's numeric jump still uses the deck's one-based slide numbers. The shared
host planner now accepts the route's source-slide map and resolves a numeric jump against
the original deck index before navigating the filtered route.

Both WPF and Avalonia pass the map from `SlideShowPlaybackRoute`. Existing custom-show
and visible-route behavior remains unchanged; a number that refers to a hidden or omitted
slide is handled as a no-op rather than silently opening the wrong slide.
