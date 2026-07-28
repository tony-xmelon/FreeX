# FreeP Chart Manual Layout Target Semantics - 2026-07-30

## Scope

`c:manualLayout/c:layoutTarget` is an authored chart-layout semantic, not
decorative metadata. The chart planner now distinguishes the `inner` target
(the automatically resolved plot or legend frame) from the `outer` target
(the containing chart frame). Missing or unknown targets retain the previous
outer-frame fallback.

## Behavior

- Plot-area manual layouts with `layoutTarget=inner` resolve their x/y/width/
  height values inside the automatic plot frame, which excludes the axis and
  label bands already reserved by the chart planner.
- Legend manual layouts with `layoutTarget=inner` resolve inside the automatic
  legend frame.
- `outer`, omitted, and unknown values resolve against the chart frame, while
  factor and edge coordinate modes retain their existing semantics.
- WPF and Avalonia continue to consume the same renderer-neutral rectangles.

## Verification

- `ChartRenderPlannerTests` covers inner plot and legend frames plus the
  existing outer and mixed factor/edge cases.
- Existing chart package round-trip coverage continues to assert the authored
  `layoutTarget` token survives read/write.

This is a functional/layout-semantics correction. It does not claim a new
PowerPoint-authoritative pixel baseline.
