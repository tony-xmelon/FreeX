# Avalonia parity Wave 24

Date: 2026-07-27

Wave 24 advanced one bounded parity slice in each app and refreshed the
repository-wide generated evidence.

## FreeX

- Replaced Sort Options dialog-local checkbox and radio templates with the
  shared Avalonia compact dialog chrome.
- Reused shared window, combo-box, group-box, and button styling.
- Matched the WPF bottom-docked 75x52 OK/Cancel row in the fixed 330x260
  logical window.
- Captured and promoted fresh Ubuntu 24.04 Docker/Xvfb evidence.
- Reduced the `dialog.SortOptions` triage score from `0.110625` to `0.048680`.
- The next FreeX visual outlier is `dialog.GoTo` at `0.110485`.

## FreeW

- Matched the WPF Open-pane action-row structure: a direct button label plus a
  sibling description block.
- Removed the Avalonia-only search placeholder and matched the WPF search
  width.
- Materialized only the selected Documents or Folders tab content.
- Removed the `action-button-order` semantic difference.
- Reduced the isolated paired changed-pixel ratio for
  `backstage-open.open` from `0.206863` to `0.194649`.
- The pair remains honestly classified as a visual mismatch because
  cross-toolkit raster and layout differences remain.

## FreeP

- Extended the shared Grow/Shrink playback plan and frame plan with
  axis-specific from, peak, and to scale tracks while preserving scalar
  compatibility.
- Routed the same X/Y tracks through both WPF and Avalonia slideshow hosts.
- Added asymmetric `p:animScale` round-trip, planner, frame, and host-policy
  coverage.
- Exact PowerPoint-authoritative frame comparisons remain external baseline
  work and are not claimed by this wave.

## Verification

- FreeX dialog visual source lane: 5 passed in the slice worktree.
- FreeX dialog evidence generation and check passed with 94/94 paired surfaces,
  zero nonblank failures, and zero logical-dimension mismatches.
- FreeW shared Backstage planner lane: 18 passed in the slice worktree; 12
  independently re-run after integration.
- FreeW Avalonia Backstage lane: 2 passed in the slice worktree; the new
  direct-label action-row test independently passed after integration.
- FreeP presentation suite: 2,688 passed in the slice worktree.
- FreeP asymmetric planner/IO tests: 2 independently re-run after integration.
- FreeP WPF and Avalonia host-policy source lanes independently passed after
  integration.

## Generated state

- FreeX: 531 functional commands, zero actionable Avalonia command gaps, 57/57
  dialog routes, and 94 paired screenshot surfaces.
- FreeW: 870 commands and zero actionable generated command gaps. The canonical
  all-dialog report still contains 171 mismatch states, 12 passes, 4
  state-not-applicable rows, and 96 Avalonia extensions; the isolated Wave 24
  evidence records the Backstage Open improvement without replacing the
  all-dialog report with a one-scenario run.
- FreeP: 346 commands, 344 shared, 2 intentional platform-only, and zero
  actionable generated command gaps.

Generated command and route coverage is not a claim of complete behavioral or
pixel-level parity. The next bounded local visual work starts with FreeX
`dialog.GoTo` and FreeW `backstage-export.open`; FreeP still requires further
workflow-depth and PowerPoint-authoritative baseline slices.
