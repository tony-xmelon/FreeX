# FreeW Review Selected-Change Parity, Wave 37

## Scope

Review > Changes > Accept This Change and Reject This Change now use the selected Reviewing Pane entry in Avalonia, matching the WPF authority route. Detached command registries and headless callers without a pane callback retain the existing caret-relative fallback.

## Authority and closure

- WPF `MainWindow.AcceptSelectedRevision` / `RejectSelectedRevision` resolve `_reviewList.SelectedIndex` against `_reviewEntries`.
- Avalonia `MainWindow` now supplies selected-entry callbacks to `FreeWAvaloniaRibbonCommands`.
- The Avalonia production test selects the second revision, moves the caret to the first paragraph, invokes the ribbon command, and verifies that only the selected second revision is resolved.
- With no selected Reviewing Pane entry, both single-change commands are no-ops in both hosts.
- The selected-pane route uses the existing direct `RevisionList` mutation path in each FreeW host and therefore matches the WPF host's non-undoable external mutation semantics. This note makes no claim about Word's internal undo contract.

## Verification

- WPF authority: `ReviewingPaneTests.AcceptRevision_ResolvesTheReviewingPaneSelectedEntry_NotTheCaretRelativeEntry`
- WPF authority: `ReviewingPaneTests.RejectRevision_ResolvesTheReviewingPaneSelectedEntry_NotTheCaretRelativeEntry`
- Avalonia production runtime: `ReviewChangeNavigationTests.Production_Ribbon_accept_this_resolves_the_selected_pane_revision_when_caret_is_elsewhere`
- Avalonia production runtime: `ReviewChangeNavigationTests.Production_Ribbon_reject_this_resolves_the_selected_pane_revision_when_caret_is_elsewhere`
- Avalonia no-selection guard: `ReviewChangeNavigationTests.Production_Ribbon_single_change_commands_are_noops_without_a_selected_pane_revision`
