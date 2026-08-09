# FreeX Wave168: deterministic grid-drag seeding

## Residual

The Wave167 inline-edit focus continuation fix unblocked the physical `grid-drag`
selector, but its move and Ctrl-copy setup still cleared destination cells through
the generic X11 clipboard readback helper. An empty Avalonia editor does not replace
the X11 clipboard owner after Ctrl+C, so that helper could observe the previous
cell's value and make a valid clear look like a failed seed.

## Implementation

`set_cell_text_without_save` now skips empty `xdotool type` packets and verifies an
empty cell with `copy_cell_formula_allow_empty`, which installs a bounded sentinel
clipboard owner before the physical edit.

The integrated follow-up run `20260809T135428799Z` proved that empty handling was
not the first failure: C3 committed `10`, Enter advanced to C4, and the immediate
pointer reselection of C3 used for readback never changed the active cell. Seed
verification now uses the existing absolute keyboard route (Ctrl+Home plus arrows)
after Enter restores worksheet focus. Non-empty and empty readback share that route;
empty values still use the bounded clipboard sentinel.

## Verification

- `GridDragSeedHelper_UsesKeyboardReadbackAndEmptyAwareClipboardVerification`:
  passed, 1/1.
- `git diff --check`: passed.
- `powershell -NoProfile -ExecutionPolicy Bypass -File
  tools/Run-FreeXLinuxInteractionValidation.ps1 -PhysicalOnly
  -PhysicalProbeSelector grid-drag -TimeoutMinutes 20`: passed, 3/3, session
  `20260809T140830970Z`.
- Autofill produced `C3:C7 = 10,20,30,40,50`; move cleared E3:E4 and produced
  `E6:E7 = MoveTop,MoveBottom`; Ctrl-drag preserved G3:G4 and produced
  `G6:G7 = CopyTop,CopyBottom`. All three destination selections passed and all six
  before/after screenshots were retained.

## Residuals

The focused grid-drag selector is closed. The broader physical selector inventory
was not rerun in this follow-up.
