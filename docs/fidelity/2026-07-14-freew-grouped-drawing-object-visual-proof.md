# FreeW Grouped Drawing/Object Visual Proof

Date: 2026-07-14

This slice adds a focused no-Word FreeW visual proof path for grouped drawing/object fidelity. It intentionally isolates the existing grouped drawing fixture:

- `drawing-objects-complex`

The new `GroupedDrawingObjectVisualProof` runner set filters the combined WPF/Avalonia evidence flow to that single scenario, so the proof does not require the separate `chart-smartart-complex`, WordArt watermark, table layout, or table pagination rows.

The grouped proof relies on the shared normalizer contract already used by the broader drawing/object evidence: WPF and Avalonia must agree on proof-comparable grouped child visual signatures and rendered grouped child effects. The readiness output now surfaces grouped child kind and visual-signature counts in the drawing/object semantic evidence, and the runner guard verifies:

- paired trusted WPF and Avalonia rows for `drawing-objects-complex`;
- mixed grouped child metadata for image, shape, chart, WordArt, and SmartArt children;
- grouped child visual signatures for every child;
- rendered grouped child shape and WordArt glow effects;
- direct Word-baseline policy rows when no-Word baseline mode is requested;
- the explicit `drawing-objects-complex-word-baseline-fidelity` blocker when Word COM is unavailable.

Run it on a no-Word host with:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File freew-fidelity-corpus\tools\Run-FreeWVisualEvidence.ps1 -OutDir freew-fidelity-corpus\runs\grouped-drawing-object-proof-20260714-worker -MaxPages 1 -ScenarioSet GroupedDrawingObjectVisualProof -WordBaselineUnavailableReason "COM ProgID 'Word.Application' is not registered"
```

This remains paired FreeW WPF/Avalonia renderer evidence and Word-baseline readiness only. Because Word COM is unavailable on this host, it does not claim authoritative Microsoft Word PNG grouped drawing/object parity. Real Word baseline PNG capture and comparison remain required on a machine where `Word.Application` is registered.

Validated on 2026-07-14 with the command above:

- Summary trust: `passed`.
- Evidence rows: `2`.
- Word baseline comparisons: `2`, both `word-baseline-unavailable`.
- Grouped drawing readiness: `1` readiness row, `2` verified semantic rows, `2` verified Word-baseline policy rows, and the Word-baseline-unavailable blocker verified.
- Backstage readiness: skipped by scenario filter.
- Summary files: `freew-fidelity-corpus/runs/grouped-drawing-object-proof-20260714-worker/freew_visual_evidence_summary.{json,md}`.
