# FreeP imported Radar legend line keys

Date: 2026-07-17

## Scope

The imported Radar chart in `18-chart-types.pptx`, slide 3, uses line-only
legend keys for its marker-style series. FreeP previously rendered generic
filled square swatches.

## Change

The shared legend plan now marks imported non-filled Radar series as line-only
keys. WPF and Avalonia render the measured `29`-DIP key envelope with a
`38`-DIP row spacing and the Radar-specific vertical placement. Combo-chart
line keys retain their existing line-plus-marker behavior.

## Fresh COM comparison

At `1280x720`:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF slide 3 | 1.2423% | 1.2163% |
| Avalonia vs PowerPoint, slide 3 | 1.1969% | 1.1763% |
| WPF deck average | 0.8743% | 0.8681% |
| Avalonia vs PowerPoint, deck average | 0.8455% | 0.8403% |

The final WPF line-key pixels match PowerPoint's measured key bounds:
`x=1124..1151`, `y=359..362` and `y=397..400`.

## Verification

- `193` focused chart planner/baseline tests passed.
- `FreeP.RenderCompare` built with `0` warnings and `0` errors.
- `git diff --check` passed.
