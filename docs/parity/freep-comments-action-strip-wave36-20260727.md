# FreeP Avalonia Comments Action Strip, Wave 36

Date: 2026-07-27

## Closed gap

The shared `PresentationCommentPanePlan` already exposes the enabled-state
authority for Review Comments actions. Avalonia had a `BuildReviewCommentActions`
renderer but never added its result to the comments pane, so the pane rendered
the shared comment content without its action buttons. The pane now inserts the
shared action strip immediately after the new-comment input. WPF remains the
authority for the action-plan values; no WPF behavior was changed.

## Evidence

- Avalonia rendered action proof: `Review_comments_pane_renders_shared_action_button_states`, 1/1.
- Avalonia adjacent comment workflow proof: 3/3 passed.
- WPF/shared authority proof: `WpfCommentPanePlan_ExposesResolvedThreadActionAuthority`, 1/1.
- The formerly failing focused 8-test lane now reports 4 passed and 4 residual
  failures; the comments test is no longer among them.

## Five residual broad-suite failures

The Wave 35 historical five are the four `KeyboardContextParityTests` key-tip
cases plus the comments rendered-action test. After this change, the comments
case is closed. The four key-tip cases remain deliberately untouched:

- Three Animation nested-menu cases fail when the `B` prefix is consumed by the
  exact `Blink=B` leaf before the longer `Blinds In=BI` key tip can be entered.
  This is a real Avalonia key-tip routing gap for a later slice.
- `AvaloniaAltKeyTipsOpenComboBoxAndLeaveLeafCommandsUntouched` stops in test
  setup with `Sequence contains no matching element` while looking up the
  `freep.font-family` control. It does not reach the production key-tip route,
  so this is currently a test-isolation/visual-tree coverage residual, not
  proof of a WPF-over-Avalonia command mismatch.

The current unfiltered lane also has a sixth, newer stale expectation for the
Transitions group after the upstream Rehearse/Record Timings commands were
added; it is outside this bounded slice.
