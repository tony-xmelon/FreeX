# FreeP animation timing parity

## Discrepancy

Animation acceleration and deceleration already survived the FreeP model and
PPTX round trip, but live playback applied those values inconsistently. The
shared planner's raw OOXML envelope also represented omitted timing as linear,
while the hosts' established default playback curve is cubic ease-in/out.

## Implementation

- `SlideShowPlaybackPlanner.ApplyHostTimingEasing` is the live-playback
  contract. Omitted timing retains the established cubic host curve; authored
  acceleration/deceleration uses the shared OOXML envelope.
- WPF adapts the contract through `PowerPointAnimationEasing` and applies it
  to every scalar `DoubleAnimation` in an effect storyboard, including helper
  timelines added by individual effects.
- Avalonia routes its animation helper through the same shared host policy.
- Existing animation-pane editing contracts and the generic planner method
  remain unchanged.

## Verification

- Shared `SlideShowPlaybackPlannerTests`: 100/100.
- WPF `SlideShowHostPolicySourceTests`: 5/5.
- Avalonia `SlideShowHostPolicySourceTests`: 7/7.
- Release-consuming builds completed through the focused host test commands.

## Residuals

This is a functional timing-consumption slice, not a claim that every complex
PowerPoint keyframe, clip, color, or multi-phase effect is a full native timing
engine. Those specialized effect implementations retain their existing host
interpolation while scalar tracks now receive the authored/default host policy.
