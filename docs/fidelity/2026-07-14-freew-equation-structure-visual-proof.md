# FreeW Equation Structure Visual Proof

Date: 2026-07-14

This slice deepens the existing `EquationStructureVisualProof` path without requiring Word COM. It intentionally isolates the generated `equation-structures` fixture and verifies paired WPF/Avalonia evidence for the shared FreeW equation visual planner.

The proof now treats the row as ready only when semantic equation evidence covers the modeled OfficeMath structures, not merely when a PNG exists. The runner and normalizer evidence require:

- paired trusted WPF and Avalonia rows for `equation-structures`;
- equation, element, segment, nested-slot, and max-depth counts;
- fraction, radical, n-ary, matrix, equation-array, accent, bar, delimiter, group-character, function-apply, and script geometry evidence;
- segment-role signatures for scripts, limits, fraction parts, radical parts, matrix cells, decorators, delimiters, group characters, and function arguments;
- spacing signatures for script, fraction, radical, n-ary, matrix, and equation-array layout;
- the explicit `equation-structures-word-baseline-fidelity` blocker when Word COM is unavailable.

Run it on a no-Word host with:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File freew-fidelity-corpus\tools\Run-FreeWVisualEvidence.ps1 -OutDir freew-fidelity-corpus\runs\equation-structure-proof-20260714-worker -MaxPages 1 -ScenarioSet EquationStructureVisualProof -WordBaselineUnavailableReason "COM ProgID 'Word.Application' is not registered"
```

This remains paired FreeW WPF/Avalonia renderer evidence and Word-baseline readiness only. Because Word COM is unavailable on this host, it does not claim authoritative Microsoft Word PNG equation parity. Real Word baseline PNG capture and comparison remain required on a machine where `Word.Application` is registered.

Validated on 2026-07-14 with the command above:

- Summary trust: `passed`.
- Evidence rows: `2`.
- Word baseline comparisons: `2`, both `word-baseline-unavailable`.
- Equation structure readiness: `2` trusted scenario rows, `2` verified semantic rows, `2` verified Word-baseline policy rows, and the Word-baseline-unavailable blocker verified.
- Backstage readiness: skipped by scenario filter.
- Summary files: `freew-fidelity-corpus/runs/equation-structure-proof-20260714-worker/freew_visual_evidence_summary.{json,md}`.
