# FreeP Scatter Trendline Functional Parity

## 2026-08-02

Scatter and bubble series share a chart-reader path that already restored marker, smoothing, and error-bar settings but omitted the native `c:trendline` element. As a result, a PowerPoint scatter chart could lose its authored trendline when opened and saved by FreeP even though the model, writer, and editing surfaces already supported trendlines.

The reader now routes that element through the existing trendline parser. A package round-trip regression covers a polynomial scatter trendline, including order and equation-display state. The focused `ChartErrorBarsTests` contract passes 6/6.
