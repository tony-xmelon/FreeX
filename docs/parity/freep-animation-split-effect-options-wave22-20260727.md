# FreeP Split Animation Effect Options - Wave 22

Date: 2026-07-27

## Scope

PowerPoint exposes four effect options for Split animations:

- Horizontal In
- Horizontal Out
- Vertical In
- Vertical Out

FreeP previously exposed only Horizontal and Vertical, so the Animation Pane
could not preserve or author the in/out component.

## Implementation

- `AnimationDirection` now represents all four Split combinations.
- `AnimationDirectionSemantics` supplies renderer-neutral axis and
  center/outside behavior shared by WPF and Avalonia.
- The Animation Pane lists and applies all four options.
- PPTX subtype values `0` through `3` round-trip to the matching direction.
- Legacy Horizontal and Vertical values remain supported and keep FreeP's
  historical center-out playback behavior.
- Both slideshow hosts consume the same shared Split semantics and mask
  geometry planning.

## Verification

- FreeP presentation and IO tests: 188 passed.
- FreeP WPF host tests: 18 passed.
- FreeP Avalonia host tests: 220 passed.
- Total focused Wave 22 verification: 426 passed, 0 failed.

PowerPoint-authoritative Animation Pane screenshots and exact playback-frame
visual comparisons remain part of the external baseline work.
