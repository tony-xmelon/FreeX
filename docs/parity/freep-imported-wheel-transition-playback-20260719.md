# FreeP imported Wheel transition playback - 2026-07-19

## Scope

PowerPoint `p:wheel` and `p:wheelReverse` transitions were already retained by
the PPTX model but were routed through the generic fade fallback during
slideshow playback. The shared transition plan now exposes a dedicated Wheel
action for both kinds. The authored `spokes` attribute is preserved through
read, write, clone, and command-copy paths; omitted or invalid values use the
renderer-neutral default of four spokes and are clamped to a safe range.

## Host behavior

WPF and Avalonia reveal the incoming slide with the shared wheel sweep plan.
`p:wheel` uses clockwise arcs and `p:wheelReverse` uses counter-clockwise arcs;
the prior slide remains underneath until the incoming mask is complete.
Both hosts consume the same spoke count and arc geometry, with only the final
WPF/Avalonia geometry conversion kept host-local.

## Verification

- Shared presentation planner, host planner, and mask tests: `95/95` compile-first and no-build.
- WPF transition/package/source-contract tests: `121/121` compile-first and no-build.
- Avalonia host source-contract tests: `3/3` compile-first and no-build.
- Presentation Release build: `0` warnings, `0` errors.

PowerPoint-authoritative frame captures were not added in this slice, so exact
timing/easing raster parity remains an evidence follow-up rather than a claim.
