# FreeW Review Compare/Combine Visual Proof

This slice adds a bounded Review Compare/Combine visual-proof readiness layer to the combined WPF/Avalonia FreeW visual evidence flow. The proof scenarios are:

- `review-compare-visual-proof`
- `review-combine-visual-proof`

Both fixtures are generated through the shared model workflow: `DocumentCompare.Compare` for the compare blackline and `DocumentCombine.Combine` for the multi-author combine blackline. The renderers stay thin; WPF and Avalonia both consume the same shared fixture factory and emit the same manifest semantics.

The visual evidence summary now emits `reviewCompareCombineProofReadiness` rows and a Markdown section named `Review Compare/Combine Visual Proof Readiness`. Each row records paired WPF and Avalonia outputs, compare/combine revision counts, authorship signatures, Word-baseline status, and whether the row is ready for real Word PNG baseline comparison.

If Word COM or baseline generation is unavailable, run the scenario set with `-WordBaselineUnavailableReason`. In that mode readiness remains explicit: paired renderer and semantic evidence can pass, but no authoritative Word PNG parity is claimed until a COM-capable machine supplies real Word baselines.

```powershell
pwsh freew-fidelity-corpus/tools/Run-FreeWVisualEvidence.ps1 -OutDir freew-fidelity-corpus/runs/review-compare-combine-proof -ScenarioSet ReviewCompareCombineVisualProof -WordBaselineUnavailableReason "COM ProgID 'Word.Application' is not registered"
```
