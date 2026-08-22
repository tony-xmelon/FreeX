# Avalonia Parity Wave 172: FreeW Draw Table Dimensions

## Scope

This slice covers the WPF/Avalonia `draw-table-dimension` route and its
`initial`, `populated`, and `validation-error` states. WPF remains the
authority; visual thresholds, crops, classifications, and authority capture
policy were unchanged.

## Current-source diagnosis

The fresh WPF route-local capture produced all three states with the same
semantics:

- Focus: `DrawTableRowsTextBox`
- Default action: `OK`
- Cancel action: `Cancel`
- Action order: `OK`, `Cancel`

The fresh Avalonia run initially failed before rendering because the generic
reflection adapter could not construct the private plan-based
`DrawTableDimensionDialog` constructor. The dialog implementation already
declared the WPF-equivalent focus, default, cancel, and action-order policy;
the missing piece was an app-owned visual-harness constructor. The adapter now
uses the production planner and dialog constructor, so the evidence is
current-source evidence rather than a placeholder or stale capture.

## Evidence

| State | Before canonical classification | Before semantic difference | After classification | After semantic difference | After changed pixels | After mean channel delta | pHash distance |
| --- | --- | --- | --- | --- | ---: | ---: | ---: |
| `initial` | `semantic-mismatch` | `default-button,cancel-button,action-button-order` | `pass` | none | 4239 / 336000 (1.261607%) | 1.456086 | 2 |
| `populated` | `semantic-mismatch` | `default-button,cancel-button,action-button-order` | `pass` | none | 4239 / 336000 (1.261607%) | 1.456086 | 2 |
| `validation-error` | `semantic-mismatch` | `default-button,cancel-button,action-button-order` | `pass` | none | 4591 / 336000 (1.366369%) | 1.575988 | 2 |

The route-local comparison is therefore `pass` for all three states, with no
remaining semantic difference. The residual pixel delta is below the existing
visual mismatch threshold and is not used to change classification.

## Implementation and verification

- Added `DrawTableDimensionDialog.CreateForVisualHarness()` so the harness
  constructs the production plan-backed Avalonia dialog.
- Routed the visual harness's `draw-table-dimension` route through that
  app-owned constructor.
- Added a focused headless test covering WPF-equivalent action order,
  default/cancel flags, row-field automation ID, and initial focus.
- Route-local WPF capture: 3/3 captured.
- Route-local Avalonia capture: 3/3 captured.
- Focused test: `DrawTableDimensionDialogParityTests`, 1 passed.

## Next mismatch

The next FreeW semantic cluster should be selected from the refreshed
current-source comparison after this route is merged into the canonical
aggregate. Do not infer the next target from the pre-refresh row ordering.
