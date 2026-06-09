# Status Footer Residual Pass - 2026-06-08

Scope: status bar/footer chrome, including aggregate panes, footer view shortcuts, zoom controls, keyboard traversal, and the status-bar customize menu.

## Findings addressed

- Added an Excel-like status-bar context menu on `StatusBarRoot` with checkable status panes and interactive footer controls.
- Routed status menu checks through the existing status display pipeline so hidden panes collapse immediately while calculations remain cached and reusable.
- Preserved aggregate pane collapse for empty selections to avoid blank footer gaps.
- Added footer view shortcut buttons for Normal, Page Layout, and Page Break Preview ahead of the zoom cluster, reusing the worksheet view commands.
- Synchronized footer view shortcut checked state from the active sheet view mode.
- Kept the aggregate implementation localized and persisted through `FreeXOptions`.

## Remaining gaps

- Some Excel status menu entries remain unmodeled because there is no corresponding FreeX runtime state yet, such as macro recording and additional workbook status indicators.
- No pixel screenshot evidence was captured in this slice; verification is through WPF/XAML/runtime tests.

## Verification coverage

- XAML tests guard the status customize menu, checkable aggregate panes, footer view shortcut buttons, zoom keytips, and zoom slider accessibility metadata.
- Runtime status tests cover aggregate labels, pane visibility toggling, footer view shortcut commands, status zoom focus traversal, and F6 shell navigation through the footer.
