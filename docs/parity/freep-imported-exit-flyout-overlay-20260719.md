# FreeP imported exit FlyOut overlay

## Scope

Imported `AnimationKind.Exit` entries using the `FlyIn` preset (the command
surface exposes this as `Exit: FlyOut`) now use the per-shape bitmap overlay
route in both slideshow hosts. The same route now supports reversed `Wipe` and
`Split` clip exits. Previously these presets were absent from overlay
preparation and fell through to the coarse fallback; when an overlay existed,
the shared FlyIn primitive also moved it toward the slide instead of away from
the slide.

## Behavior

- WPF and Avalonia prepare the exact shape bitmap before the exit step.
- At step start the base shape is suppressed, preventing a duplicate copy.
- Entrance FlyIn keeps its existing off-slide-to-on-slide motion.
- Exit FlyOut starts on-slide, translates in the authored direction, and fades
  from opacity 1 to 0.
- Exit Wipe contracts its full clip to the directional edge; exit Split contracts
  its full clip to the center seam.
- Unsupported exit presets still use their existing fallback until their clip
  or direction semantics are separately verified.

## Verification

- WPF `SlideShowHostPolicySourceTests`: 2/2 compiling and 2/2 no-build.
- Avalonia `SlideShowHostPolicySourceTests`: 3/3 compiling.
- WPF and Avalonia Release host dependencies compiled successfully as part of
  the focused test commands.

This is a functional playback correction. The static-slide RenderCompare
corpus does not capture animation frames, so no raster parity score is claimed
for this slice. Exact PowerPoint easing and frame timing remain future visual
baseline work.
