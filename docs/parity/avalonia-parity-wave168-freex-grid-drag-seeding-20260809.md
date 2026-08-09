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
clipboard owner before the physical edit. Non-empty seeds retain the existing
formula clipboard verification path.

## Verification

- Focused source regression: `GridDragSeedHelper_UsesEmptyAwareClipboardVerification`.
- `git diff --check`: passed.
- Docker proof remains deferred until the host has at least 6 GB free RAM and no
  active Wave168 build; the exact command is
  `Run-FreeXLinuxInteractionValidation.ps1 -PhysicalOnly -PhysicalProbeSelector grid-drag`.

## Residuals

The post-change physical X11 run and its before/after drag screenshots remain open.
