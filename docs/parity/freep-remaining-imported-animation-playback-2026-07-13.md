# FreeP Remaining Imported Animation Playback - 2026-07-13

This no-COM slice advances FreeP slideshow animation playback parity for imported PowerPoint preset families that were already modeled in PPTX IO but still fell through the shared playback planner as generic Appear effects.

Shared status:

- `SlideShowPlaybackPlanner` now emits explicit renderer-neutral effect kinds for Dissolve, Flash, Spiral, Swivel, Bounce, Float, Swoop, and Boomerang.
- WPF and Avalonia slideshow hosts consume the new shared effect kinds through thin adapters over existing deterministic fade, spin, and fly-in primitives.
- Focused planner and host source tests verify that the remaining imported preset families no longer collapse to the Appear fallback.

Remaining blockers:

- These effects are deterministic playback approximations until PowerPoint-authoritative visual baselines are available on a COM-capable machine.
- Exact PowerPoint motion curves, bounce/boomerang overshoot, dissolve particle behavior, and swivel/spiral 3D nuances remain deferred to future visual-baseline work.
