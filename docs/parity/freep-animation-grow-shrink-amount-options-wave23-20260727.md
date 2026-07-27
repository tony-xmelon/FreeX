# FreeP Grow/Shrink Amount Effect Options - Wave 23

Date: 2026-07-27

Authority reference: Microsoft [MS-OE376] Part 4 Section 4.6.6,
`animScale` (Animate Scale):
https://learn.microsoft.com/en-us/openspecs/office_standards/ms-oe376/34ed450f-c53b-40a9-80a3-ebe3abaa8268

## Scope

PowerPoint's emphasis preset 5 is the Grow/Shrink effect. Its named amount
choices are:

- Tiny (25%)
- Smaller (50%)
- Larger (150%)
- Huge (400%)

PowerPoint also permits custom scale values. The amount authority is the
PresentationML `p:animScale` behavior, whose `ScaleX` and `ScaleY` attributes
use `from/to/by` combinations. Grow and Shrink share
`presetClass="emph"` and `presetID="5"`; `presetSubtype` is not used as the
amount authority. No checked-in PowerPoint corpus fixture currently proves a
25/50/150/400 subtype encoding, so this wave makes no such claim.

## Implementation

- `AnimationAmountSemantics` defines the renderer-neutral named choices,
  `from/to/by` resolution, custom-scale display, and the existing 120%/80%
  fallback for animations without an `animScale` behavior.
- `AnimationScaleBehavior` retains authored `x`/`y` XML tokens and all three
  value fields across the four legal Office combinations (`from_to`,
  `from_by`, `to_only`, and `by_only`), including unknown/custom values.
- The shared Animation Pane planner exposes and mutates the four named choices
  in both WPF and Avalonia. Imported custom or unknown tokens remain visible as
  `Custom (...)` instead of being silently relabeled as a named choice.
- The shared slideshow plan carries the resolved peak scale through
  `PeakScale`; both WPF and Avalonia Grow/Shrink helpers consume that same plan.
- PPTX read/write emits and parses `p:animScale`, infers Shrink when the
  authored effective scale is below 100%, and keeps clone/undo behavior data
  intact. Grow/Shrink `presetSubtype` is emitted as the neutral `0` value.

Named amount choices are uniform on both axes. Imported asymmetric custom
`ScaleX`/`ScaleY` values are retained, but exact asymmetric slideshow playback
remains a follow-up because the current host playback plan has one scale track.

## Verification

- FreeP presentation planner/IO/playback focused lane: 202 passed.
- FreeP WPF Animation Pane and slideshow host-policy lane: 19 passed.
- FreeP Avalonia Grow/Shrink and slideshow host-policy lane: 4 passed.
- PowerPoint COM visual baselines and exact frame comparisons remain deferred;
  this wave adds no COM-generated screenshot artifacts.
