# Avalonia/WPF parity Wave 63: FreeX quoted formula-reference grip resize

## Scope

FreeX formula-reference grip resizing for a same-sheet reference that is explicitly
qualified with a quoted worksheet name, such as `'Revenue Data'!B2:E5`.

## Implementation

- `FormulaReferenceDragResizePlanner.ApplyResize` now preserves the original token's
  sheet qualifier while replacing only the cell/range portion.
- Quoted qualifiers with escaped apostrophes are preserved verbatim.
- WPF and Avalonia continue to use the shared planner. The WPF grip path now shares its
  text-application helper with the managed test seam.

## Verification

- Shared planner: `7 passed, 0 failed`.
- Avalonia managed grip workflow: `1 passed, 0 failed`; committed quoted formula and
  calculated result `15`.
- WPF managed grip workflow: `1 passed, 0 failed`; committed quoted formula and
  calculated result `15`.
- Linux/X11 physical selector `formula-reference-grip`: `1/1 passed` at `1280x820`.
  The evidence proves sheet rename, before/dragging/committed screenshots, exact quoted
  formula `=SUM('Revenue Data'!B2:C3,'Revenue Data'!D4:F6)`, result `15`, and clean save.
- Physical report: `artifacts/linux-interactive/freex/interaction-validation/20260730T030307Z/interaction-validation.html`.

Undo was not asserted in this slice because the existing grip test seams expose commit and
formula-result state, but do not expose the post-grip command-stack undo operation.

## Remaining FreeX formula-grip work

- Cross-sheet grip resize while formula editing remains open, including active-sheet
  navigation and overlay ownership.
- Physical 3-D sheet-range grip/point proof.
- Broader formula grammar and non-quoted grip variants beyond the covered same-sheet case.
