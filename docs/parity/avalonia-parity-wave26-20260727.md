# Avalonia parity Wave 26

Date: 2026-07-27

Wave 26 advanced one bounded parity slice in each app and removed a blocking
FreeX UI test path.

## FreeX

- Aligned the Avalonia Options Save page with the WPF layout and shared compact
  dialog chrome.
- Added a targeted current-source WPF capture and refreshed the paired
  744x521 WPF and Linux Docker/Xvfb evidence.
- Reduced the `dialog.Options.Save` triage score from `0.105011` to `0.021855`,
  a 79.2% improvement.
- Replaced the `OptionsDialog_RejectsNonPositiveMaxIterations` runtime UI test,
  which opened an undismissed native modal warning, with parser and source
  wiring assertions. The production warning and focus behavior remain covered
  without blocking the test runner.
- The next FreeX visual outlier is `dialog.Options.Language` at `0.103708`.

## FreeW

- Centralized Legal Notices dialog geometry, padding, and line-height metrics
  for both WPF and Avalonia.
- Reduced the third-party license-text tab changed-pixel ratio from 21.735% to
  20.319% and its mean channel delta from 23.459 to 21.170.
- Related long-text tabs improved. Toolkit text rasterization and tab/scrollbar
  chrome remain visual residuals.

## FreeP

- Added a specialized shared live layout for `tableHierarchy` SmartArt instead
  of routing it through the generic hierarchy renderer.
- The shared plan emits full-width headers, aligned child-group columns,
  rectangular cells, and no generic hierarchy connectors.
- Added reader, layout, editing/cache, WPF host, Avalonia host, and
  generator-backed inventory evidence.
- Exact PowerPoint cell metrics, styling/effects, broader multi-group
  semantics, and authoritative PNG baselines remain future depth work.

## Verification

- FreeX Avalonia Options Save source lane: 2 passed.
- FreeX WPF Options dialog lane: 42 passed.
- Formerly hanging FreeX validation test: 1 passed in isolation and again in
  the complete Options dialog lane.
- FreeX dialog visual evidence generator check: passed.
- FreeW WPF Legal Notices lane: 3 passed.
- FreeW Avalonia Legal Notices lane: 1 passed.
- Shared Legal Notices metrics lane: 1 passed.
- FreeP presentation SmartArt lane: 235 passed.
- FreeP WPF SmartArt/reader lane: 172 passed.
- FreeP Avalonia SmartArt lane: 17 passed.
- FreeP command inventory generator check: passed.

Generated route and command coverage remains evidence of inventory closure, not
a claim of complete behavioral or pixel-level parity. The next bounded local
work starts with FreeX Options Language, the next ranked FreeW canonical visual
mismatch, and another unsupported FreeP SmartArt layout family.
