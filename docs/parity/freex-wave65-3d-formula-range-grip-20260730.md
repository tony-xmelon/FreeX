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

The focused Linux run passed 1/1. Physical X11 input selected `B2:C3` across
`Sheet2:Sheet3`, resized it from the middle sheet to `B2:D4`, preserved the
complete 3-D qualifier, calculated `171`, and crossed a clean-save boundary.
The probe exercised a 3x3x3 grip-position matrix at 1280x820 and 96 DPI.

Evidence:
`artifacts/linux-interactive/freex/interaction-validation/20260730T074255Z/interaction-validation.json`.

## Residual

The current default harness document is CSV, so physical evidence proves the
interactive edit and clean-save boundary while managed WPF/Avalonia tests
provide native workbook save/reopen proof. A future native-workbook physical
fixture can consolidate those two evidence layers; it is not a missing
production route in this bounded slice.
