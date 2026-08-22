# Avalonia parity Wave 174: FreeX functional physical slice

Date: 2026-08-22

## Scope

This wave makes the FreeX Linux physical probes independent of the ribbon's
pixel layout for View > Split and makes nested outline readback address-aware.
The changes preserve the exact structural and value assertions; they do not
turn an unobserved physical postcondition into a pass.

## Changes

- `tools/LinuxInteractiveDocker/run-freex-input-probes.sh` now activates Split
  through the canonical `WSP` key-tip route instead of the fixed `(925,98)`
  ribbon coordinate.
- The same probe now reads nested row and column values through the production
  Go To address route (`Ctrl+G`, exact worksheet address, formula copy). This
  applies to nested group, save/reopen, and filter/save/reopen lanes, including
  the values read while detail rows or columns are hidden.
- `AvaloniaRibbonRenderer.TryActivateKeyTip` now raises the normal button click
  event for toggle controls. Directly assigning `IsChecked` changed only the
  visual state and bypassed the host command handler, which is a real shared
  renderer defect affecting View > Split.

## Evidence

- Wave104 remains the authority for the original physical split workflow: 4/4
  rows passed at 1280x820 and 96 DPI.
- The two completed Wave174 Docker/X11 split runs at the same target, using the
  new WSP probe route, both recorded 0/4 (`20260822T032258Z` and
  `20260822T032719Z`). The View tab was reached, but no completed physical run
  after the renderer fix is available: the subsequent Docker run was stopped
  before completion at the user's request. Split therefore remains unresolved
  against Wave104; this note does not claim physical parity.
- Focused source contract coverage passed 18/18 in
  `LinuxFreeXInteractionValidationToolTests`, including the exact-address
  nested probe assertions.
- Shared Avalonia ribbon key-tip coverage passed 5/5 in
  `AvaloniaRibbonKeyTipBadgeTests`, including the toggle command-click
  regression.
- `git diff --check` passed for the owned changes. The full solution/default
  lane was intentionally not run.

## Remaining

1. Complete fresh Docker/X11 evidence for `split-pane-pointer` after the
   renderer fix and reconcile its four physical rows with Wave104.
2. Run `outline-nested-group` and
   `outline-nested-filter-save-reopen` physically to validate the new exact
   address readback against collapsed and persisted outline state.
3. Re-run the focused grid-drag and grid-autofit physical lanes before closing
   the wave, preserving their existing passing authority.
