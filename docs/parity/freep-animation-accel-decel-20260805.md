# FreeP animation acceleration and deceleration

Date: 2026-08-05

## Closed slice

FreeP now preserves the authored PresentationML `p:cTn/@accel` and
`p:cTn/@decel` timing values on `ShapeAnimation`. The values survive clone and
undo snapshots, normal preset animation package round-trip, and motion-path
timing round-trip. Values are retained in their native 0..100000 units and
clamped only at the model/serialization boundary.

The shared slideshow playback plan carries both timing policies. WPF and
Avalonia consume the same continuous acceleration/deceleration easing function,
so the feature is functional parity rather than a renderer-local timing tweak.
Absent attributes retain the existing linear playback behavior. Malformed
overlapping values are proportionally bounded without changing duration or
endpoints.

## Validation

- Animation package round-trip and shared playback focused lane: **33/33**.
- Presentation test project Release build: **0 warnings, 0 errors**.
- WPF and Avalonia Release consumer builds: required before integration.

This slice does not claim PowerPoint-authoritative easing curves or frame-timing
pixel parity; it closes source-policy preservation and shared host behavior.
