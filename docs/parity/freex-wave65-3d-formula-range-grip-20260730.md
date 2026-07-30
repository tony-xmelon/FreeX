# FreeX Wave 65: 3-D formula range highlight and grip parity

Date: 2026-07-30

## Scope

This slice closes the FreeX residual where formula-reference highlighting and
grip editing understood only one sheet qualifier. The shared planner now
parses normal and 3-D qualifiers, including unquoted spans, quoted whole-span
names, escaped apostrophes, and reverse spans. The native workbook fixture and
focused probes use Excel's whole-span spelling, for example
`'O''Brien Data:Revenue Data'!B2:D4`; separately quoted endpoints are not part
of this parity slice.

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

The existing `formula-3d-point` and `formula-3d-grip` selectors remain
unchanged. The new opt-in `formula-3d-native-xlsx` selector starts from a real
`.xlsx` fixture, points and resizes the 3-D formula, saves, reopens the workbook
through the visible Open flow, and inspects the saved OOXML package. Run it
with:

```bash
powershell -File tools/Run-FreeXLinuxInteractionValidation.ps1 \
  -PhysicalOnly -PhysicalProbeSelector formula-3d-native-xlsx
```

The runner creates `freex-wave66-native-3d.xlsx` when no physical document is
supplied. The selector emits point, middle-sheet, dragging, saved, and
post-reopen screenshots plus `formula-3d-native-xlsx-postcondition.json`.
The PowerShell runner strictly validates that JSON against
`tools/LinuxInteractiveDocker/freex-native-3d-formula-validation.schema.json`,
including the exact formulas/results, clean-save state, physical reopen, and
native ZIP formula/cache state.

The focused Linux run passed 1/1. Physical X11 input selected `B2:C3` across
`'O''Brien Data:Revenue Data'`, resized it from the middle sheet to `B2:D4`,
preserved the complete 3-D qualifier, calculated `234`, and crossed a
clean-save and physical reopen boundary.

## Evidence status

Managed WPF and Avalonia native-adapter round trips are covered. The native
XLSX physical route passed its focused Linux/X11 run with strict postcondition
and package validation. Evidence is retained at
`artifacts/linux-interactive/freex/interaction-validation/20260730T090138Z/`.
The run reported point
`=SUM('O''Brien Data:Revenue Data'!B2:C3)` as `88`, resized
`=SUM('O''Brien Data:Revenue Data'!B2:D4)` as `234`, and the same formula/result
after reopen with a valid XLSX package cache.
