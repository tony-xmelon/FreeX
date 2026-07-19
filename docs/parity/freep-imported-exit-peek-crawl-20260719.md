# FreeP imported exit Peek/Crawl

## Scope

WPF and Avalonia imported `Peek` and `Crawl` exits now reverse the host translation. Entrance playback still moves from the directional offset to the slide origin; exit playback starts at the origin and moves to that offset.

`Crawl` continues to share the `Peek` primitive, so the change applies consistently without altering planner, clip, or direction geometry.

## Verification

- WPF `SlideShowHostPolicySourceTests`: 2/2 compiling and 2/2 no-build.
- Avalonia `SlideShowHostPolicySourceTests`: 3/3 compiling and 3/3 no-build.

Static RenderCompare does not sample animation frames, so this is a functional playback correction validated through host source contracts rather than a static raster score.
