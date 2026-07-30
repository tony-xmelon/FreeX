# Avalonia Native Pyramid Full-Rectangle Rendering

## Scope

The imported `chart-smartart-complex.docx` Basic Pyramid is a native `pyramid1`
polygon layout. Avalonia routed it through the generic SmartArt diagnostics frame,
which painted a `SmartArt (List)` caption and reduced the target canvas before the
shared Word-measured geometry could be scaled.

The Avalonia renderer now uses the full authored rectangle for `pyramid1` polygon
geometry and applies the measured 22-DIP inline baseline registration. The generic
frame path remains unchanged for non-pyramid SmartArt.

## Matched Evidence

- Fixture SHA-256: `27B713C819480F4C15DD90DDD13EF3CAB39A705D2E6B6DE3A631D81D53C19B9D`
- Word COM reference: `freew-fidelity-corpus/runs/chart-smartart-word-baseline-20260730/word`
- Candidate: `freew-fidelity-corpus/runs/chart-smartart-word-baseline-20260730/avalonia-pyramid-baseline22-20260731`
- Surface: `816x1056`, matched page 2.

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 2.0918% | 0.7827% |
| Pyramid ROI `(85,105)-(515,320)` | 15.1547% | 3.1577% |
| Base-band ROI `(95,255)-(505,320)` | 37.1497% | 6.5719% |
| Adjacent body paragraph `(85,310)-(735,380)` | 10.1877% | 10.1902% |

The exact `#7F0000` mask moved from `136,129-455,282` to `105,127-486,309`,
toward Word's `105,125-489,309`. Page 1 is SHA-256 byte-identical to the
pre-change Avalonia render.

## Guard

The dispatch requires both `LayoutId == pyramid1` and shared polygon geometry of
kind `Pyramid`, so it does not apply to generic list or process SmartArt paths.
