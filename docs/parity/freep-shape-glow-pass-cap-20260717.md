# FreeP shape glow pass cap

The imported `08-effects.pptx` glow uses a `16 DIP` radius. The shared shape
effect planner previously capped the glow at five concentric passes, which
left visible ring bands in both renderers. The cap is now eight passes; the
existing per-pass alpha composition still reaches the authored glow opacity.

## Matched COM evidence

At `1280x720` against a fresh PowerPoint export:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF whole page | 1.5216% | 1.5040% |
| WPF glow ROI `(555,90)-(905,340)` | 1.8580% | 1.5898% |
| Avalonia whole page | 0.4488% | 0.4476% |

The ROI values are raw RGB mean-channel deltas against the persistent COM
image. The no-glow `12-fills.pptx` control is SHA-256 byte-identical for both
WPF and Avalonia. A `10`-pass cap produced the same pixels as eight passes for
the measured `16 DIP` fixture, so eight is retained as the narrow calibrated
cap.

## Verification

- `FreeP.RenderCompare` Release build: `0` warnings, `0` errors.
- Matched COM render completed successfully for the target and control.
