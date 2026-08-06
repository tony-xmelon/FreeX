# Avalonia Parity Wave 165 Integration

Date: 2026-08-06

## FreeX hidden-row AutoFit slice

The Avalonia row-header parent and overlay handle now share the resolved target
for a boundary immediately before a contiguous hidden run. A first press on
that collapsed boundary is consumed instead of starting a zero-size resize
capture; the second press can therefore reach the real contiguous AutoFit path
for rows `4:5`. The deterministic host coverage also pins the planner range and
the first-press capture guard.

The physical probe retains its strict schema-v2 contract. Its B5 follow-up now
uses the calibrated handle inset when translating the outlined B4 height into
the next row's selection origin. This corrects the measured selection-outline
geometry; it does not relax any positive-height, unhidden, or selector-count
assertion.

## Bounded physical evidence

All sessions used the production Avalonia desktop at 1280x820 and 96 DPI. No
session produced an authoritative focused `3 passed, 0 failed` result, so Wave
165 does **not** claim physical selector closure.

The two resumed attempts were bounded as follows:

- `20260806T024559831Z`: calibration passed; column `70 -> 70`, visible row
  `26 -> 26`; hidden rows reached `66,66`, `hiddenRowsAfter=[]`,
  `unhidden=true`, and `sized=true`. Strict selector result: `0/3`.
- `20260806T025241981Z`: interrupted before manifest completion; its retained
  postcondition also recorded hidden rows `66,66` and `hiddenRowsAfter=[]`,
  while column and visible row remained `70 -> 70` and `26 -> 26`. It is not
  credited as a selector result.

Earlier retained attempts show the same bounded input-injection residual: the
calibrated column and visible-row double-clicks intermittently did not trigger
growth, while the corrected hidden-row interaction reached both positive row
heights. The remaining failure is flaky X11 input injection for the column and
visible-row cases, not evidence to weaken the gate around hidden rows.

## Focused verification

- `FreeX.App.Avalonia.Tests`: 25/25 passed, including the row-header source and
  hidden-boundary AutoFit regressions.
- `FreeX.App.Services.Tests`: 13/13 passed, including the strict selector/tool
  contract and corrected B5 geometry assertion.
- `git diff --check`: passed.

## Honest residual

Physical hidden-row AutoFit now has genuine retained evidence of rows `4:5`
becoming positive `66,66` and unhidden through the user interaction. The strict
focused selector remains open because the bounded X11 runs did not obtain
column growth and visible-row growth in the same authoritative manifest. No
`3 passed, 0 failed` selector closure is claimed in this wave.
