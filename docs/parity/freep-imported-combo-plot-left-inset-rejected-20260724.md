# FreeP imported combo plot-left inset probe rejected

Date: 2026-07-24

## Scope

The imported `19-chart-labels.pptx` combo chart (`Column + Units` on a
secondary axis) looked a few pixels left of the PowerPoint plot frame in the
fresh 1280x720 comparison. The probe increased the exact imported-combo plot
left inset from 2 DIP to 4 DIP. No other chart family used the candidate.

## Evidence

The candidate was built into the consuming Release RenderCompare artifact and
compared against a fresh PowerPoint COM export with matching 1280x720
provenance:

| Metric | Baseline | Candidate |
| --- | ---: | ---: |
| WPF slide 1 | 1.3784% | 1.3784% |
| WPF slide 2 | 0.6240% | 0.6240% |
| WPF slide 3 | 1.6479% | 2.1840% |
| WPF deck average | 1.2168% | 1.3954% |
| Avalonia deck average | 0.6090% | 0.6090% |

The candidate was reverted. The plot-origin impression is not an actionable
translation: the existing bar and line registration depends on the current
plot frame, while the residual is chiefly axis/text rasterization.

## Verification

- Focused imported-combo planner tests: 2/2 compiling and 2/2 no-build.
- Release RenderCompare build: 0 warnings, 0 errors.
- Fresh WPF/Avalonia/PowerPoint export: 3/3 slides.
- Final product source restored to the baseline inset of 2 DIP.
