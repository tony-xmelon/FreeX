# FreeP authored glow alpha calibration

Date: 2026-07-17

## Scope

The shape-effect planner emitted each glow ring at `GlowAlpha / (passes + 1)`. Because the rings are composited over one another, that under-filled the authored opacity. The planner now derives a per-ring alpha that composes back to the requested glow alpha. The change is renderer-neutral; the WPF stock fallback selection also remains owned by `ChartScenePlan` so renderer-local chart-type probes stay covered by the deduplication guard.

## Verification

Fresh 1280x720 renders of `08-effects.pptx` against the persistent PowerPoint COM corpus:

- WPF whole page: `1.5290%` to `1.5216%`
- Avalonia whole page: `1.4956%` to `1.4876%`
- WPF glow ROI `(555,90)-(905,340)`: `1.8580%` to `1.7693%`
- Avalonia glow ROI `(555,90)-(905,340)`: `1.8711%` to `1.7772%`
- Broad effects ROI `(80,70)-(1250,350)`: WPF `3.3288%` to `3.3080%`; Avalonia `3.3904%` to `3.3680%`

The `12-fills.pptx` no-glow control was byte-identical for both WPF and Avalonia before and after the change. Focused `RendererNeutralDedupPlannerTests` passed `19/19`; the focused glow test passed `1/1`; and the `FreeP.RenderCompare` Release build completed with zero warnings and errors.
