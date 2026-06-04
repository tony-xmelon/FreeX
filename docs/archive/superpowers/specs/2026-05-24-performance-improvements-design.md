# Performance Improvements Design

## Goal

Improve perceived and real performance for file operations first, then continue into selection/ribbon navigation and other hot paths.

## Approach

File open already uses an asynchronous loader with progress. Save will get a matching host-level writer that reports staged progress and performs serialization away from the UI thread. The first UI surface for save progress will be the footer/status bar, matching Excel's unobtrusive feedback rather than the modal open overlay.

For navigation, the next target is selection-driven toolbar updates. The design will favor deduplicating repeated style snapshots and avoiding control updates when the selected cell's effective formatting state has not changed.

## Testing

Each behavior change starts with a focused failing test. Save progress will be covered by host unit tests. UI wiring that is hard to instantiate directly will be protected by existing source/XAML hygiene tests and the full solution test suite.
