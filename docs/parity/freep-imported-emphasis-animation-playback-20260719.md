# FreeP Imported Emphasis Animation Playback - 2026-07-19

## Scope

PPTX IO already retained nine PowerPoint emphasis preset families, but the shared slideshow
planner mapped them to `Appear`, and shapes without an entrance overlay received a whole-slide
opacity flash. This slice preserves the authored preset identity through the shared playback
and frame plans and gives both slideshow hosts a per-shape overlay route.

Covered presets:

- `Teeter`, `Blink`, `ColorPulse`, `ChangeColor`, `GrowWithColor`
- `Wave`, `Shimmer`, `Bold`, `Underline`

Interactive emphasis animations are included in the overlay preparation path; entrance and motion
overlays remain restricted to their existing non-trigger main-sequence behavior.

## Host behavior

WPF uses Storyboard keyframes and Avalonia uses the equivalent deterministic dispatcher animation:

- Teeter: bounded `-10/10` degree oscillation.
- Blink: four-state opacity pulse.
- Wave: bounded horizontal translation.
- Color/text emphasis families: bounded pulse track on the rendered shape bitmap.

The last group is intentionally a renderer-safe approximation. A bitmap overlay cannot mutate
authored text color, bold, or underline semantics without a text-aware shape compositor, so the
model and planner retain the exact family while the evidence contract documents the visual limit.

## Verification

- Shared planner/frame tests: 84/84 focused tests.
- WPF host source contract: 2/2.
- Avalonia host source contract: 3/3.
- `FreeP.App.Presentation` Release build: 0 warnings, 0 errors.

PowerPoint-authoritative frame-by-frame playback screenshots are still required before claiming
exact timing, easing, color mutation, or text-emphasis visual parity.
