# FreeP Wave167 animation timing depth

## Discrepancy

`ShapeAnimation` acceleration/deceleration values already survived the FreeP
model and PPTX round trip, and `SlideShowPlaybackFramePlanner` already exposed
the shared OOXML timing envelope. Live shape playback still used host-local
cubic easing, so authored timing was not reflected consistently by WPF and
Avalonia.

## Implementation

- `SlideShowPlaybackPlanner.ApplyHostTimingEasing` is the shared live-playback
  contract. Untimed effects retain the established cubic ease-in/out curve;
  authored acceleration/deceleration values use the shared OOXML envelope.
- WPF adapts that contract through `PowerPointTimingEasingFunction` and applies
  it to storyboard `DoubleAnimation` tracks.
- Avalonia applies the same contract to shape opacity helpers across Fade,
  Flash, Fly In, Float, Swoop, Boomerang, Bounce, and Zoom, plus the core Fly
  In translation helper.

## Verification

- Shared planner tests cover authored envelope values and untimed host-curve
  compatibility.
- Existing PPTX animation round-trip tests cover authored acceleration and
  deceleration persistence.
- WPF and Avalonia source-contract tests require both hosts to consume the
  shared timing policy.

## Residuals

This slice does not attempt to replace every specialized keyframe/effect
implementation with a full PowerPoint timing engine. Complex clip, color,
multi-phase, and curved-translation effects retain their existing host-specific
interpolation details; the shared authored timing contract is now in the core
shape opacity/Fly In translation routes and WPF scalar storyboard routes.
