# FreeW Floating/Wrapping Visual Proof

Date: 2026-07-13

This slice adds a bounded FreeW floating/wrapping visual-proof readiness layer to the existing combined WPF/Avalonia visual evidence flow. The proof pair is:

- WPF composite renderer: `f2-01-float-wrap`
- Avalonia page-layout shot: `page-composition-floating-image`

The summary now emits `floatingWrappingProofReadiness` rows and a Markdown section named `Floating/Wrapping Visual Proof Readiness`. The row records the WPF floating square/tight wrap fixture, the Avalonia floating-image placement shot, semantic wrap evidence, Word-baseline status, and whether the pair is ready for a real Word PNG baseline comparison.

If Word COM or baseline generation is unavailable, the runner can be invoked with `-WordBaselineUnavailableReason`. In that mode the readiness row remains trusted when paired WPF/Avalonia evidence is present, but the baseline status is explicit: no authoritative Word wrap parity is claimed until a COM-capable machine supplies real Word baselines.

Example focused run:

```powershell
pwsh freew-fidelity-corpus/tools/Run-FreeWVisualEvidence.ps1 -OutDir freew-fidelity-corpus/runs/floating-wrapping-proof -ScenarioSet FloatingWrappingVisualProof -WordBaselineUnavailableReason "COM ProgID 'Word.Application' is not registered"
```

Validated on 2026-07-13 with the same no-Word mode:

- Summary trust: `passed`.
- Evidence rows: paired WPF/Avalonia floating/wrapping scenarios.
- Word baseline comparisons: recorded as `word-baseline-unavailable`.
- Floating/wrapping visual proof readiness: trusted paired row with WPF square/tight wrap evidence and Avalonia behind/in-front/top-and-bottom placement evidence.
- No authoritative Word PNG parity is claimed in no-Word mode.
