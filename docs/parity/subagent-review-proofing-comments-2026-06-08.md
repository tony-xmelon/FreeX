# Review Proofing and Comments Parity - 2026-06-08

Scope: Review tab proofing, Workbook Statistics, Check Accessibility, and comment/note affordance validation outside the active `review-protection-parity` and `review-comments-protection` worker edits.

## Findings Addressed

- The Review `Spelling` command did not expose an explicit `AutomationProperties.AutomationId` or `AutomationProperties.HelpText`, while adjacent Workbook Statistics and Check Accessibility commands already did. Added `ReviewSpellingButton` and reused the localized spelling tooltip description as HelpText.
- Compact Review comment/note buttons (`Prev`, `Next`, `Delete`, `New`, etc.) relied on tooltip title for automation name but did not expose stable AutomationIds or HelpText. Added explicit AutomationIds and HelpText for New/Delete/Previous/Next/Show comment commands and New/Edit/Delete/Previous/Next/Show note commands.
- The clean Check Accessibility dialog used an OK button that returned `DialogResult = true`. `MainWindow` interprets `true` as "navigate to the selected issue", so a no-issue result could route into a null `Result`. The clean OK path now closes with `DialogResult = false`, preserving the OK-only UI while preventing accidental navigation.

## Validation Notes

- Current Review markup does not contain Thesaurus, Smart Lookup, or Show Changes commands. No affordance or dialog behavior was changed for those absent commands in this slice.
- Workbook Statistics already had a stable AutomationId/HelpText and focused the OK button; this slice added regression coverage alongside the newly covered Review buttons.
- Check Accessibility issue-list navigation remains list-based with Go To/double-click behavior; this slice only changed the clean no-issue close result.

## Deliberately Left Out

- Sheet/workbook protection workflows, password dialogs, and Allow Edit Ranges behavior are owned by the active protection branch.
- Comment/note command handlers, comment list panes, and `CommentNavigationPlanner` are being edited in the active comments/protection branch. This slice only updated Review ribbon XAML affordances and did not modify those owned files.
- Slicer/timeline, formula auditing, chart, backstage, status bar, Help/Legal, grid resize/unhide, and formula bar areas were not touched.
