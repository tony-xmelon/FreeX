# FreeP Asymmetric Grow/Shrink Playback - Wave 24

Date: 2026-07-27

## Scope

Wave 23 retained imported `p:animScale` `ScaleX`/`ScaleY` values in the model
and PPTX package, but slideshow playback projected the amount through one
scalar scale track. This slice closes that residual for the shared playback
plan, frame plan, WPF host, and Avalonia host.

## Implementation

- `SlideShowShapeAnimationPlaybackPlan` keeps the scalar
  `FromScale`/`ToScale`/`PeakScale` compatibility surface and adds
  `FromScaleX`/`FromScaleY`, `ToScaleX`/`ToScaleY`, and
  `PeakScaleX`/`PeakScaleY`. Legacy callers that do not initialize the new
  properties fall back to the scalar values.
- `SlideShowShapeAnimationVisualFramePlan` exposes the resolved X/Y scales and
  the axis-specific trajectory values. Its scalar `Scale` remains the X-axis
  compatibility value.
- Both slideshow hosts consume the shared axis semantics: WPF creates paired
  X/Y keyframe animations, and Avalonia updates paired X/Y transforms from the
  same shared plan values.
- PPTX IO coverage verifies asymmetric `from`/`to` X/Y tokens and
  `zoomContents` survive a read/write round trip.

## Verification

- `FreeP.App.Presentation.Tests`: 109 focused planner/IO tests passed,
  including asymmetric frame planning and both-axis package round-trip.
- `FreeP.App.Host.Tests` filtered to `SlideShowHostPolicySourceTests`: 2 passed.
- `FreeP.App.Avalonia.Tests` filtered to `SlideShowHostPolicySourceTests`: 3 passed.

No PowerPoint COM run or PowerPoint visual/frame comparison was available for
this slice. Authoritative PowerPoint screenshots and exact visual diffs remain
external baseline work.
