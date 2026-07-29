# FreeP trigger-only Play From Selected

Date: 2026-07-30

## Closed slice

Animation Pane `Play From Selected` now starts from a selected trigger-only
animation as well as from the normal main click sequence. The shared slideshow
controller builds the selected shape's trigger chain, trims it at the selected
entry, and exposes that chain as the first pending playback steps. Earlier main
sequence animations remain skipped. Ordinary trigger clicks continue to use the
existing per-trigger cursor and are unchanged.

## Evidence

- WPF controller regression covers a selected trigger group with `WithPrevious`
  and a later `OnClick` step.
- Avalonia headless slideshow-route regression confirms the same trigger group
  is the first playback step.
- No rendering calibration or host-specific controller logic was added.

## Remaining boundary

PowerPoint-authoritative timing/easing/frame capture for animation playback still
requires a desktop PowerPoint baseline. This slice closes the route-selection
semantics only.
