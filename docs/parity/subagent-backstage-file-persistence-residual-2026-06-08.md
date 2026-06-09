# Backstage File Persistence Residual Pass - 2026-06-08

## Scope

- Reviewed File/Backstage Open, Recent, Save, Save As, and export-adjacent persistence behavior in `MainWindow.Backstage.cs`, `MainWindow.WorkbookLifecycle.cs`, `RecentFilesStore.cs`, and existing host planner tests.
- Kept the implementation bounded to recent-file persistence; no shared XAML was changed.

## Excel Comparison

- Microsoft's Backstage support page describes pinning as the way to keep a file on the recent-files list: https://support.microsoft.com/office/start-backstage-with-the-file-tab-04610088-406c-43d0-98a0-c1999ab4ef53.
- FreeX already exposes Recent/Pinned lists, filtering, pin/unpin/remove context menu actions, open/save recency updates, and Save/Save As routing through the existing file lifecycle.
- Residual gap found: `RecentFilesStore` needed load-time normalization and isolated persistence tests around pinned retention, so pinned workbooks remain available through normal Backstage Recent churn.

## Changes

- `RecentFilesStore` now supports an internal store path and UTC clock constructor for isolated persistence tests without touching the user's real AppData recent-file store.
- Overfull persisted stores are normalized on load with the aggregate branch's pinned-retention rule: keep up to 25 unpinned recent entries while preserving pinned workbooks.
- Added focused host tests proving add/update trimming preserves pinned entries and that an overfull persisted `recent.json` is normalized without dropping pinned entries.

## Remaining Gaps

- Full Microsoft 365 cloud recent locations, account-backed recents, and SharePoint/OneDrive pin synchronization remain out of scope for the local FreeX Backstage model.
- Export to PDF/XPS remains partial per `docs/parity/menu-toolbar.md`; this pass did not alter PDF/XPS publish options or print-preview behavior.
