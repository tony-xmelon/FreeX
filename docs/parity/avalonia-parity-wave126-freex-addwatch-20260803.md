# Wave126 FreeX Add Watch parity

## Scope

This bounded slice deduplicates the WPF `AddWatchDialog` contract against
`AddWatchDialogPlanner` and refreshes the paired WPF/Avalonia capture evidence
from current source. Production callers still provide their live formatted
selection text; only the parity capture fixture uses the shared deterministic
`Sheet1!$B$2` value.

The WPF `Label` consumes the localized mnemonic marker in
`AddWatch_SelectedRangeLabel`, so its visible text is `Selected range:`. The
Avalonia capture explicitly strips that display mnemonic. Both current-source
captures therefore show the same visible label and selected-range value.

## Fresh evidence

- WPF: `FreeX.App.Host --parity-capture`, 360x170, exit 0, captured
  `dialog.AddWatch` from the current source.
- Avalonia: Ubuntu 24.04 Docker/Xvfb `--parity-capture --parity-capture-surface
  dialog.AddWatch`, 360x170, app exit 0 and capture validation true.
- Fresh paired image diff after the final button-chrome ordering fix:
  `2.1910253267973854%`.
- Prior accepted fresh pair before that fix: `2.6049444444444445%`.
- Previous fresh corrected Avalonia diff: `2.7705623638344226%`.
- Fresh pre-fix semantic mismatch baseline: `3.3677755991285405%`, including
  the visible Avalonia underscore defect and the wider Avalonia content field.
- Canonical dialog triage score is now `0.035756`; the prior stale canonical
  row was `0.087879` and used a 540x255 WPF PNG against a 360x170 Avalonia PNG.

The fresh WPF geometry places the action row at its desired top-sized client
position. The Avalonia `VerticalContentAlignment=Top` setting is retained
because the matching fresh capture keeps that geometry and improves the
measured pair; it is not based on the previous unverified comment.

## Deduplication

WPF now consumes planner-owned dialog width, height, root margin, button width,
range/action spacing, localization keys, and automation IDs. Avalonia-only
minimum-button, client-frame, and spacing compensation values are explicitly
named and isolated in the planner.

Focused source/behavior tests cover the shared fixture, mnemonic stripping,
planner values, WPF source usage, and WPF automation metadata.

The existing dialog visual manifest schema still has no honest per-surface
source provenance or content hash. This slice adds targeted Add Watch source
contracts and fresh paired notes without adding a manifest-wide source revision
that would falsely certify untouched legacy rows.
