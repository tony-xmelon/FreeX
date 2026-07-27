# Avalonia parity Wave 27

Date: 2026-07-27

Wave 27 advanced one bounded parity slice in each app. It also refreshed the
cross-app dashboard after the FreeX visual evidence changed.

## FreeX

- Replaced the disabled two-item Avalonia language placeholder with the shared
  `AppLanguageCatalog`.
- Persisted the selected normalized culture through the shared Options planner.
- Matched the WPF Language page geometry and fixed the Options capture at the
  shared `744x521` logical client frame.
- Reduced the `dialog.Options.Language` triage score from `0.103708` to `0.021`;
  the fresh direct changed-pixel comparison is 1.63%.
- Remaining differences are Linux text rasterization and native combo-box
  chrome rather than page content, selection state, or persistence behavior.

## FreeW

- Added opt-in palette overrides to the shared Avalonia compact-dialog chrome
  while preserving its established defaults.
- Applied the WPF authority input, selection, combo-box, disabled-field, and tab
  colors only to the Paragraph dialog.
- Reduced `paragraph.validation-error` from `0.185576` to `0.175667`; mean
  channel delta improved from `18.6959` to `17.4630`.
- The remaining differences are platform text rasterization and native control
  template details.

## FreeP

- Added a dedicated shared live layout for `orgChart` SmartArt instead of
  routing it through the generic hierarchy renderer.
- Assistant nodes now use rectangular boxes while the root and regular reports
  use rounded boxes; WPF and Avalonia consume the same shape and connector plan.
- Added reader/layout, cache-regeneration, WPF host, Avalonia host, and
  generator-backed inventory evidence.
- Exact PowerPoint connector routing, box metrics, effects, and authoritative
  PowerPoint PNG baselines remain future depth work.

## Verification

- FreeX Services Options planner lane: 35 passed.
- FreeX Avalonia Options Language source lane: 3 passed.
- FreeX WPF Options dialog lane: 43 passed.
- FreeW Avalonia Paragraph visual parity lane: 4 passed independently; the
  broader agent regression lane passed 15.
- FreeP presentation org-chart lane: 5 passed.
- FreeP WPF org-chart lane: 4 passed.
- FreeP Avalonia org-chart lane: 1 passed.
- FreeP command parity inventory generator check: passed.
- Cross-app parity dashboard regenerated from current evidence.

Generated route and command coverage remains evidence of inventory closure, not
a claim of complete behavioral or pixel-level parity. Subsequent waves should
continue the next ranked FreeX dialog visual residual, FreeW canonical dialog
residuals, and deeper PowerPoint-authoritative SmartArt behavior.
