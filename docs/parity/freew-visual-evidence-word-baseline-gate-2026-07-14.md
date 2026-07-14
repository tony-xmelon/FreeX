# FreeW Visual Evidence Word Baseline Gate - 2026-07-14

## Inspection

This checkpoint inspected the current FreeW visual-evidence planner, normalizer, runner, tests, and readiness documentation from `codex/freew-visual-evidence-gate-20260714`.

Current no-COM WPF/Avalonia evidence is already bounded and guarded for the main visual parity families:

- Backstage print preview and PDF export.
- Header/footer image, page composition, floating/wrapping, table layout, and table pagination/page composition.
- Shape/object, grouped drawing/object, object format, WordArt/watermark, SmartArt polygon, and chart visual proof.
- Equation structure, note placement, section geometry, references-heavy/TOA, legal-reference page numbering, review markup, review proofing, and compare/combine proof.

The runner coverage is exposed through named `ScenarioSet` values in `freew-fidelity-corpus/tools/Run-FreeWVisualEvidence.ps1`, and the focused source tests in `freew/FreeW.App.Presentation.Tests/VisualEvidenceRunnerScriptTests.cs` assert that those scenario sets, readiness guards, direct Word-baseline policy rows, and honest `word-baseline-unavailable` blockers stay wired.

## Decision

No additional bounded no-COM FreeW visual-evidence implementation slice was identified in this inspection. The current local evidence can prove paired FreeW WPF/Avalonia renderer readiness and Word-baseline readiness, but it cannot prove authoritative Microsoft Word PNG parity without a Word-capable host.

On this machine, `Word.Application` COM is unavailable:

```powershell
$type = [type]::GetTypeFromProgID('Word.Application', $false)
```

Result: `Word.Application COM unavailable`.

## Remaining Blocker

The next parity-advancing slice is external baseline production on a Word-capable Windows host:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File freew-fidelity-corpus\tools\Run-FreeWVisualEvidence.ps1 -OutDir freew-fidelity-corpus\runs\<word-baseline-run> -IncludeWordBaseline
```

or the focused legacy baseline path:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-FreeWWordBaselineEvidence.ps1
```

Until real Microsoft Word PNG baselines are captured and compared, the local no-COM runner should continue to report `word-baseline-unavailable` blockers instead of treating software fallback or paired renderer proof as Word visual parity.
