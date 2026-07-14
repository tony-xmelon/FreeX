# FreeP Chart Stock OHLC Baseline Readiness - 2026-07-14

This no-COM slice adds type-specific shared evidence for stock high-low/open-close chart baseline readiness before Microsoft PowerPoint screenshots are available.

Shared status:

- `ChartRenderPlanner.BuildStockPrimitivePlan` emits renderer-neutral high-low stems plus open and close tick primitives for stock charts.
- The shared plan classifies close-vs-open movement as rising, falling, or unchanged, so WPF and Avalonia consume the same stroke policy metadata without host-local stock chart decisions.
- `ChartRenderPlanner.BuildVisualBaselineReadinessPlan` projects matching WPF and Avalonia chart-surface capture requests for the same stock chart scenario while keeping the PowerPoint request marked as COM-required.
- The existing `22-chart-baseline-depth.pptx` corpus already exercises stock chart readiness next to 3-D surface, smooth scatter, and 100% stacked column decisions.

Verification:

- `freep/FreeP.App.Presentation.Tests/ChartBaselineCorpusTests.cs` now covers stock OHLC primitive geometry, rising/falling/unchanged price-move classification, stable WPF/Avalonia capture IDs, and COM-required PowerPoint capture metadata.
- `freep/FreeP.App.Presentation.Tests/ChartRenderPlannerTests.cs` continues to cover the lower-level stock primitive planner contract for high-low stems, open/close tick orientation, unknown movements, and shared color classification.

Remaining blockers:

- This slice does not capture Microsoft PowerPoint stock chart PNGs locally; the PowerPoint row is a readiness contract for a COM-capable baseline host.
- Exact Office tick stroke styling, stock chart variants with volume bars, broader real-deck OHLC corpus coverage, calibrated pixel-diff thresholds, and authoritative PowerPoint visual baselines remain deferred.
