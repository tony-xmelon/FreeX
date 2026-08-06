# FreeP Change Font Size Animation Pane Ownership - 2026-08-06

## Functional gap

Native PowerPoint Change Font Size effects use a preserved numeric
`p:anim` targeting `style.fontSize`. The Animation Pane previously exposed
ordinary Grow/Shrink amount choices, but applying one updated only the
renderer-neutral `ScaleBehavior`; that could leave the native numeric payload
stale or make a pane edit appear to succeed without changing the authored
effect.

## Fix

The shared pane planner recognizes the preserved `style.fontSize` behavior and
projects the same amount choices from that numeric multiplier. Each choice
rewrites only the numeric `to` value in the preserved behavior. The mutation
keeps the native XML authoritative, avoids introducing `p:animScale`, and
restores the complete prior animation through the existing undo command.
Newly authored effects without a renderer-neutral scale field select the
native amount from the preserved payload rather than displaying a misleading
default.

## Verification

- Focused Animation Pane, playback, and animation package tests: **259/259**.
- Full FreeP Presentation test project: **3,849/3,849**.
- WPF Release consumer build: **0 warnings, 0 errors**.
- Avalonia Release consumer build: **0 warnings, 0 errors**.
- Test asserts no-op selection, native numeric rewrite, no `p:animScale`, and
  undo restoration.

This is a functional/package ownership correction; it makes no new visual
raster-equivalence claim.
