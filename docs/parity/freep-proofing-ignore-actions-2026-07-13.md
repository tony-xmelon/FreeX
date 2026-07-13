# FreeP Proofing Ignore Actions - 2026-07-13

## Scope

This slice adds a bounded no-COM proofing workflow improvement for FreeP review parity: PowerPoint-style `Ignore` and `Ignore All` actions now flow through the shared proofing pane planner and are consumed by thin WPF and Avalonia adapters.

## Evidence

- Shared command ids:
  - `freep.review.proofing.ignore`
  - `freep.review.proofing.ignore-all`
- `Ignore` suppresses the selected concrete proofing issue occurrence for the current proofing pane session.
- `Ignore All` suppresses every current-session issue with the same normalized issue text and message key across slide titles, shape text, table cell text, speaker notes, comments, and comment replies.
- WPF and Avalonia keep only in-memory proofing ignore state and call back into the shared planner for filtering, row construction, action enablement, and selection normalization.
- The existing `Change` correction path is unchanged.

## Remaining Parity Work

This improves shared review/proofing workflow depth, but it is not a PowerPoint-authoritative proofing baseline. Local PowerPoint COM validation is unavailable on this machine, so exact PowerPoint pane behavior, spell-checker dictionary output, and visual/reference workflow baselines remain deferred.
