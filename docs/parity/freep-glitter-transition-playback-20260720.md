# FreeP Glitter transition playback

## Scope

`TransitionKind.Glitter` now maps to a dedicated shared clip action in both
WPF and Avalonia. The incoming slide is revealed through deterministic
sparkle cells: each cell begins as a small star-like polygon, grows through a
short reveal window, and resolves to the full page while the outgoing slide
remains underneath.

The cell order and jitter are seeded in the shared planner, so both hosts use
the same geometry and do not depend on host-local random state.

## Verification

- Presentation planner focused tests: compile-first and no-build pass.
- Host transition completeness and WPF source guards: compile-first and
  no-build pass.
- Avalonia source guard: compile-first and no-build pass.
- WPF and Avalonia Release application builds: `0` warnings, `0` errors.

No new PowerPoint COM raster export was required for this transition-function
slice.
