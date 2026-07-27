# Avalonia parity Wave 35

Date: 2026-07-27

## Scope

Wave 35 closed one verified WPF-over-Avalonia functional gap in each app:

- FreeX Chart Design > Combo Chart now uses WPF's immediate shared
  `ComboToggle` command path instead of opening the separate Avalonia
  per-series dialog.
- FreeW Read Mode now exposes the seven WPF routes and follows the same
  chrome, pane, editor-presentation, width, color, and restoration lifecycle.
- FreeP Custom Shows now cancels a slide reorder when pointer capture is lost
  or the drag is released outside the slide list, matching WPF.

The Options iteration-validation fix on current main was also independently
rechecked. Disabled iterative calculation accepts empty disabled bounds without
opening the modal warning that previously hung the WPF UI test; enabled
iterative calculation still validates both bounds.

## Evidence

### FreeX

- Avalonia runtime/source tests: 3/3 passed.
- WPF authority test: 1/1 passed.
- Shared Combo Toggle planner tests: 5/5 passed.
- The runtime test executes the production contextual command, verifies undo,
  and covers a loaded one-series combo chart that the per-series dialog cannot
  reopen.
- Detailed evidence:
  `docs/parity/freex-chart-combo-toggle-wave35-20260727.md`.

### FreeW

- Shared Read Mode planner tests: 9/9 passed.
- Avalonia headless runtime tests: 2/2 passed.
- WPF authority test: 1/1 passed.
- The runtime tests verify mixed pane-state restoration, unchanged document
  view mode, transient page color, unchanged persisted page color, option
  commands, and the stateful toggle.
- The generated command inventory moves all seven Read Mode routes from
  WPF-profile-only to shared-profile; actionable command gaps remain zero.
- Detailed evidence:
  `docs/parity/freew-read-mode-functional-parity.md`.

### FreeP

- Focused Avalonia runtime tests: 2/2 passed.
- Focused WPF authority tests: 2/2 passed.
- The Avalonia test uses a real pointer-capture lifecycle and verifies that
  capture loss and an outside-list release do not mutate the custom show.
- The worker's broad WPF suite passed 1,687/1,687. Its broad Avalonia run
  reported 425 passes and five pre-existing failures; the focused changed
  behavior is green and no broad-suite parity claim is made.
- Detailed evidence:
  `docs/parity/freep-custom-show-drag-wave35-20260727.md`.

## Residuals

This wave does not establish whole-product or pixel-perfect parity. FreeX's
full per-series Combo Chart dialog remains a separate Avalonia route. FreeW
retains host-native editor width/effect differences documented in its detailed
note. FreeP native drag visuals and insertion-indicator polish remain
platform-specific follow-up work, and its five existing broad Avalonia test
failures still require independent triage. The overall Avalonia parity goal
remains active.
