# FreeW Avalonia Parity Wave 81

## Reviewing Pane sort workflow

WPF's Reviewing Pane exposes a live sort selector for sequence, author, revision type, and date. The selected order is applied when the pane refreshes, so its visible row remains the target for navigation and single-change accept/reject actions.

Avalonia now uses the shared `ReviewRevisionSortPlanner` for the same four orders, renders the selector in its Reviewing Pane, and refreshes the live rows when the order changes. The WPF `RevisionSortComparer` remains as a host-facing facade over that shared policy, keeping both hosts aligned without duplicating sort rules.

Focused coverage: `ReviewRevisionSortPlannerTests.Sort_orders_are_stable_and_leave_sequence_untouched` and `ReviewChangeNavigationTests.ReviewingPane_sort_reorders_live_entries_and_keeps_selected_entry_actionable`.
