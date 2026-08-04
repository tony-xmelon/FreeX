# Avalonia Parity Wave 155: FreeX Data Table Dialog

Date: 2026-08-05

## Baseline and finding

`dialog.DataTable` was recaptured from the current WPF and Avalonia sources
before editing with the existing parity harness. Both frames were nonblank,
exactly `360x210` logical pixels, and captured at `96 DPI`.

The fresh same-source baseline measured a triage score of `0.076399`, sample
mean delta `0.044390`, non-background delta `0.030450`, and focused raw pixel
diff `2.6681%`. The retained Wave 146 evidence was previously reported as
`0.100622` and `0.043377`; it is historical context, not the fresh baseline.

Source and visual-tree comparison found three route-owned presentation gaps:
the Avalonia capture seeded `E2`/`F2` while WPF showed empty inputs, generic
Avalonia data-tool controls were `24px` high versus the WPF-sized controls,
and the Avalonia client content extended farther right and lower because of
the extra action-row margin. Labels also inherited the accent foreground.

## Change

The Avalonia Data Table route now uses local `20px` input, picker, and action
control sizing, a WPF-matched content inset, neutral label foreground, and no
additional action-row margin. The parity fixture opens the production dialog
with empty inputs, matching WPF without changing the planner, validation,
focus, range-selection, accessibility, or automation-ID contracts.

## After evidence

The edited Linux Docker/Xvfb capture remained exact `360x210`, nonblank, and
validated with exit `0` at `96 DPI`. The fresh pair measured:

| Metric | Before | After | Change |
| --- | ---: | ---: | ---: |
| Triage score | 0.076399 | 0.061774 | -19.1% |
| Sample mean delta | 0.044390 | 0.022426 | -49.5% |
| Non-background delta | 0.030450 | 0.035701 | +0.005251 |
| Focused pixel diff | 2.6681% | 1.6709% | -37.4% |

The non-background delta increased because Avalonia's native rasterization
still differs from WPF around control borders and text, but the route-owned
triage and focused pixel metrics both improved with no semantic regression.

## Verification

- Avalonia Release build: `0 warnings, 0 errors`.
- `DataTableDialogParitySourceTests`: `2/2` passed.
- `DialogRangeSelectionTests` plus `DataTableDialogParitySourceTests`: `8/8` passed.
- WPF Data Table/parser tests: `23/23` passed.
- Fresh WPF and Avalonia parity captures: exact size, nonblank, exit `0`.
- Focused parity comparison: `2.6681% -> 1.6709%`; no route-owned hard regression.

## Residuals

The remaining difference is primarily WPF versus Avalonia native control and
text rasterization, including picker/button border pixels. Full paired
surface comparison was intentionally not used as the acceptance gate because
the targeted Avalonia capture contains only the assigned route.
