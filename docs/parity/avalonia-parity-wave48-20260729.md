# Avalonia parity wave 48

Date: 2026-07-29

## Scope

Wave 48 closed three targeted Avalonia parity gaps while keeping the WPF behavior as the reference:

- FreeX: unbound pivot value-filter ownership now follows the WPF edit, clear, remove, header-menu, and PivotChart context behavior.
- FreeW: floating-object arrange commands now use an explicit multi-selection when available and otherwise fall back to all floating objects in the document, matching WPF.
- FreeP: the Avalonia Animation Pane hierarchy, spacing, controls, and chrome were aligned more closely with the WPF pane.

The wave also integrated the concurrently completed FreeP larger target-list, radial-list, and titled-matrix SmartArt work from `main`.

This wave does not claim complete Avalonia/WPF parity. It closes the slices above and records the remaining evidence gaps below.

## Verification

Focused tests:

- FreeX pivot ownership: 24 passed, 0 failed.
- FreeW floating arrange and selection behavior: 25 passed, 0 failed.
- FreeP Animation Pane: 10 passed, 0 failed.
- FreeP SmartArt layout after the final upstream sync: 154 passed, 0 failed.
- FreeP WPF host SmartArt after the final upstream sync: 203 passed, 0 failed.

Repository validation:

- `FreeX.DefaultTests.slnx`, Release: 33,135 discovered, 33,002 executed and passed, 0 failed, 133 not executed.
- `FreeX.slnx`, Release: build succeeded with 0 warnings and 0 errors.
- Repository preflight passed, including solution inventories, Linux/macOS packaging, generated parity documentation, and conflict-marker checks.

The 133 non-executed tests remain an explicit coverage gap; they are not counted as parity evidence.

## Linux evidence

- FreeX physical interaction lane: 24/24 passed.
  - `artifacts/linux-interactive/freex/interaction-validation/20260728T220047Z/interaction-validation.json`
- FreeW family interaction lane: 37/37 passed and the family contract passed.
  - `artifacts/linux-family-interactive/wave48/freew/sessions/20260728T215857404Z/family-validation/family-x11-results.json`
- FreeP family interaction lane: 22/22 passed and the family contract passed after the final FreeP rerun.
  - `artifacts/linux-family-interactive/wave48/freep/sessions/20260728T220950000Z/family-validation/family-x11-results.json`

All Wave 48 harness-owned containers were stopped after capture.

## Visual evidence

A fresh 1280x760, 96 DPI WPF/Avalonia pair was captured for `animations.animation-pane` from the current binaries:

- Evidence root: `artifacts/wave48-freep-animation-paired/`
- Mean channel difference: 3.7464%
- Maximum channel difference: 255
- Heatmap: `artifacts/wave48-freep-animation-paired/diff/animations.animation-pane.png`

The previous committed baseline measured 7.6677%, so the slice materially improved. It is not pixel-identical.

## Known residuals

An exploratory full FreeW Avalonia project run exposed five deterministic source-guard failures in files unchanged from `origin/main`:

- shared Avalonia shell-frame source guard
- collapsed-caret proofing language staging guard
- paragraph ribbon-definition source guard
- shared floating chart/SmartArt visual-planner guard
- residual compact dialog-chrome delegation guard

These are inherited repository drift rather than regressions introduced by Wave 48. The focused Wave 48 FreeW lane is green.

## Next slices

- FreeX: continue deep command/workflow coverage and produce authoritative matched WPF/Avalonia visual evidence for remaining spreadsheet surfaces.
- FreeW: close page editing and grouped-child editing behavior, repair the inherited source guards, and expand Word-authoritative visual baselines.
- FreeP: validate Animation Pane playback against PowerPoint and continue SmartArt, OMML, media, and hardware-backed presentation baselines.
- Cross-app: investigate the 133 non-executed default-lane tests and keep moving platform-specific shell, dialog, resource, and localization behavior into shared implementations.
