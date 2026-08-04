# FreeP Animation Trigger Playback, Wave 139

## Scope

The Animation Pane `Play From Selected` session now preserves PowerPoint's
trigger-only playback boundary in the shared presentation plan. When the
selected animation has a `TriggerShapeId`, the session contains that trigger's
selected animation and subsequent animations for the same trigger only. Main
sequence animations and animations owned by another trigger are excluded.

The slideshow controller already enforced this boundary for WPF and Avalonia;
the planner now reports the same segment set to both hosts. The trigger shape
identity is retained on each timeline item so the shared plan can make the
decision without reaching into a host-specific controller.

## Verification

- Presentation planner regression: trigger sequence `[20, 21, 22]` excludes
  unrelated main-sequence animation `30`.
- Existing WPF controller trigger-start test remains covered by
  `SlideShowTests.Controller_AnimationStartIndex_StartsSelectedTriggerSequence`.
- Existing Avalonia headless route remains covered by
  `SlideShowWindowHeadlessTests.SlideShowWindow_animation_route_starts_at_selected_trigger_animation`.

This is a functional playback correction. PowerPoint COM visual checkpoint
capture remains separate evidence work.
