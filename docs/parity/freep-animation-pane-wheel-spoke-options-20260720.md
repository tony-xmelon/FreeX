# FreeP Animation Pane Wheel Spoke Options

FreeP already preserved `AnimationPreset.Wheel` `WheelSpokeCount` through PPTX
read/write and used it during slideshow playback, but the Animation Pane only
exposed the direction (`In`/`Out`). The shared pane plan now exposes the
PowerPoint spoke choices `1`, `2`, `3`, `4`, and `8`; an authored positive
custom count is added to the list instead of being discarded. WPF and Avalonia
render the spoke selector through their existing shared mutation route, and
the edit remains undoable.

## Verification

- `AnimationPanePlannerTests`: **74/74**.
- WPF `AnimationPaneTests`: **14/14**.
- Avalonia animation-pane effect-option headless test: **1/1**.
- WPF and Avalonia Release host builds completed through those focused test
  commands.

This closes the authoring/function gap for the serialized Wheel spoke option;
PowerPoint-authenticated visual timing/easing baselines remain separate work.
