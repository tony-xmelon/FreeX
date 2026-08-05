# FreeP ChartEx title layout parity

## Scope

This slice closes the functional gap for native ChartEx title placement and alignment.
The model preserves `cx:title/@pos` (`t`, `b`, `l`, `r`) and `cx:title/@align` (`near`,
`ctr`, `far`) separately from the existing overlay flag. Missing source attributes remain
absent and continue to use the ChartEx defaults.

The PPTX reader and writer round-trip the attributes, while the shared chart-options
planner exposes title-side and title-alignment controls only for ChartEx charts. WPF and
Avalonia dialogs consume the same planner and commit through the existing undoable chart
display-options command. Chart cloning carries both fields.

## Evidence

- Native ChartEx package round-trip: authored right/far title reads as `Right`/`Far` and
  edited bottom/near values are emitted and reopen correctly.
- Shared planner contract: right/far values are present in the command plan.
- Command contract: right/far changes apply and undo restores left/near.
- WPF dialog contract: right/far values flow through the shared dialog planner.
- Avalonia dialog contract: right/far values flow through the shared dialog planner.
- WPF and Avalonia Release builds: zero warnings/errors.

This is a functional/package parity slice. It intentionally makes no raster-fidelity claim;
ChartEx title geometry remains a separate visual-rendering concern.
