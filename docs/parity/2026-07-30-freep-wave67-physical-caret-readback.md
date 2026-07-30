# FreeP Wave67: Physical semantic caret readback

## Scope

The grouped-child Linux caret fixture now uses a caret-specific native PPTX
with two paragraphs, two native runs per paragraph, unequal-width wrapped visual
lines, and a taller text shape. The existing five-row physical contract is
unchanged.

The X11 probe reads the system clipboard with bounded `xclip` commands after
Shift+Down and Shift+Up sequences. Expected and observed text are stored as
separate byte artifacts and must match exactly. A stale clipboard, missing
`xclip`, timeout, or missing artifact fails the lane.

## Physical evidence

The final run passed 5/5 rows with strict host validation:

- `grouped-caret-selection`: `oxtrot golf hot`
- `grouped-caret-vertical-down`: `oxtrot golf hot`
- `grouped-caret-vertical-roundtrip`: `charlie delta echo foxtrot golf hot`
- reopen: `Child 1 has\n speaker notes`, after physical `Ctrl+O`, dialog close,
  exact clipboard readback, and a reopened screenshot

Evidence:
`artifacts/w67r4/freep/sessions/20260730T102042073Z/freep-rich-text-shortcut-validation/results.json`.

The host runner validates the exact five result IDs, the xclip transcript
metadata and bytes, the reopen proof flags, and all referenced artifacts. The
manifest remains schema version 1; semantic readback is an additive conditional
field for the grouped-caret surface.

## Managed parity

- Shared presentation navigation tests: 4 passed.
- Avalonia rich-text navigation tests: 4 passed.
- WPF STA vertical navigation tests: 2 passed.

No product defect was exposed by the physical readback. The Avalonia route and
the existing shared preferred-X planner remained unchanged.

## Residuals

Clipboard text proves the resulting selection range and therefore the observable
effect of the vertical movement, but it does not expose a numeric caret offset
or pixel X coordinate. The managed shared/Avalonia tests remain the direct
preferred-X semantic proof. The physical screenshots are visual diagnostics,
not semantic evidence or pixel-level WPF equivalence.
