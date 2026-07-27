# Avalonia parity Wave 29

Date: 2026-07-27

Wave 29 advanced one bounded parity slice in each app and was integrated after
the current FreeP picture-SmartArt, chart-series, and shared FreeX Options
changes from `main`.

## FreeX

- Moved the deterministic Error Checking capture fixture into
  `ErrorCheckingDialogPlanner` so WPF and Avalonia consume the same issue data.
- Applied the shared Avalonia compact-dialog window chrome and added the
  missing focused WPF `dialog.ErrorChecking` capture route.
- Reduced the triage score from `0.103141` to `0.058275`, a 43.5% improvement,
  and reduced the non-background delta from `0.066375` to `0.020787`.
- Fresh WPF and Linux Docker/Xvfb captures were paired at `720x420`; their
  direct changed-pixel ratio was `4.3299%`.
- Native text, selected-row, button-template, and scrollbar rasterization
  remain visible residuals.

## FreeW

- Reused `AvaloniaCompactDialogChrome.ApplyCompactCheckBox` for the Find/Replace
  Match case, Whole word, and Use wildcards controls.
- Reduced the changed-pixel ratio from `15.1789%` to `7.8673%`.
- Reduced mean channel delta from `8.1110` to `5.4434` and P95 delta from `34`
  to `25`, with both captures at `560x600`.
- Native text and control-template rasterization remain genuine visual
  differences.

## FreeP

- Added a shared semantic live plan for PowerPoint `titledMatrix`: the first
  node is a full-width title band and the remaining nodes form a bounded
  two-column body.
- WPF and Avalonia both consume the same `SmartArtLayoutEngine` plan.
- Blank-title, missing-body, and over-eight-body-node inputs retain the imported
  cached DrawingML rendering rather than claiming unsupported live fidelity.
- Exact PowerPoint proportions, theme effects, text fitting, and DrawingML
  regeneration remain future depth work.

## Verification

- FreeX Error Checking planner lane: 3 passed.
- FreeX WPF Error Checking source/capture lane: 18 passed.
- FreeX Avalonia exact compact-chrome lane: 1 passed.
- FreeW Avalonia Find/Replace policy/chrome lane: 1 passed.
- FreeP `TitledMatrix` presentation lane: 4 passed.
- FreeP `TitledMatrix` WPF import/compositor lane: 2 passed.
- FreeP `TitledMatrix` Avalonia headless lane: 1 passed.
- FreeP command inventory freshness check: passed.
- Cross-app parity dashboard freshness check: passed.

Generated route coverage and focused source guards remain supporting evidence,
not a claim that all platform behavior or pixels are identical. The next wave
should continue the ranked FreeX dialog residuals, the next canonical FreeW
visual outlier, and PowerPoint-authoritative SmartArt depth while preserving
function-first fallback behavior.
