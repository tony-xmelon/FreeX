# FreeP Theme-Based Animation Colors - 2026-08-04

## Scope

Imported color emphasis animations now resolve `p:clrFrom` and `p:clrTo` from
either direct `a:srgbClr` or theme-backed `a:schemeClr` values. Scheme roles use
the active presentation theme and the slide's effective `clrMap`; DrawingML
`lumMod`, `lumOff`, `tint`, and `shade` transforms are applied before the
renderer-neutral playback plan exposes the resulting RGB values.

Both WPF and Avalonia pass the active presentation and slide color map into
animation planning, including paragraph animations and Avalonia auto-reverse
passes. Existing direct RGB playback remains compatible.

## Boundary

This is functional color-source parity, not a claim of PowerPoint's exact
animation easing, timing quantization, or host rasterization. Unsupported color
families continue to fail closed rather than inventing a fallback color.

## Verification

- `SlideShowPlaybackPlannerTests` plus `AnimationPresetRoundTripTests`: `127/127`
- WPF `SlideShowHostPolicySourceTests`: `2/2`
- Avalonia `SlideShowHostPolicySourceTests`: `4/4`
- Release builds completed successfully for all focused projects.
