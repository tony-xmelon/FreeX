# FreeP Avalonia parity Wave 55

## Accessibility slice

The WPF Selection Pane gives each authored-object control a spoken tooltip: select,
rename, show/hide, move toward front, and move toward back. Avalonia was missing the
rename tooltip and kept the other descriptions as host-local literals. The shared
`PresentationSelectionPanePlanner` now owns these renderer-neutral descriptions, and
both hosts consume the same metadata.

The Avalonia headless test renders the live Selection Pane for authored shapes and
checks every rename `TextBox` tooltip against the shared planner value. This is
deterministic accessibility evidence; no Linux UIA evidence was added because the
current Linux harness does not expose a stable cross-platform accessibility tree.

## Verification

- `FreeP.App.Presentation.Tests`, filtered to `SelectionPaneTests`: 10 passed.
- `FreeP.App.Avalonia.Tests`, filtered to the Selection Pane source guard and live
  rename-tooltip test: 2 passed.
- `FreeP.App.Host.Tests`, filtered to `SlidePanePolicySourceGuardTests`: 1 passed.
- All focused builds completed with 0 compiler errors.

## Residuals

- The slide thumbnail item itself still relies on the host's default item name; the
  planner already has a richer thumbnail `AccessibleName`, but neither host assigns
  it to the live thumbnail container. That is the next bounded slide-pane accessibility
  slice.
- Notes, Selection Pane headings, and the adjacent authored panes do not yet have a
  complete cross-host accessibility snapshot contract.
