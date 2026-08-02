# Avalonia Parity Wave107: FreeX Scenario Manager

Date: 2026-08-02

## Scope

This slice targets the highest current FreeX paired dialog outlier,
`dialog.ScenarioManager` (triage score `0.103523` in
`docs/parity/dialog-visual-evidence-summary.json`). The authority is the WPF
implementation in `src/FreeX.App.Host/ScenarioManagerDialog.cs` and its paired
capture in `docs/parity/dialog-visual-assets/wpf-capture/dialog.ScenarioManager.png`.

## Alignment

- Restored the WPF 12px group and Close spacing and its 8px field rhythm,
  while keeping the 4px list-header gap.
- Added the WPF checkbox bottom margins: 6px for Prevent changes and 8px for
  Hide.
- Added a FreeX-only Scenario Manager chrome profile with 22px controls,
  compact button/text padding, and 22px list items. This keeps the complete
  WPF composition inside the fixed 360x420 client frame without changing the
  generic shared dialog metrics used by other dialogs.
- Applied the same route chrome to the Avalonia range-picker buttons.
- Preserved the existing shared planners, range-picker lifecycle, automation
  ids, selection projection, and command behavior.

## Verification

- `dotnet test tests/FreeX.App.Presentation.Tests/FreeX.App.Presentation.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~ScenarioManagerDialogLayoutTests`
  passed: **1/1**.
- `dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~ScenarioManagerDialog`
  passed: **6/6**.
- The focused Avalonia render test drove the production parity-capture route,
  emitted a valid `360x420` `dialog.ScenarioManager.png`, found the neutral
  WPF-style button surface and group border, and confirmed rendered pixels in
  the bottom rows.
- A fresh production Avalonia capture was promoted into the committed evidence
  set. Regenerating `dialog-visual-evidence-summary.json` reduced the Scenario
  Manager triage score from `0.103523` to `0.063362`; its non-background delta
  fell from `0.044216` to `0.015949`, removing it from the leading outliers.
- `git diff --check` passed for the scoped changes.

## Remaining limitation

Docker was intentionally not run for this slice. The paired score uses the
current Avalonia production capture and the committed WPF authority capture;
it is deterministic prioritization evidence, not a human claim of exact visual
identity. Cross-framework text and control rasterization differences remain.
