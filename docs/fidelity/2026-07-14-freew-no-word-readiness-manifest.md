# FreeW No-Word Baseline Readiness Manifest

Date: 2026-07-14

This slice hardens the FreeW Word-authoritative evidence path for hosts where `Word.Application` is unavailable. It does not add Microsoft Word PNG baselines and does not claim Word PNG visual parity. Instead, the standalone Word-baseline runner now writes a post-summary readiness manifest derived from the normalized visual evidence summary.

The manifest is written to:

```text
freew-fidelity-corpus/runs/visual-evidence/_word_baseline_readiness_manifest.json
```

It records:

- the normalized summary schema/version and evidence authority level;
- `authoritativeWordPngParity = false`;
- counts for evidence rows, baseline comparisons, unavailable Word-baseline rows, real Word PNG comparisons, missing Word PNG rows, and remaining Word-baseline blockers;
- the comparable scenario IDs that are ready for a Word-capable host;
- the candidate Word PNG baseline paths emitted by the shared baseline planner;
- the remaining blocker IDs tied to `word-baseline-unavailable`.

This makes the no-Word path auditable: a coordinator can distinguish valid WPF/Avalonia preparatory evidence from a real Word PNG comparison, and a Word-capable host can see exactly which candidate paths must be supplied or generated next.

Run the standalone no-Word readiness path with:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-FreeWWordBaselineEvidence.ps1 -RunRoot freew-fidelity-corpus\runs\visual-evidence -NoWord
```

The runner still writes the older `_word_baseline_unavailable.json` marker for compatibility. The new `_word_baseline_readiness_manifest.json` is stricter because it is generated after `FreeW.VisualEvidenceSummary` has normalized the WPF/Avalonia evidence and built the Word-baseline comparison rows.

Validation added in this slice:

- `VisualEvidenceRunnerScriptTests.WordBaselineEvidenceRunner_UsesSoftwareFallbackForWpfEvidenceRender` now asserts that the no-Word runner writes the readiness manifest, records candidate baseline paths, records remaining blocker IDs, and fails the manifest if it ever claims authoritative Word PNG parity or omits candidate paths.
