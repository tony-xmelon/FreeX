# Avalonia parity Wave 38

Date: 2026-07-27

## Closed slices

- **FreeX threaded-comment inline workflow:** Review, Insert, and worksheet-context New Comment
  routes now open a worksheet-anchored Avalonia editor like WPF. New, edit, reply, selected-reply
  update, resolve, cancel, and undo continue through the shared comment planner and review session.
  Stable WPF automation ids, button order and metrics, conversation geometry, and popup colors are
  shared as host contracts.
- **FreeW Insert Header/Footer prompt:** Avalonia now prompts for Header or Footer text, seeds the
  current value, treats Cancel as a no-op, and preserves an existing PAGE field through the same
  shared planner used by WPF.
- **FreeP rendered combo key tips and timing routes:** Avalonia key-tip lookup now targets rendered
  visual-tree combo boxes with a logical-tree fallback. The font-family route is green, the stale
  Transitions command-order expectation is corrected, and real Rehearse/Record ribbon commands are
  proven to launch slideshow windows with the matching shared timing intent.

## Merged verification

- FreeX Avalonia inline-comment runtime: 3/3 passed.
- FreeX WPF inline-comment authority: 3/3 passed.
- FreeW shared Header/Footer planner: 16/16 passed.
- FreeW WPF ribbon authority: 104/104 passed.
- FreeW Avalonia Header/Footer and Insert runtime: 22/22 passed.
- FreeP Avalonia keyboard, transition definition, and timing workflow: 19/19 passed.
- FreeP WPF transition/animation authority: 115/115 passed.
- FreeP shared ribbon-definition profiles: 19/19 passed.

## Review corrections

The initial FreeX implementation was not integrated as submitted. Integration review found that
selected-reply Ctrl+Enter could execute the general thread submit and that the Avalonia action
surface diverged from WPF. The worker corrected the keyboard route, added a selected-reply
regression test, and aligned stable WPF automation, order, size, color, spacing, and placement
contracts before cherry-pick.

## Residuals

- FreeX New Note still uses its modal prompt; this wave closes threaded New Comment. Foreground
  paired capture is still needed for pixel-level inline-editor review.
- FreeW native dialog chrome and text rasterization remain toolkit-rendered; this slice proves the
  workflow contract rather than pixel identity.
- FreeP still requires broader dialog, desktop, hardware, and PowerPoint-authoritative validation.

This wave closes production workflows and their known regression evidence. It does not claim
whole-product visual or functional parity.
