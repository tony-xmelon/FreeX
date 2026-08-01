# FreeP Functional Wave 93: Motion Path Reverse Command

Date: 2026-08-01

## Scope

FreeP already preserved motion-path segments and the animation-pane effect-options flow could reverse a path, but the operation was not exposed as a direct authoring command. The shared animation command planner now exposes `freep.anim.motion.reverse` as `Reverse Path` in the motion-path ribbon group.

The command applies only to the selected shape's motion animation, clones the animation through the existing undoable `SetAnimation` path, and reverses line/cubic segment order while retaining `Origin`, `PtsTypes`, timing, trigger, and effect metadata. Non-motion animations and paths with no drawable segments are rejected without an undo entry.

Both WPF and Avalonia consume the same planner command and continue to use the existing playback and PPTX writer paths.

## Verification

- Presentation planner: 85 focused tests passed.
- WPF host: 124 focused animation/motion tests passed.
- Avalonia: 6 focused motion command tests passed.
- Ribbon definitions: 23 tests passed after generated inventory refresh.
- Localization: 11 tests passed.
- Command inventory regenerated from both host profiles; `freep.anim.motion.reverse` is present in the shared route.

## Remaining

This slice does not claim a custom freeform path drawing surface or PowerPoint-authoritative animation visual baseline. Those remain separate follow-up capabilities.
