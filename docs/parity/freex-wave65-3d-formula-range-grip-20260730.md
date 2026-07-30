# FreeX Wave 65: 3-D formula range highlight and grip parity

Date: 2026-07-30

## Scope

This slice closes the FreeX residual where formula-reference highlighting and
grip editing understood only one sheet qualifier. The shared planner now
parses normal and 3-D qualifiers, including unquoted spans, quoted whole-span
names, separately quoted endpoints, escaped apostrophes, and reverse spans.

Both WPF and Avalonia pass workbook sheet order into the same planner. A 3-D
reference is projected onto the active worksheet only when that worksheet lies
inside the inclusive endpoint span. The scanner consumes the complete token
even when it is outside the active span, so its A1/range body cannot be
rediscovered as a false local highlight.

## Managed coverage

- Shared planner tests cover forward and reverse unquoted spans, quoted and
  escaped names, outside-span suppression without scanner leakage, and the
  intentional endpoint-only behavior of the legacy overload without sheet
  order.
- Shared grip rewriting preserves the exact qualifier and changes only the
  cell/range suffix.
- WPF and Avalonia host tests physically exercise a middle-sheet highlight and
  grip resize, commit the formula, calculate across both referenced sheets,
  and round-trip the Avalonia fixture through the native adapter.

## Linux/X11 evidence

The existing `formula-3d-point` selector remains unchanged. The new opt-in
`formula-3d-grip` selector extends the production X11 route with a multi-cell
point selection and a middle-sheet grip resize. Run it with:

```bash
FREEX_X11_PROBE_SELECTOR=formula-3d-grip \
  bash /tmp/run-freex-input-probes.sh /work/x11-validation
```

The selector emits `formula-3d-grip-*.png` and
`formula-3d-grip-postcondition.txt`, and the PowerShell runner requires the
`formula-bar-point-mode-3d-sheet-range-grip` row when focused mode is chosen.
Docker execution is environment-dependent and is reported separately from
the managed/source gates.

## Residual

The focused X11 selector must still be run in a FreeX Linux container with a
workbook format that preserves formulas across an actual save/reopen cycle.
The current default harness document is CSV, so the selector records the
clean-save boundary while managed tests provide the native save/reopen proof.
