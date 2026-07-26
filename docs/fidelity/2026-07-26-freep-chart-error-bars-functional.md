# FreeP chart error bars: functional parity slice

## Included

- Per-series error-bar state in the shared chart model.
- X/Y direction, plus/minus/both extent, fixed or percentage value, and no-end-cap state.
- `c:errBars` read/write for the bounded fixed/percentage value form.
- Working-copy planner and Series Options controls in WPF and Avalonia.
- Command apply/revert and slide cloning preserve the authored settings.
- Shared chart-scene primitives and WPF/Avalonia line-and-cap painting for line,
  column, bar, area, stock, scatter, bubble, and radar charts. Radar value bars
  follow the authored spoke rather than using a screen-axis approximation.

## Verification

- Package round-trip and canonical chart-XML tests cover all settings.
- Presentation planner/command focused lane: 198 passed.
- Shared chart planner lane: 196 passed, including rendered endpoint geometry.
- Avalonia canvas pixel smoke tests: 2 passed.
- WPF host chart-dialog lane: 37 passed.
- Avalonia host chart-series lane: 1 passed.
- WPF and Avalonia Release consumers build with zero warnings/errors.

## Deliberate boundary

Pie, doughnut, and surface-specific error-bar geometry remain outside this slice. Their
authored state still round-trips without being painted because those families do not
have a compatible Cartesian point ownership rule.
