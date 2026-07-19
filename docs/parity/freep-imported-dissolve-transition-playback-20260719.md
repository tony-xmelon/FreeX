# FreeP imported Dissolve transition playback - 2026-07-19

## Scope

PowerPoint `p:dissolve` transitions were preserved by PPTX IO but were routed
through the generic fade fallback during slideshow playback. Dissolve now has
a dedicated renderer-neutral action. The shared planner reveals a deterministic
12-row by 16-column tile mask in a stable shuffled order, so WPF and Avalonia
agree on which tiles are visible at each normalized checkpoint.

## Host behavior

WPF and Avalonia place the incoming slide above the captured prior slide and
animate the shared tile mask until the incoming slide is fully revealed. Each
host converts the shared rectangles into its native clipping geometry and
cleans up the mask at completion; the tile order and reveal count remain
renderer-neutral.

## Verification

- Shared presentation planner, host planner, and mask tests: `101/101`
  compile-first and no-build.
- WPF transition/package/source-contract tests: `122/122` compile-first and
  no-build.
- Avalonia host source-contract tests: `3/3` compile-first and no-build.
- All three compile-first commands built successfully with `0` warnings and
  `0` errors in the affected projects.

PowerPoint-authoritative frame captures were not added in this slice, so exact
tile ordering, easing, timing, and frame-by-frame raster parity remain an
evidence follow-up rather than a claim.
