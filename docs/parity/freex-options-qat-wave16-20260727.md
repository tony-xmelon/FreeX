# FreeX Options Quick Access Toolbar Wave 16

Date: 2026-07-27
Branch: `codex/freex-options-qat-wave16-20260727`
Surface: `dialog.Options.QuickAccessToolbar`

## Scope

Aligned the FreeX Avalonia Quick Access Toolbar Options page to the WPF authority using the existing shared Avalonia compact dialog chrome. The change is limited to FreeX production, FreeX tests, and FreeX dialog evidence.

Implemented alignment includes:

- shared Windows-style dialog font, foreground, background, and descendant control chrome;
- WPF category-row padding, full border, and selected-row border color;
- WPF QAT grid geometry: 469 px frame, `128,10,92,10,127,10,92` columns, and 180 px list rows;
- WPF spacing around add/remove and reorder controls;
- WPF footer separator, background, padding, 80 px action buttons, and 8 px action spacing;
- shared Options font applied to list content.

## Evidence

The canonical Avalonia PNG was regenerated from the merged branch in Ubuntu 24.04 Docker/Xvfb using:

`FreeX --parity-capture ... --parity-capture-surface dialog.Options.QuickAccessToolbar`

Both canonical frames are 744x521 pixels. The regenerated comparison changed the target triage score from **0.132476** to **0.046918** (a **64.6% reduction**). `sampleMeanDelta` changed from `0.026894` to `0.019832`; `lumaDelta` from `0.004440` to `0.001174`; `nonBackgroundDelta` from `0.100334` to `0.025104`.

## Verification

- Focused FreeX Services tests: **33 passed, 0 failed**.
- Avalonia Release build: **0 warnings, 0 errors**.
- Linux self-contained `linux-x64` publish: succeeded.
- Docker/Xvfb target capture: succeeded; PNG is nonblank and exact-size.
- Evidence summary check: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Generate-DialogVisualEvidenceSummary.ps1 -Check`.

## Residuals

The remaining score is primarily native Avalonia versus WPF rasterization and control-rendering variance, including font anti-aliasing, list scrollbar treatment, and a small amount of text/control pixel drift. Functional QAT interactions remain implemented through the existing add/remove, reorder, reset, import, export, search, keyboard, and double-click handlers; this wave did not change those planners or handlers.
