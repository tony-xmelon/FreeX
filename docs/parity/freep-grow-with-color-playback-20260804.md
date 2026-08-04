# FreeP Grow With Color Playback - 2026-08-04

## Scope

`GrowWithColor` was already exposed by the animation pane, preserved its authored
scale amount, and reached both slideshow hosts. Its preserved native `p:animClr`
payload was not emitted on save and was not resolved into the renderer-neutral
playback plan, so imported playback degraded to grow plus the generic emphasis
pulse.

The writer now retains `p:animClr` for `GrowWithColor`, and the shared playback
planner resolves direct authored `a:srgbClr` `clrFrom`/`clrTo` values. WPF and
Avalonia already consume the resulting color overlay alongside the authored scale
track. Existing `ColorPulse`, `ChangeColor`, and `Shimmer` behavior is unchanged.

## Boundary

Theme-based colors and color transforms such as tint/shade remain on the preserved
payload path until a theme-resolution contract is added. This slice does not claim
PowerPoint's exact easing or raster behavior.

## Verification

- `AnimationPresetRoundTripTests` and `SlideShowPlaybackPlannerTests`: `126/126`
- Full `FreeP.App.Presentation.Tests`: `3646/3646`
- WPF `SlideShowHostPolicySourceTests`: `2/2`
- Avalonia `SlideShowHostPolicySourceTests`: `4/4`
- Release builds completed successfully for all focused projects.
