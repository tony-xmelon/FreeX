# FreeP Proofing Add to Dictionary

Date: 2026-07-13

## Scope

FreeP now models proofing Add to Dictionary as shared review workflow state, parallel to Ignore and Ignore All. The session-local dictionary is held by the WPF and Avalonia windows and passed into `PresentationReviewWorkflowPlanner`; the planner owns action enablement, normalized word matching, and issue suppression.

## Behavior

- Command id: `freep.review.proofing.add-to-dictionary`.
- Eligible rows are single word-token spelling issues reported as possible misspellings.
- Grammar, punctuation, article agreement, repeated-word, spacing, and other non-dictionary diagnostics keep Add to Dictionary disabled.
- Adding a word stores its normalized dictionary key for the current app session only.
- Matching normalized spelling issues are suppressed across slide titles, shape text, table cells, speaker notes, comments, and comment replies.
- There is no durable dictionary persistence in this slice.

## Validation

Focused planner, WPF host adapter, and Avalonia headless tests cover action enablement and cross-scope suppression.
