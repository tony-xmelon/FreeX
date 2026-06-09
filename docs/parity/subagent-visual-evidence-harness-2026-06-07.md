# Visual Evidence Harness Findings - 2026-06-07

Scope: screenshot/capture/tour tooling for Excel/FreeX ribbon visual parity. This pass did not change ribbon command implementations, resources, or command behavior.

## Changes

- Hardened `tools/screenshot_excel.ps1` and `tools/screenshot_ribbon.ps1` so stale PNGs and `screenshot_manifest.json` are cleared at run start and when a foreground guard invalidates the evidence.
- Extended both PowerShell harnesses to assert expected process/title foreground ownership immediately before screen capture, not only before global input or resize setup.
- Added complete-matrix validation before manifest write. A run now discards partial capture evidence instead of writing a manifest whose planned count does not match the captured count.
- Enriched PowerShell manifest semantics with `ActualCaptureCount`, `CaptureStatus`, `CaptureMethod`, `ForegroundGuard`, per-capture `CaptureSequence`, `CaptureKey`, and per-capture capture status/method metadata.
- Hardened the in-app `FREEX_SS_TOUR` path so render/write is blocked unless the FreeX main window owns foreground focus. Failed tours clear the current plan's PNGs and manifest.
- Extended the in-app tour manifest with evidence identity, output naming, actual count/status/method, Excel pairing metadata, focus-guard policy, per-capture pair/capture keys, tab file names, and counterpart Excel file names.
- Added source-level tests around guard cleanup, screen-copy gating, UIA tab-selection gating, pair/capture keys, and in-app manifest/failure semantics.

## Current Semantics

- Excel live capture uses guarded global input plus guarded `CopyFromScreen` over the top window band.
- FreeX live capture uses guarded UIA tab selection plus guarded `CopyFromScreen` over the top window band.
- FreeX in-app capture uses `RenderTargetBitmap` and now requires the main window to be foreground-active immediately before render and before file write.
- The default parity matrix remains max/1100/900/750 across Home, Insert, Draw, Page Layout, Formulas, Data, Review, View, and Help.

## Remaining Gaps

- Popup, dropdown, context-menu, and native-dialog visual parity still need separate guarded capture flows.
- The harness records pairable evidence metadata, but it does not yet compute pixel diffs, layout hashes, or pass/fail visual parity scores.
- Foreground ownership is process/title or main-window-handle guarded; it does not prove that no overlay appears during the small interval inside the actual bitmap operation.
- Excel path discovery is still fixed to the Office16 install path unless the script is edited.
