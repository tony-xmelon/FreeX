# Avalonia parity Wave 36

Date: 2026-07-27

## Closed slices

- **FreeX picture crop interaction:** Avalonia now enters the live Picture Format crop mode used by
  WPF, renders the shared eight-handle crop adorner, previews pointer drags, commits through the
  undoable `SetPictureCropCommand`, and exits on Escape, selection change, or cancellation.
- **FreeW Track Changes selection transition:** Avalonia now follows the existing WPF command when
  Track Changes is enabled over a non-empty selection. A shared planner owns the toggle decision,
  while each host retains its native editor mutation path and checked state.
- **FreeP Review Comments action strip:** Avalonia now renders the action controls already supplied
  by the shared comment-pane plan. WPF remains the authority for labels and enabled states.

## Merged verification

- FreeX shared picture-crop planner: 18/18 passed.
- FreeX Avalonia picture-crop runtime: 1/1 passed.
- FreeX WPF picture-crop authority: 3/3 passed.
- FreeW shared Track Changes planner: 4/4 passed.
- FreeW WPF Track Changes production command: 3/3 focused merged checks passed.
- FreeW Avalonia Track Changes production command: 2/2 passed.
- FreeP WPF comment-pane authority: 1/1 passed.
- FreeP Avalonia rendered comment actions: 1/1 passed.

## Residuals

- Three FreeP Animation key-tip tests expose a real nested-menu prefix gap: the exact `Blink=B`
  leaf consumes input before the longer `Blinds In=BI` key tip can be completed.
- The FreeP font-family key-tip case currently fails while locating its rendered combo box, before
  production key-tip routing is exercised.
- A newer FreeP unfiltered expectation for the Transitions group is stale after the upstream
  Rehearse/Record Timings additions.

These residuals are retained as explicit follow-up work. This wave does not claim whole-product
visual or functional parity.
