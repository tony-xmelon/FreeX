# FreeP Chart Stock Volume Baseline Readiness - 2026-07-14

This no-COM slice adds bounded shared evidence for stock volume/open-high-low-close baseline readiness before Microsoft PowerPoint screenshots are available.

Shared status:

- `ChartRenderPlanner.BuildStockVolumePrimitives` emits renderer-neutral bottom-band volume columns for stock charts that include a volume series.
- The stock planner now recognizes the common five-series volume/open/high/low/close ordering while preserving the existing four-series OHLC primitive contract.
- `ChartRenderPlanner.BuildStockPrimitivePlan` continues to emit shared high-low stems plus open and close ticks for the same chart, so WPF and Avalonia consume one combined planner contract instead of duplicating host logic.
- `ChartRenderPlanner.BuildVisualBaselineReadinessPlan` identifies volume+OHLC stock scenarios in the capture request evidence summary while keeping the PowerPoint request marked as COM-required.

Verification:

- `freep/FreeP.App.Presentation.Tests/ChartRenderPlannerTests.cs` covers volume column placement, series identity, maximum-volume scaling, and shared fill selection.
- `freep/FreeP.App.Presentation.Tests/ChartBaselineCorpusTests.cs` covers the combined volume+OHLC primitive decisions plus stable WPF/Avalonia capture IDs and COM-required PowerPoint capture metadata.

Remaining blockers:

- This slice does not capture Microsoft PowerPoint stock chart PNGs locally; the PowerPoint row is a readiness contract for a COM-capable baseline host.
- Exact Office volume-axis styling, combined price/volume axis calibration, real-deck stock-volume corpus coverage, and pixel-diff thresholds remain deferred.
