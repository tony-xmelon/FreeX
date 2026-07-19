# FreeP imported exit-animation overlays

## Scope

Imported `AnimationKind.Exit` entries using the `Appear` (Disappear) or `Fade`
presets now use the same per-shape bitmap overlay path as entrance and emphasis
playback in both WPF and Avalonia. Previously these entries were excluded from
overlay preparation and fell through to a whole-slide opacity flash.

At the start of an exit step, the host suppresses the authored shape in the base
canvas and animates its full-slide shape bitmap from the shared planner's
`FromOpacity=1` to `ToOpacity=0`. The shape remains suppressed for the rest of
the slide. Unsupported exit presets retain the existing fallback until their
host-specific clip or motion direction is verified.

## Verification

- WPF `SlideShowHostPolicySourceTests`: 2/2
- Avalonia `SlideShowHostPolicySourceTests`: 3/3
- Shared Presentation planner suite: pending in this slice

This is a functional playback correction; no static-slide raster score is
claimed because the RenderCompare corpus captures slide appearance before
animation playback.
