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
  Go To address route. It requires a distinct Go To dialog, submits the exact
  worksheet address, focuses the formula bar through `Ctrl+F2`, and requires
  Copy to replace a bounded sentinel clipboard owner. This applies to nested
  group, save/reopen, and filter/save/reopen lanes, including values read while
  detail rows or columns are hidden.
- `AvaloniaRibbonRenderer.TryActivateKeyTip` now raises the normal button click
  event for toggle controls. Directly assigning `IsChecked` changed only the
  visual state and bypassed the host command handler, which is a real shared
  renderer defect affecting View > Split.

## Evidence

- A fresh post-fix Docker/X11 Split run passed 4/4 at 1280x820 and 96 DPI.
  The authoritative report is
  `artifacts/linux-interactive/freex/interaction-validation/20260822T033931Z/interaction-validation.json`.
- A fresh nested Group/Outline run passed 2/2 at the same target. Real row and
  column header drags created inner and outer levels; both collapse/expand
  cycles passed and all seeded values read back exactly. The authoritative
  report is
  `artifacts/linux-interactive/freex/interaction-validation/20260822T044323Z/interaction-validation.json`.
- Focused source contract coverage passed 18/18 in
  `LinuxFreeXInteractionValidationToolTests`, including the exact-address
  nested probe assertions.
- Shared Avalonia ribbon key-tip coverage passed 5/5 in
  `AvaloniaRibbonKeyTipBadgeTests`, including the toggle command-click
  regression.
- Bash syntax validation and `git diff --check` passed for the owned changes.

## Remaining

1. Run `outline-nested-filter-save-reopen` physically to extend the exact
   address proof across filter and persistence state.
2. Re-run the focused grid-drag and grid-autofit physical lanes in a later
   regression wave; this Wave174 run did not replace their existing passing
   authority.
3. Run the final solution build and default test gates before integration.
