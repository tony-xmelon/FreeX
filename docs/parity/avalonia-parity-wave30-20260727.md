# Avalonia parity Wave 30

Date: 2026-07-27

Wave 30 advanced one bounded parity slice in each app from current generated
evidence. FreeX and FreeW remain visual-fidelity work; FreeP remains
function-first semantic depth because its generated command inventory has no
actionable Avalonia command gaps.

## FreeX

- Tightened only the Avalonia Scenario Manager vertical rhythm so the fixed
  `360x420` client area can show Prevent changes, Hide, and Close without the
  previous vertical overflow.
- Removed the Avalonia-only `(N cells)` suffix from scenario-list display text.
- Kept the WPF authority layout unchanged and added source guards for the
  shared dimensions and Avalonia adapter.
- The tracked score remains `0.103523` because machine-wide build load blocked
  a fresh Linux capture. No stale screenshot or generated score was replaced.

## FreeW

- Aligned Paragraph combo-box and text-box rendered surfaces with the WPF
  authority palette while retaining the existing `380x345` and `380x327`
  geometry.
- Fixed disabled text-box template handling in shared Avalonia compact-dialog
  chrome and repaired the dialog visual harness command parser.
- Captured five same-size WPF/Avalonia states. Mean channel delta improved in
  every state; `paragraph.initial` improved from `16.590` to `15.501` in a
  direct same-session before/after probe.
- Against the older tracked canonical capture, binary changed-pixel ratios rose
  slightly while mean deltas fell. This is recorded as residual native
  rasterization debt rather than presented as pixel parity.

## FreeP

- Replaced rounded-box-plus-connector approximations for `chevronProcess`,
  `basicChevronProcess`, and `closedChevronProcess` with shared live Chevron
  preset geometry.
- Uses the shared DrawingML `adj=24000` notch and 76% interlocking step.
- Preserves valid negative frame offsets and cached drawing fallback for
  malformed, invalid, or over-bound input.
- Cache regeneration now retains Chevron geometry, so WPF and Avalonia consume
  the same compositor plan with no renderer-local policy.
- Exact PowerPoint metrics, effects, variant-specific geometry, and
  PowerPoint-authoritative pixel baselines remain outstanding.

## Verification

- FreeX Scenario Manager focused presentation tests: 15/15 passed.
- FreeX source-parity assertions and restore: passed.
- FreeW Paragraph visual-parity tests: 4/4 passed.
- FreeW Avalonia build: 0 warnings and 0 errors.
- FreeW paired capture states: 5 WPF and 5 Avalonia.
- FreeP presentation tests: 2712/2712 passed.
- FreeP focused Chevron planner tests: 7/7 passed.
- FreeP focused Chevron host tests: 6/6 passed.
- FreeP command inventory, cross-app dashboard, dialog visual summary, and
  whole-window manifest freshness checks: passed.
- Repository preflight: passed.

Generated coverage counts remain evidence of route and command accounting, not
a claim that every platform pixel or workflow is identical.
