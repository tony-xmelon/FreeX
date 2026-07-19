# FreeP imported Split transition playback

FreeP now preserves and plays the classic PresentationML `p:split` transition
instead of collapsing it to a fade fallback.

- `orient="horz|vert"` is retained separately from `dir="in|out"`.
- The shared playback plan exposes the split axis and direction to both hosts.
- WPF and Avalonia reveal the incoming slide through two synchronized panels,
  using the shared split rectangle geometry.
- Existing transition sound, duration, auto-advance, and package round-trip
  behavior remain unchanged.

Focused evidence on 2026-07-19:

- Presentation planner/mask contracts: 76/76.
- WPF transition/completeness/source contracts: 150/150.
- Avalonia host source contract: 3/3.
- WPF and Avalonia Release builds: 0 warnings, 0 errors.
