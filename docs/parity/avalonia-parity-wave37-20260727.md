# Avalonia parity Wave 37

Date: 2026-07-27

## Closed slices

- **FreeX picture context-menu crop:** Avalonia's `Crop Picture` context-menu command now enters
  the same live eight-handle crop mode as the Picture Format ribbon and WPF, instead of opening the
  numeric crop dialog.
- **FreeW selected review change:** Avalonia's Accept/Reject This Change commands now act on the
  selected Reviewing Pane revision, matching WPF even when the editor caret is elsewhere.
- **FreeP nested ribbon key tips:** Avalonia now defers an exact key tip when a longer enabled
  candidate shares its prefix. The confirmed `Blink=B` / `Blinds In=BI` route now reaches the same
  nested animation command as WPF.

## Merged verification

- FreeX shared picture-crop planner: 18/18 passed.
- FreeX Avalonia picture-crop runtime: 2/2 passed.
- FreeX WPF picture-crop authority: 3/3 passed.
- FreeW WPF Reviewing Pane authority: 7/7 passed.
- FreeW Avalonia production selected-change routing: 3/3 passed.
- FreeP shared key-tip resolution planner: 6/6 passed.
- FreeP WPF key-tip definition authority: 2/2 passed.
- FreeP Avalonia keyboard-context class: 16/17 passed. The one failure is the previously known
  font-family combo visual-tree setup failure, before key-tip routing executes.

## Residuals

- The FreeP font-family key-tip case still fails while locating its rendered combo box. This is a
  headless visual-tree setup problem rather than the nested-prefix routing fixed in this wave.
- A newer FreeP unfiltered expectation for the Transitions group remains stale after the upstream
  Rehearse/Record Timings additions.

These residuals remain explicit follow-up work. This wave closes three production parity slices but
does not claim whole-product visual or functional parity.
