# FreeP Remaining Imported Animation Playback - 2026-07-13

This no-COM slice advances FreeP slideshow animation playback parity for imported PowerPoint preset families that were already modeled in PPTX IO but still fell through the shared playback planner as generic Appear effects.

Shared status:

- `SlideShowPlaybackPlanner` now emits explicit renderer-neutral effect kinds for Dissolve, Flash, Spiral, Swivel, Bounce, Float, Swoop, and Boomerang.
- WPF and Avalonia slideshow hosts consume the new shared effect kinds through thin adapters over existing deterministic fade, spin, and fly-in primitives.
- Focused planner and host source tests verify that the remaining imported preset families no longer collapse to the Appear fallback.

Remaining blockers:

- These effects are deterministic playback approximations until PowerPoint-authoritative visual baselines are available on a COM-capable machine.
- Exact PowerPoint motion curves, bounce/boomerang overshoot, dissolve particle behavior, and swivel/spiral 3D nuances remain deferred to future visual-baseline work.

## 2026-07-19 follow-up

The imported emphasis presets that were already preserved by `PptxAnimationMap` but still
collapsed to the `Appear` playback fallback are now explicit in the shared playback plan:
`Teeter`, `Blink`, `ColorPulse`, `ChangeColor`, `GrowWithColor`, `Wave`, `Shimmer`, `Bold`,
and `Underline`. WPF and Avalonia prepare per-shape overlay images for authored emphasis
animations, including interactive trigger sequences, instead of flashing the entire slide.

The host effects are deterministic approximations: teeter uses a bounded rotation, blink uses
visibility keyframes, wave uses a small translation, and the remaining bitmap-safe emphasis
families use a bounded pulse track. Exact text recoloring, underline/bold mutation, and
PowerPoint easing still require authoritative PowerPoint playback frames; this slice removes
the incorrect `Appear` collapse and keeps that limitation explicit.

Verification on the current branch:

- `SlideShowPlaybackPlannerTests` plus `AnimationPanePlannerTests`: 84/84.
- WPF `SlideShowHostPolicySourceTests`: 2/2.
- Avalonia `SlideShowHostPolicySourceTests`: 3/3.
- `FreeP.App.Presentation` Release build: 0 warnings, 0 errors.
