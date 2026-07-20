# FreeP Ripple transition playback

## Scope

`TransitionKind.Ripple` now maps to a dedicated shared clip action in both
WPF and Avalonia. The incoming slide is revealed through a seeded radial
wavefront whose boundary expands from the page center; the wave amplitude
decreases as the wave reaches the page edge and the terminal state resolves to
the complete slide.

The segment count, phase, and wave amplitude are owned by the shared planner,
so both hosts use the same deterministic geometry while retaining native WPF
keyframes and Avalonia render-timer playback.

## Verification

- Presentation planner focused tests: compile-first and no-build pass.
- Host transition completeness and WPF source guards: compile-first and
  no-build pass.
- Avalonia source guard: compile-first and no-build pass.
- WPF and Avalonia Release application builds: `0` warnings, `0` errors.

No new PowerPoint COM raster export was required for this transition-function
slice.
