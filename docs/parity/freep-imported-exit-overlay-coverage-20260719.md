# FreeP imported exit overlay coverage

## Scope

WPF and Avalonia now prepare a per-shape overlay for every imported `AnimationKind.Exit` preset, rather than limiting exit overlays to Appear, Fade, FlyIn, Wipe, and Split. This lets the shared exit playback plans reach their host implementations for RandomBars, advanced masks, Peek/Crawl, Zoom, and other imported families instead of falling through to the coarse fallback because no overlay existed.

Entrance, motion, and emphasis overlay selection remains unchanged. The change does not alter planner geometry or animation timing; it removes an overlay-preparation gate that prevented supported exit effects from being executed.

## Verification

- WPF `SlideShowHostPolicySourceTests`: 2/2 compiling and 2/2 no-build.
- Avalonia `SlideShowHostPolicySourceTests`: 3/3 compiling and 3/3 no-build.

This is functional playback coverage. Static RenderCompare does not sample slideshow animation frames, so no raster percentage is claimed.
