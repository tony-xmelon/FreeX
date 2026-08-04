# FreeP Media Caption Placement - 2026-08-04

## Scope

WebVTT cue timing already drove caption text in both slideshow hosts, but the parser
discarded authored cue settings and each host always rendered a full-width bottom
strip. The shared transcript descriptor now preserves percentage-based `position`,
`line`, and `size` settings plus `align` (`start`, `center`, `end`, `left`, or
`right`). WebVTT authoring emits those settings again; SRT and TTML remain unchanged.

The shared planner computes a bounded media-relative caption rectangle. WPF and
Avalonia apply that rectangle to their existing native caption surfaces, so playback,
hit testing, and caption lifecycle remain owned by the existing host adapters.
Invalid or unsupported WebVTT setting values are ignored and use the prior default
bottom placement.

## Verification

- Presentation transcript planner: 12/12 focused tests.
- WPF media host: 32/32 focused tests.
- Avalonia media host: 8/8 focused tests.
- `FreeP.App.Presentation`, `FreeP.App.Host`, and `FreeP.App.Avalonia` Release builds:
  0 warnings, 0 errors.

This is a function/format slice, not a PowerPoint COM visual claim. Native media
decoding and application-authored caption rendering remain platform-dependent.
