# FreeP chart error bars: functional parity slice

## Included

- Per-series error-bar state in the shared chart model.
- X/Y direction, plus/minus/both extent, fixed or percentage value, and no-end-cap state.
- `c:errBars` read/write for the bounded fixed/percentage value form.
- Working-copy planner and Series Options controls in WPF and Avalonia.
- Command apply/revert and slide cloning preserve the authored settings.

## Verification

- Package round-trip and canonical chart-XML tests cover all settings.
- Presentation planner/command focused lane: 96 passed.
- WPF host chart-dialog lane: 37 passed.
- Avalonia host chart-series lane: 1 passed.
- WPF and Avalonia Release consumers build with zero warnings/errors.

## Deliberate boundary

This slice establishes authoring and package/function parity. Drawing error-bar primitives into each chart renderer, including chart-type-specific value-axis geometry and caps, remains a separate visual-parity slice. No visual claim is made by this functional change.
