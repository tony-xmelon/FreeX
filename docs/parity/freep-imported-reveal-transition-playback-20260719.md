# FreeP imported Reveal transition playback - 2026-07-19

## Scope

PowerPoint `p:reveal` transitions were preserved by PPTX IO but were grouped
with push-like playback, which translated the entire incoming slide. Reveal
now has a dedicated renderer-neutral action and exposes the incoming edge as a
clip instead of moving slide content.

## Host behavior

WPF and Avalonia place the incoming slide above the captured prior slide and
grow a full-height or full-width clip from the authored incoming edge. The
shared planner derives the edge from the existing left/right/up/down offsets;
each host animates the resulting rectangle through its native clip API.

## Verification

- Shared presentation planner, host planner, and mask tests: `111/111`
  compile-first and no-build.
- WPF transition/package/source-contract tests: `122/122` compile-first and
  no-build.
- Avalonia host source-contract tests: `3/3` compile-first and no-build.
- Affected Presentation, WPF, and Avalonia projects built with `0` warnings
  and `0` errors in the focused commands.

PowerPoint-authoritative frame captures were not added in this slice, so exact
Reveal easing, edge registration, timing, and frame-by-frame raster parity
remain an evidence follow-up rather than a claim.
