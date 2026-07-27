# Avalonia parity Wave 28

Date: 2026-07-27

Wave 28 advanced one bounded parity slice in each app and retained concurrent
FreeP SmartArt work from `main`.

## FreeX

- Rebuilt the Avalonia Scenario Manager as the WPF-style two-column body with a
  fixed scenario list, right-side actions, compact Add/Edit group, and separate
  validation and Close rows.
- Reused the shared Avalonia compact-dialog chrome and moved fixed geometry into
  a presentation-layer layout contract.
- Reduced the normalized direct changed-pixel ratio from `4.0124%` to `3.4366%`
  at the comparable `360x420` client frame.
- The current capture route still lacks an authoritative validation-state PNG;
  WPF also emits a 15-pixel capture-frame band that was normalized for the
  direct comparison.

## FreeW

- Matched the WPF Style dialog's 21-pixel compact control height without
  changing shared dialog defaults.
- Reduced `style.initial` from `16.0613%` to `12.9601%` changed pixels, a 19.3%
  relative improvement.
- Populated and validation states also improved to approximately 13.12% and
  12.96%; native combo, checkbox, font, and button raster differences remain.

## FreeP

- Replaced the generic closed-cycle treatment of `radialList` with a dedicated
  shared center-spoke layout consumed by WPF and Avalonia.
- The live plan supports up to eight editable items and intentionally retains
  the imported cached drawing above that bound.
- Added reader/admission, layout, editing-cache, WPF host, Avalonia command,
  fallback-bound, and generated inventory evidence.
- Exact PowerPoint node sizing, attachment sites, curved routing, effects, and
  authoritative PNG baselines remain future depth work.

## Verification

- FreeX Scenario Manager layout contract: 1 passed.
- FreeX Avalonia Scenario Manager source/composition lane: 1 passed.
- FreeW Avalonia design-dialog lane: 6 passed.
- FreeP presentation/cache radial-list lane: 3 passed.
- FreeP WPF radial-list lane: 2 passed.
- FreeP Avalonia radial-list command lane: 1 passed.
- FreeP command inventory generation and freshness check: passed.

Generated route and command coverage remains evidence of inventory closure, not
a claim of complete behavioral or pixel-level parity. Subsequent work should
continue ranked FreeX dialog residuals, canonical FreeW dialog rows, and deeper
PowerPoint-authoritative SmartArt semantics.
