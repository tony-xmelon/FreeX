# FreeP imported Zoom transition playback - 2026-07-19

## Scope

PowerPoint `p:zoom` transitions were already preserved by PPTX IO but the
shared slideshow planner treated them as an unsupported fade fallback. Zoom
now has a dedicated renderer-neutral action. Missing direction and `dir="in"`
use an incoming zoom-in; `dir="out"` uses the complementary zoom-out start
scale.

## Host behavior

WPF and Avalonia place the incoming slide above the captured prior slide and
animate a centered scale to the final slide size. The two hosts share the
direction decision and start-scale constants while keeping their animation
implementation native to each UI framework. The transform is cleared at
completion so later navigation starts from an unscaled slide.

## Verification

- Shared presentation planner, host planner, and mask tests: `96/96` compile-first and no-build.
- WPF transition/package/source-contract tests: `122/122` compile-first and no-build.
- Avalonia host source-contract tests: `3/3` compile-first and no-build.
- Presentation Release build: `0` warnings, `0` errors.

PowerPoint-authoritative frame captures were not added in this slice, so exact
easing and frame-by-frame raster parity remain an evidence follow-up.
