# macOS Port State Management Note

**Last updated:** 2026-06-09 (path correction 2026-08-08: the recent-file/app-data-path implementation moved from `FreeX.App.Services` into the cross-app shared tier)

This note narrows the state-storage guidance from the [multiplatform macOS port plan](multiplatform-macos-port.md) and the [macOS dependency backlog](macos-port-dependency-backlog.md). The current tree has no `docs/research/` directory; the active anchors are the planning docs plus the portable recent-file implementation, now in `shared/Free.Shared.AppServices` (`RecentFilesStore.cs`, `ApplicationDataPathProvider.cs`) rather than `FreeX.App.Services`.

## Placement Rules

| State | Windows location | macOS location | Notes |
| --- | --- | --- | --- |
| User options, profile name, language, Quick Access Toolbar, custom dictionary, and crash opt-in | `%APPDATA%\FreeX\options.json` | `~/Library/Application Support/FreeX/options.json` | Durable per-user app settings. Windows should keep the current roaming `ApplicationData` path unless a migration is explicitly scoped. |
| Recent workbook history | `%APPDATA%\FreeX\recent.json` | `~/Library/Application Support/FreeX/recent.json` | Durable app-owned state shared by WPF and Avalonia hosts. Pinning is FreeX-specific, so native OS recent-document lists can only be mirrors. |
| Local diagnostics, usage events, and crash files | `%LOCALAPPDATA%\FreeX\Diagnostics` | `~/Library/Logs/FreeX` | Local tester diagnostics, not user preferences. Keep aligned with the [privacy notice](../legal/privacy.md), and never let diagnostics failures affect app behavior. |
| Disposable cache or generated render artifacts | `%LOCALAPPDATA%\FreeX\Cache` or the process temp directory | `~/Library/Caches/FreeX` or the process temp directory | Delete-safe state only. Do not put cache output in Application Support. |
| User workbooks | User-selected file paths | User-selected file paths | Workbook contents and workbook-authored state belong in the saved workbook, not in app data. |

Use Application Support for durable user/app state that should survive app restarts and machine cleanup. Use Logs or Caches for local artifacts that are not preferences. The recent-file store may hold app-owned paths and grant metadata as described below, but diagnostics must not record workbook file paths, filenames, contents, formulas, or bookmark payloads.

## Recent Files

`RecentFilesStore` is the current source of truth for recent workbook state. Both WPF and Avalonia should use the shared store rather than keeping host-specific recent-file lists.

- Store the file at `<application-data-root>/FreeX/recent.json`, where `IApplicationDataPathProvider` resolves the platform root.
- Persist JSON entries with absolute local `Path`, `LastOpened` as a `DateTimeOffset`, and `IsPinned`. `FileAccessIdentity` is optional, omitted for path-only identities, and may contain host-supplied bookmark or grant metadata such as the Avalonia macOS storage bookmark used for security-scoped access.
- Keep the newest entry first, cap the list at 25 entries, and preserve pin state when a file is reopened.
- Write through `AtomicFileWriter` so an interrupted save does not corrupt `recent.json`.
- Add or update entries only after a successful startup activation, open, save, or save-as path. Pin, unpin, and remove commands may update the store directly.
- Preserve an existing bookmarked `FileAccessIdentity` when a path-only reopen or same-path save updates the entry. Save As to a different path should not carry the old grant unless the host supplies a fresh identity for the new path.
- Route path identity through `PlatformPathIdentityComparer`: Windows recent-file matching stays case-insensitive and slash-normalized, while Unix/macOS matching stays ordinal so case-sensitive volumes can keep distinct paths.
- Treat Windows jump lists, macOS `Open Recent`, LaunchServices, or future `NSDocumentController` integration as platform mirrors only. They cannot carry FreeX pin state and should not become the durable source of truth.
- Keep bookmark payloads out of workbook files, diagnostics, exports, and logs. `recent.json` is the durable grant store; removing a recent entry must remove any associated grant metadata with it.
- File-access diagnostics, when present, are limited to `workbook_file_access_identity` and `workbook_file_access_scope` with safe properties `grantKind` and `payloadRedacted`. They exist to show grant plumbing and lifecycle readiness, not workbook identity, and must not include file paths, filenames, workbook contents, formulas, or bookmark payload data.

## Abstraction Direction

- Keep durable app-state stores in `shared/Free.Shared.AppServices` (not `FreeX.App.Services` — the shared-tier extraction moved `RecentFilesStore` and `ApplicationDataPathProvider` there so they are reusable by FreeW/FreeP as well as WPF and Avalonia). UI hosts should supply platform adapters; shared services must stay free of WPF, `Microsoft.Win32`, WinRT, COM, and Windows target frameworks.
- Use `IApplicationDataPathProvider` for durable app data today. Before moving more WPF settings into shared macOS code, route `FreeXOptions` through a provider or settings-store abstraction instead of direct `Environment.GetFolderPath` calls.
- Add separate providers for non-durable roots when needed, such as diagnostics and cache paths. Do not overload the application-data provider for logs, crash files, or generated cache artifacts.
- Keep JSON state stores schema-tolerant, best-effort on load, atomic on save, and testable through injected paths and clocks.
- Keep workbook/document state in `Core.Model` and `Core.IO`. Shared command/session state belongs in `WorkbookSession` or platform-neutral planners; platform-only window geometry, menu wiring, and shell affordances can remain host-specific.
