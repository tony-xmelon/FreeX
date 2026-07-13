# FreeP Proofing Article-Agreement Parity - 2026-07-13

## Scope

- Added a shared FreeP proofing diagnostic for conservative indefinite article agreement.
- The diagnostic scans the existing proofing scopes: slide titles, shape text, table-cell text, speaker notes, comments, and comment replies.
- Existing proofing pane rows and correction mutation routing apply the suggested replacement.

## Covered detections

- `a apple` -> `an apple`
- `a honest mistake` -> `an honest mistake`
- `an banana` -> `a banana`
- `an user guide` -> `a user guide`
- Suggestion casing follows the article being corrected, for example `A apple` -> `An apple`.

## Conservative guards

- URL, `www.`, email, and `mailto:` tokens are skipped.
- Numeric following tokens are skipped.
- All-caps acronyms and initialisms are skipped.
- One-letter following words are skipped.
- Pronunciation-sensitive cases such as `user`, `university`, `one`, and `euro` are handled only where the shared heuristic is safe.

## Evidence

- `PresentationReviewWorkflowPlannerTests.BuildProofingPanePlan_FlagsArticleAgreementAcrossSharedProofingScopes`
- `PresentationReviewWorkflowPlannerTests.BuildProofingExecutionPlan_ArticleAgreementAvoidsGuardedAndAmbiguousText`
