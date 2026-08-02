# FreeW document proofing indicator visibility

## Scope

Word stores document-scoped proofing exceptions in `word/settings.xml` as
`w:hideSpellingErrors` and `w:hideGrammaticalErrors`. FreeW already retained both settings, but
WPF and Avalonia still displayed their corresponding indicators.

This slice keeps diagnostic generation and the user's Review-ribbon spell-check preference
independent from document indicator visibility:

- spelling diagnostics are hidden only when `HideSpellingErrors` is set;
- grammar diagnostics are hidden only when `HideGrammaticalErrors` is set;
- raw diagnostics remain available for proofing commands;
- switching documents does not overwrite the user's spell-check preference;
- visual-evidence manifests no longer require squiggles that Word suppresses.

WPF applies the spelling exception to its native `SpellCheck.IsEnabled` consumer. Avalonia filters
only the diagnostics used to build drawn squiggle offsets. Existing `w:noProof` run/style/default
suppression and package serialization remain unchanged.

## Verification

- `ProofingDiagnosticPlannerTests`: 18/18 passed.
- WPF `ProofingDiagnosticsTests`: 6/6 passed.
- Avalonia `DocumentViewReviewTests.Proofing*`: 11/11 passed.
- visual-evidence proofing contracts: 3/3 passed.
- existing spelling/grammar settings package round trips: 20/20 passed.

## Remaining host constraint

WPF exposes no separate public switch for its native red underline and native suggestion lookup.
Consequently, hiding spelling indicators also makes native WPF spelling-error ranges unavailable
while that document is active. FreeW's model diagnostics are retained; broad native-dictionary
parity remains a separate proofing-engine task.
