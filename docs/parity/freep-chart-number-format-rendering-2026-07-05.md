# FreeP Chart Number Format Rendering - 2026-07-05

This slice improves chart text fidelity by applying preserved PowerPoint chart number/date format metadata inside the shared chart render planner before WPF or Avalonia render text.

Parity improved:

- `ChartRenderPlanner` now formats primary value-axis, secondary value-axis, scatter/bubble X/Y-axis, and category-axis label text from shared `ChartAxis.NumberFormatCode` metadata.
- The shared formatter covers deterministic chart-facing numeric formats: percent precision, grouped thousands, fixed decimals, scaled display-unit commas, currency/literal prefixes and suffixes, positive/negative/zero format sections, conditional threshold sections, bracketed color/locale sections, escaped literals, quoted units, bounded elapsed-time patterns (`[h]:mm:ss`, `[m]:ss`, `[s]` with common fractional seconds), and bounded fraction patterns such as `# ?/?`, `# ??/??`, `?/?`, and `# ?/??`.
- Category axes can render ISO date labels and OA serial date labels with common PowerPoint-style date format codes while leaving non-date category text unchanged.
- WPF and Avalonia keep using renderer-neutral `ChartTextPlan.Text`; no renderer-local number-format policy is added.

Remaining gaps:

- This is a bounded chart text formatter, not a full Excel custom number-format engine; broader locale-sensitive, arbitrary elapsed-time/fraction, and text-placeholder semantics remain deferred.
- PowerPoint-authoritative chart visual baselines still require a COM-capable machine.
- Broader chart fidelity gaps remain in advanced layout, native visual comparison coverage, and exact PowerPoint locale behavior.
