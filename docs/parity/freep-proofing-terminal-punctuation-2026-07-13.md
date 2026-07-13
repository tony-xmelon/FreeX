# FreeP Proofing Terminal Punctuation Slice - 2026-07-13

## Scope

This slice adds a shared FreeP proofing diagnostic for repeated terminal punctuation in the existing `PresentationReviewWorkflowPlanner` built-in scanner. WPF and Avalonia proofing panes consume the same issue rows, suggested replacements, and `TryApplyProofingCorrection` mutation route.

## Implemented Behavior

- Detects repeated same-mark `!` and `?` terminal punctuation such as `Hello!!` and `Why??`.
- Detects overlong mixed terminal punctuation such as `Wait?!?`.
- Suggests a deterministic single-mark replacement using the first mark in the run.
- Scans the existing shared proofing scopes: slide titles, shape text, table-cell text, speaker notes, comments, and comment replies.
- Preserves the existing shared proofing correction path for applying replacements.

## Conservative Guards

- Dots are not collapsed, so ellipses and ellipsis-like authoring are left alone.
- Existing numeric punctuation guards continue to protect decimal and version-like text from punctuation proofing.
- URL, web address, email, and `mailto:` tokens are skipped for terminal punctuation runs.
- Common two-character mixed emphasis such as `?!` and `!?` is left untouched; only overlong mixed runs are normalized.

## Deferred

- Broader grammar-scale proofing remains deferred.
- PowerPoint-authoritative review/proofing baselines remain deferred until a COM-capable machine can capture them.
- Intentional stylized punctuation beyond the bounded guards remains conservative: the scanner favors avoiding false positives over broad grammar ambition.
