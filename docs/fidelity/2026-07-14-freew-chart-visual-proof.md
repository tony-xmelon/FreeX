# FreeW Chart Visual Proof

Date: 2026-07-14

This slice advances the non-equation FreeW WPF/Avalonia visual evidence path without requiring Word COM. It intentionally isolates the generated `chart-smartart-complex` fixture through `ChartVisualProof` and verifies paired WPF/Avalonia evidence for the shared chart and SmartArt visual planners.

The proof treats the row as ready only when the normalized summary carries semantic chart evidence, not merely when PNGs exist. The runner and normalizer evidence require:

- paired trusted WPF and Avalonia rows for `chart-smartart-complex`;
- two modeled charts and two SmartArt diagrams in both renderers;
- two chart visual signatures and two chart data signatures in both renderers;
- two SmartArt signatures with `orgchart1` and `pyramid1` layouts;
- Basic Pyramid polygon geometry with four polygon nodes;
- the explicit `chart-smartart-complex-word-baseline-fidelity` blocker when Word COM is unavailable.

Run it on a no-Word host with:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File freew-fidelity-corpus\tools\Run-FreeWVisualEvidence.ps1 -OutDir freew-fidelity-corpus\runs\chart-visual-proof-20260714-codex -MaxPages 1 -ScenarioSet ChartVisualProof -WordBaselineUnavailableReason "COM ProgID 'Word.Application' is not registered"
```

This remains paired FreeW WPF/Avalonia renderer evidence and Word-baseline readiness only. Because Word COM is unavailable on this host, it does not claim authoritative Microsoft Word PNG chart or SmartArt parity. Real Word baseline PNG capture and comparison remain required on a machine where `Word.Application` is registered.

Validated on 2026-07-14 with the command above:

- Summary trust: `passed`.
- Evidence rows: `2`.
- Word baseline comparisons: `2`, both `word-baseline-unavailable`.
- Drawing/object proof readiness: `2` trusted scenario rows, `2` verified semantic rows, and `2` verified Word-baseline policy rows.
- Chart visual proof readiness: `2` trusted semantic rows, `2` verified Word-baseline policy rows, and the Word-baseline-unavailable blocker verified.
- SmartArt polygon readiness: `2` trusted semantic rows, `2` verified Word-baseline policy rows, and the Word-baseline-unavailable blocker verified.
- Backstage readiness: skipped by scenario filter.
- Summary files: `freew-fidelity-corpus/runs/chart-visual-proof-20260714-codex/freew_visual_evidence_summary.{json,md}`.
