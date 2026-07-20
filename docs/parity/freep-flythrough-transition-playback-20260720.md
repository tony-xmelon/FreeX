# FreeP Flythrough transition playback

## Scope

`TransitionKind.Flythrough` now maps to a dedicated shared playback action in
both WPF and Avalonia. The incoming slide starts as a reduced panel offset in
the requested direction, then travels and scales to the page while the
outgoing snapshot recedes in the opposite direction and fades away.

The implementation deliberately reuses the shared perspective transition
surface: it provides deterministic two-surface playback and direction-aware
motion without claiming PowerPoint's full 3-D camera, lighting, or depth
occlusion model.

## Verification

- Presentation planner focused tests: compile-first and no-build pass.
- Host transition completeness and WPF source guards: compile-first and
  no-build pass.
- Avalonia source guard: compile-first and no-build pass.
- WPF and Avalonia Release application builds: `0` warnings, `0` errors.

No new PowerPoint COM raster export was required for this transition-function
slice.
