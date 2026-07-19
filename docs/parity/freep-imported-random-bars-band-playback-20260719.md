# FreeP imported Random Bars playback

## Scope

Imported PowerPoint `RandomBars` animations previously used a single
rectangular wipe in both slideshow hosts. That made the preset functionally
look like Wipe rather than a multi-bar effect, especially at intermediate
playback checkpoints.

## Change

- The shared mask planner now emits eight full-width or full-height bars in a
  stable non-sequential permutation.
- WPF animates each bar with a staggered `RectangleGeometry` storyboard.
- Avalonia uses the same bar geometry, permutation, stagger, and exit
  reversal through its dispatcher animation path.
- Entrance remains closed-to-open; exit remains open-to-closed with the
  authored opacity direction preserved.

## Verification

- Shared mask geometry and playback planner tests: 17/17.
- WPF slideshow host source contract: 2/2.
- Avalonia slideshow host source contract: 3/3.
- Both host dependencies compiled in the focused commands.

This is a functional playback correction. Exact bar order, easing, and frame
timing against Microsoft PowerPoint still require an authoritative slideshow
capture on a COM-capable baseline host.
