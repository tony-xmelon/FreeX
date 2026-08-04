# FreeP Animation Trigger Timing, Wave 140

## Scope

`Play From Selected` now schedules a selected PowerPoint trigger chain in its
own timeline. The planner no longer carries elapsed time from unrelated
main-sequence animations that happen to be interleaved in the flat package
animation list.

The trigger-scoped segment set and timing now agree with the slideshow
controller: a selected `OnClick` entry starts at zero, `WithPrevious` entries
share that step's start, and later trigger entries advance from the scoped
chain. Ordinary preview and play-all sessions retain the existing slide-wide
timeline.

## Verification

- Presentation `AnimationPanePlannerTests`: **104/104**.
- WPF `Controller_AnimationStartIndex_StartsSelectedTriggerSequence`: **1/1**.
- Avalonia `SlideShowWindow_animation_route_starts_at_selected_trigger_animation`:
  **1/1**.
- Regression scenario verifies trigger shapes 20/21/22 schedule at relative
  starts `0/0/500 ms` and ends `400/500/700 ms`, excluding unrelated shape 30.

This is functional playback parity; visual PowerPoint checkpoint capture is a
separate evidence lane.
