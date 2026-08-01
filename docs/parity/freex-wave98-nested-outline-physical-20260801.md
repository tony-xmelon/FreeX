# FreeX Wave 98 Nested Outline Physical Parity

Date: 2026-08-01

## Slice

Wave 97 proved one-level row and column Group/Outline interaction through the rendered
Avalonia controls. This slice extends that physical contract to two-level nesting on both axes.

The focused `outline-nested-group` selector now:

1. Seeds five distinct row values and five distinct column values through the production inline
   editor.
2. Creates an outer row group (`10:14`) and inner row group (`11:12`) through real row-header drags
   and the shared row context-menu Group command.
3. Creates an outer column group (`H:L`) and inner column group (`I:K`) through physical header
   drags and the shared column context-menu Group route.
4. Derives A1 from the startup origin plus the renderer's fixed 26-DIP and 40-DIP gutter depths,
   then verifies button chrome at the stable level centers before accepting each command or click.
5. Proves each collapse structurally: the inner summary value must move into the first vacated
   visible slot, and a separately seeded outer summary must move into the outer group's slot.
6. Reads every seeded detail value back through the physical formula-editor/clipboard path after
   both axes have returned to the expanded state.

The manifest records independent `outline-nested-rows-group-physical` and
`outline-nested-columns-group-physical` rows. The focused PowerShell selector and the default
`all` lane require both rows and verify every retained screenshot/postcondition artifact.

## Verification

The source contracts cover selector dispatch, both axes, level-specific toggle sequencing,
deterministic post-group geometry, popup-stack dismissal, exact visible-slot transitions, and
default-lane wiring. A focused Avalonia layout test also arranges both nested row and column toggle
levels and asserts their controls have nonzero, in-bounds rendered geometry. The failed runtime
evidence showed probe-route defects, not an overlay defect: the former row key sequence never
created a group, and later attempts inferred A1 from arbitrary active selections after whole-header
selection. Outline origins now come only from the calibrated startup origin and proven depth.

The earlier one-level probes now use the same row-header/context-menu path and structural
visible-slot assertions, removing their generic green-pixel and whole-screen-change assumptions.
Parent integration owns the Docker/X11 execution; this worktree does not run Docker.

The completed raw X11 session at
`artifacts/linux-interactive/freex/sessions/20260801T165229282Z/x11-validation` passed both nested
row and nested column results (`2/2`, zero failures). Report packaging now copies every exact
evidence file through the same `\\?\`-prefixed .NET path used by the native Name Box evidence,
including `selection-outline-nested-column-inner-collapsed-visible-slot.png`, which exceeded the
legacy Windows `MAX_PATH` limit under the timestamped report directory.

Focused runtime command for the parent-owned physical lane:

```powershell
powershell -File tools/Run-FreeXLinuxInteractionValidation.ps1 -PhysicalOnly -PhysicalProbeSelector outline-nested-group
```

## Remaining Risk

The parent must rerun report packaging, preferably with `-SkipX11 -ExistingX11Manifest` against the
passing raw manifest. Save/reopen persistence and filtered-range nesting remain outside this slice.
