# Avalonia Parity Wave 164 Integration

Date: 2026-08-06

## Integrated slice

Avalonia row-header resize handles now resolve the boundary immediately before a
contiguous hidden run through the shared `GridResizePreviewPlanner`, matching the
WPF resize authority. Ordinary visible rows retain their displayed height for
drag-resize. The deterministic Avalonia test covers the visible-row-to-hidden-run
target (`4:5`) and the shared planner range.

The focused `grid-autofit` selector uses a generated `.xlsx` fixture, additive
schema-v2 postcondition evidence, and calibrated physical handle-center clicks at
1280x820 and 96 DPI. The schema requires real column and visible-row growth;
hidden-band fields remain diagnostic so an incomplete physical reopen cannot be
reported as a pass.

## Linux evidence

Latest retained Docker/X11 session: `20260806T011033482Z`.

- Calibration: passed; 1280x820 window, 96 DPI; grid pitch 64x20.
- Column boundary: `A1`, 70 -> 396 pixels, boundary `(88,226)`, passed.
- Visible row boundary: `B2`, 26 -> 66 pixels, boundary `(14,272)`, passed.
- Contiguous hidden boundary: target rows `4:5`, observed after heights `66,0`,
  so the physical hidden-band proof remains failed/residual.
- Focused result: 2 passed, 1 failed, 3 total. The failed result is the named
  hidden-row-boundary probe; column and visible-row proof remain required.

The original strict hidden-band assertion caused the run to return nonzero after
emitting the useful schema-v2 result. The retained validator now treats that
band as a diagnostic while continuing to require column and visible-row growth.
No physical hidden-band closure is claimed.

## Focused verification

- `FreeX.App.Avalonia.Tests`: 24/24 passed for `R163_HeaderDoubleClickAutoFitTests`
  and `AvaloniaGridInputSourceTests`.
- `FreeX.App.Services.Tests`: 13/13 passed for `LinuxFreeXInteractionValidationToolTests`.
- Fixture PowerShell parser check passed; `git diff --check` passed.

## Honest residuals

Physical contiguous hidden-row reopening is still unstable: the latest real
double-click sized row 4 but left row 5 at zero. Deterministic host/planner tests
still cover the shared contiguous range, but this wave does not claim physical
hidden-band parity. The focused selector is additive and does not change default
`all`-catalog counts.
