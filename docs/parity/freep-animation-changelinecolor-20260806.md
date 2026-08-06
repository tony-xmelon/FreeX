# FreeP Native ChangeLineColor Playback - 2026-08-06

`AnimationPreset.ChangeLineColor` already had a distinct PresentationML source
contract: PowerPoint uses emphasis preset 7 with subtype 2 and an
`p:animClr` target of `stroke.color`. The package reader/writer and authoring
command preserved that payload, but slideshow playback collapsed it into the
generic `ChangeColor` effect.

This slice promotes the shared playback identity to `ChangeLineColor`, resolves
its preserved destination color through the existing theme/color-map resolver,
and gives WPF/Avalonia a narrow outline-color overlay path for simple visible
solid outlines. The overlay transitions from transparent to the authored target
stroke while the base slide remains untouched. Text-bearing, gradient, missing,
or otherwise unsupported outlines retain the existing route rather than being
guessed into a new renderer path.

Evidence:

- Shared planner/package lane: 150 focused tests passed.
- WPF host source contract: 3/3 passed.
- Avalonia host source contract: 5/5 passed.
- WPF Release build: 0 warnings, 0 errors.
- Avalonia Release build: 0 warnings, 0 errors.

This is a functional playback contract. It makes no PowerPoint pixel or timing
equivalence claim; those remain a separate COM-baseline visual boundary.
