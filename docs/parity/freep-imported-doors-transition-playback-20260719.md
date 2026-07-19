# FreeP imported Doors transition playback - 2026-07-19

## Scope

PowerPoint `p:doors` transitions were preserved by PPTX IO but were routed
through the generic push fallback. Doors now uses the shared Split playback
plan with a fixed vertical-panel, center-opening geometry, matching the
PowerPoint doors metaphor without introducing a second host-specific mask.

## Host behavior

WPF and Avalonia consume the existing shared split transition implementation.
The incoming slide starts as two centered vertical panels and opens outward
over the captured prior slide; the planner forces the center-opening direction
for Doors while ordinary Split transitions retain their authored orientation.

## Verification

- Shared presentation planner, host planner, and mask tests: `112/112`
  compile-first and no-build.
- WPF transition/package/source-contract tests: `122/122` compile-first and
  no-build.
- Avalonia host source-contract tests: `3/3` compile-first and no-build.
- Affected Presentation, WPF, and Avalonia projects built with `0` warnings
  and `0` errors in the focused commands.

PowerPoint-authoritative frame captures were not added in this slice, so exact
Doors perspective, easing, timing, and frame-by-frame raster parity remain an
evidence follow-up rather than a claim.
