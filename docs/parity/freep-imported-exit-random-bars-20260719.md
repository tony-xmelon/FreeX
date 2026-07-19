# FreeP imported exit Random Bars

## Scope

Imported `AnimationKind.Exit` entries using the `RandomBars` preset now run the
clip and opacity timeline in reverse in both WPF and Avalonia. Previously the
hosts always started from a closed clip with zero opacity and expanded it, so
an exit entry briefly revealed the shape instead of hiding it.

## Behavior

- Entrance Random Bars retains its existing closed-to-full clip and staged
  opacity ramp.
- Exit Random Bars starts with the full shape at the planner's `FromOpacity`,
  contracts to the directional closed clip, and ends at `ToOpacity`.
- The shared planner and unsupported-preset fallbacks are unchanged.

## Verification

- WPF `SlideShowHostPolicySourceTests`: 2/2 compiling and 2/2 no-build.
- Avalonia `SlideShowHostPolicySourceTests`: 3/3 compiling and 3/3 no-build.
- Both host dependencies compiled successfully in the focused test commands.

This is a functional playback correction. The static-slide RenderCompare
corpus does not capture animation frames, so no raster parity score is claimed
for this slice. Exact PowerPoint Random Bars band cadence remains future
animation-baseline work.
