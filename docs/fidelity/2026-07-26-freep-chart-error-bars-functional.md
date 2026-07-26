# FreeP chart error bars: functional parity slice

## Included

- Per-series error-bar state in the shared chart model.
- X/Y direction, plus/minus/both extent, fixed or percentage value, and no-end-cap state.
- `c:errBars` read/write for the bounded fixed/percentage value form.
- Working-copy planner and Series Options controls in WPF and Avalonia.
- Command apply/revert and slide cloning preserve the authored settings.
- Shared chart-scene primitives and WPF/Avalonia line-and-cap painting for line,
  column, bar, scatter, and bubble charts.

## Verification

- Package round-trip and canonical chart-XML tests cover all settings.
- Presentation planner/command focused lane: 96 passed.
- Shared chart planner lane: 196 passed, including rendered endpoint geometry.
- Avalonia canvas pixel smoke test: 1 passed.
- WPF host chart-dialog lane: 37 passed.
- Avalonia host chart-series lane: 1 passed.
- WPF and Avalonia Release consumers build with zero warnings/errors.

## Deliberate boundary

Area, stock, and radar-specific error-bar geometry remain intentionally unimplemented;
their authored state still round-trips without being painted until those chart families
have an explicit axis/point ownership rule.
