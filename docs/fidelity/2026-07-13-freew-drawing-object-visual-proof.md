# FreeW Drawing/Object Visual Proof

Date: 2026-07-13

This slice adds a bounded FreeW drawing/object visual-proof readiness layer to the existing combined WPF/Avalonia visual evidence flow. The proof set is:

- `drawing-objects-complex`
- `object-format-position-size-style`
- `chart-smartart-complex`
- `wordart-watermark-stress`
- `wordart-picture-watermark-layout`

The summary now emits `drawingObjectProofReadiness` rows and a Markdown section named `Drawing/Object Visual Proof Readiness`. Each row records paired WPF and Avalonia outputs, semantic drawing/object evidence, Word-baseline status, and whether the row is ready for a real Word PNG baseline comparison.

If Word COM or baseline generation is unavailable, the runner can be invoked with `-WordBaselineUnavailableReason`. In that mode the readiness rows remain trusted when paired WPF/Avalonia evidence is present, but the baseline status is explicit: no authoritative Word PNG parity is claimed until a COM-capable machine supplies real Word baselines.

Example focused run:

```powershell
pwsh freew-fidelity-corpus/tools/Run-FreeWVisualEvidence.ps1 -OutDir freew-fidelity-corpus/runs/drawing-object-proof -ScenarioSet DrawingObjectVisualProof -WordBaselineUnavailableReason "COM ProgID 'Word.Application' is not registered"
```
