# Avalonia parity Wave 52 - FreeP Animation Pane playback

Date: 2026-07-29

## Closed slice

FreeP's Animation Pane already produced the same renderer-neutral playback plan
in WPF and Avalonia, but the selected animation index was discarded when either
host launched the slideshow. As a result, `Play From Selected` opened the
current slide with the normal first-animation state instead of starting at the
selected row.

The shared `SlideShowPlaybackRoute` now carries an optional animation start
index. `SlideShowController` trims the first selected click-step and skips
earlier main-sequence steps; trigger-only animations deliberately retain the
normal sequence because they are not part of the main click chain. Both WPF and
Avalonia Animation Pane adapters pass the shared playback session through their
launch callback, and both slideshow windows consume the route state.

## Validation

- FreeP presentation focused lane: 102 passed.
- FreeP WPF host focused lane: 63 passed.
- FreeP Avalonia headless focused lane: 50 passed.
- The paired WPF/Avalonia window tests verify that a route starting at animation
  index 1 presents that animation as the first pending playback step.

## Remaining

- Exact PowerPoint Animation Pane visuals, easing curves, and frame timing still
  require a desktop PowerPoint COM baseline.
- Trigger-only `Play From Selected` behavior remains intentionally deferred to
  the trigger interaction path because those animations do not belong to the
  main slideshow click sequence.
- Physical Linux slideshow capture was not run for this focused no-COM slice.
