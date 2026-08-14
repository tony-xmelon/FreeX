# macOS Platform Service Inventory

This inventory maps the Windows/WPF platform services that matter for the first
macOS public preview to the current Avalonia/macOS surface or to the abstraction
decision still needed. It is scoped to the repository state on `origin/main` as
of 2026-06-09 and is intended to guide preview readiness, not to define full
Excel parity.

<!-- Path correction 2026-08-08: the shared-tier extraction moved several files listed
below out of `src/FreeX.App.Services` into `shared/Free.Shared.AppServices` (same
behavior, now shared with FreeW/FreeP): ApplicationDataPathProvider.cs,
AppDiagnosticsPathProvider.cs, AppStoragePathPlanner.cs, AtomicFileWriter.cs,
RecentFilesStore.cs, WorkbookFileAccessIdentity.cs, PlatformPathIdentityComparer.cs,
LocalFilePath.cs, WorkbookShareReadinessPlanner.cs, and WorkbookShareActionPlanner.cs.
AppOptionsStore.cs, WorkbookOpenService.cs, WorkbookSaveService.cs, and
StartupWorkbookLoader.cs are still in `src/FreeX.App.Services`. See
[shared-tier-extraction.md](shared-tier-extraction.md). -->

Priority key:

- P0: required before a public preview can be called credible.
- P1: acceptable with clear limits or fallback behavior for the first preview.
- P2: defer unless it blocks packaging, launch, open/save, or data safety.

## Inventory

| Priority | Capability | Windows/WPF surface today | Avalonia/macOS route or decision | Current refs | Windows-verifiable gates |
| --- | --- | --- | --- | --- | --- |
| P0 | App bundle, launch, and file activation | WPF desktop startup and Windows file associations stay in `FreeX.App.Host`. | Use the Avalonia app bundle metadata and activation path. `Info.plist` declares the app identity, icon, and workbook/spreadsheet document types; `App.cs` handles `IActivatableLifetime` file activation and routes opened files into `MainWindow.OpenActivatedFilesAsync`. Keep LaunchServices, Open-With/default-open, and aggregate readiness proof as hosted evidence. | `src/FreeX.App.Avalonia/FreeX.App.Avalonia.csproj`; `src/FreeX.App.Avalonia/Packaging/macos/Info.plist`; `src/FreeX.App.Avalonia/App.cs`; `src/FreeX.App.Avalonia/MacOsLaunchSmoke.cs`; `src/FreeX.App.Services/WorkbookStartupSmokeService.cs`; `.github/workflows/macos-app.yml` | `tools/Test-MacOsAppReadiness.ps1`; `tests/FreeX.App.Services.Tests/MacOsBundleMetadataTests.cs`; `tests/FreeX.App.Services.Tests/MacOsLaunchSmokeReportKeyDriftGuardTests.cs`; per-runtime artifact pass from `tools/Test-MacOsPublicPreviewReadiness.ps1`; `macos-preview-readiness` aggregate artifact |
| P0 | Open, save, save as, startup files, and recent files | WPF uses `Microsoft.Win32.OpenFileDialog`, `SaveFileDialog`, backstage recent-file actions, and host-local workbook readers/writers. | Use Avalonia `StorageProvider` for open/save panels, portable `WorkbookOpenService` and `WorkbookSaveService` for I/O, `StartupWorkbookLoader` for command-line/activation input, and `RecentFilesStore` with platform path identity rules. `WorkbookFileAccessService` is the Avalonia host boundary for file grants: on macOS it creates bookmark-backed `WorkbookFileAccessIdentity` values with `IStorageItem.SaveBookmarkAsync`, reopens them with `IStorageProvider.OpenFileBookmarkAsync` around raw-path I/O, and falls back to path-only identities elsewhere. | `src/FreeX.App.Host/MainWindow.Backstage.cs`; `src/FreeX.App.Avalonia/MainWindow.cs`; `src/FreeX.App.Avalonia/WorkbookFileAccessService.cs`; `src/FreeX.App.Services/WorkbookOpenService.cs`; `src/FreeX.App.Services/WorkbookSaveService.cs`; `src/FreeX.App.Services/StartupWorkbookLoader.cs`; `shared/Free.Shared.AppServices/RecentFilesStore.cs`; `shared/Free.Shared.AppServices/WorkbookFileAccessIdentity.cs`; `shared/Free.Shared.AppServices/PlatformPathIdentityComparer.cs`; `shared/Free.Shared.AppServices/LocalFilePath.cs` | `tests/FreeX.App.Services.Tests/AvaloniaShellSourceTests.cs`; `tests/FreeX.App.Services.Tests/RecentFilesStoreTests.cs`; `tests/FreeX.App.Host.Tests/AppFileAdapterRegistrationTests.cs`; `tools/Test-MacOsAppReadiness.ps1` |
| P0 | App data, options, diagnostics paths, and atomic writes | Windows stores app/options/diagnostics data under roaming or local app data paths. | Keep path choice in services: macOS options under `~/Library/Application Support/FreeX/options.json`, diagnostics under `~/Library/Logs/FreeX`, and portable atomic writes for JSON stores. Avalonia startup still needs host-level diagnostics wiring if public-preview evidence requires crash/session reports. | `shared/Free.Shared.AppServices/ApplicationDataPathProvider.cs`; `shared/Free.Shared.AppServices/AppDiagnosticsPathProvider.cs`; `shared/Free.Shared.AppServices/AppStoragePathPlanner.cs`; `src/FreeX.App.Services/AppOptionsStore.cs`; `shared/Free.Shared.AppServices/AtomicFileWriter.cs`; `src/FreeX.App.Host/AppDiagnostics.cs` | `tests/FreeX.App.Services.Tests/ApplicationDataPathGuardTests.cs`; `tests/FreeX.App.Services.Tests/AppStoragePathPlannerTests.cs`; `tests/FreeX.App.Services.Tests/AppOptionsStoreTests.cs`; `tests/FreeX.App.Services.Tests/AtomicFileWriterTests.cs`; diagnostics artifact checks in `tools/Test-MacOsPublicPreviewReadiness.ps1` |
| P0 | Native menus and keyboard commands | WPF ribbon, backstage, key tips, and command bindings drive most commands. | Use Avalonia `NativeMenu` for macOS menu bar commands and direct command-key routes for the public-preview command set. Do not treat WPF ribbon/key-tip parity as a preview blocker, but require live macOS proof for Command-key routing before promotion. | `src/FreeX.App.Host/MainWindow.Ribbon.cs`; `src/FreeX.App.Host/MainWindow.KeyboardCommands.cs`; `src/FreeX.App.Host/MainWindow.CommandExecution.cs`; `src/FreeX.App.Avalonia/MainWindow.cs`; `src/FreeX.App.Avalonia/MacOsLaunchSmoke.cs` | `tests/FreeX.App.Services.Tests/AvaloniaShellSourceTests.cs`; `tests/FreeX.App.Services.Tests/MacOsLaunchSmokeReportKeyDriftGuardTests.cs`; `tools/Test-MacOsAppReadiness.ps1`; live command-key checks through `tools/Test-MacOsPublicPreviewReadiness.ps1` |
| P0 | Clipboard, paste special, and image paste | WPF uses `System.Windows.Clipboard`, internal range serialization, image extraction, Paste Special dialogs, and linked-picture routes. | Use Avalonia `IClipboard` plus shared session/planner code for text, internal range paste, Paste Special choices, and bitmap paste via `TryGetBitmapAsync`. Hosted app-bundle evidence records relaxed image-clipboard markers; seeded image-only external clipboard paste remains a local/human macOS validation requirement because Windows source guards cannot prove platform clipboard fidelity. | `src/FreeX.App.Host/MainWindow.ClipboardCommands.cs`; `src/FreeX.Core.Commands/ClipboardSerializer.cs`; `src/FreeX.App.Avalonia/MainWindow.cs`; `src/FreeX.App.Avalonia/MacOsLaunchSmoke.cs` | `tests/FreeX.App.Services.Tests/AvaloniaShellSourceTests.cs`; `tests/FreeX.App.Host.Tests/ClipboardPastePlannerTests.cs`; optional live Windows clipboard tests where enabled; image clipboard evidence markers in `tools/Test-MacOsPublicPreviewReadiness.ps1` |
| P0 | Export and print preview | WPF uses fixed documents, WPF print preview, PDFsharp, and XPS writer integration. | Use the portable export/print planners and dependency-light portable PDF exporter on macOS. PDF export is preview scope; XPS, WPF print preview, native macOS print panels, and embedded-font Unicode PDF are deferred decisions. | `src/FreeX.App.Host/MainWindow.PrintExport.cs`; `src/FreeX.App.Avalonia/MainWindow.cs`; `src/FreeX.App.Services/WorkbookExportPrintPlanner.cs`; `src/FreeX.App.Services/PortablePdfExportPlanner.cs`; `src/FreeX.App.Services/PortablePdfDocumentExporter.cs`; `src/FreeX.App.Services/PortablePdfTextCapabilityPlanner.cs` | `tests/FreeX.App.Services.Tests/WorkbookExportPrintPlannerTests.cs`; `tests/FreeX.App.Services.Tests/PortablePdfExportPlannerTests.cs`; `tests/FreeX.App.Services.Tests/PortablePdfDocumentExporterTests.cs`; `tests/FreeX.App.Services.Tests/PortablePdfTextCapabilityPlannerTests.cs`; `tools/Test-MacOsAppReadiness.ps1` |
| P0 | User prompts, compact dialogs, and accessibility IDs | WPF uses `Window`, `MessageBox`, `DialogButtonRowFactory`, focus helpers, and UI Automation coverage. | Use compact Avalonia dialogs and automation IDs for preview-critical flows. Full WPF dialog layout, access-key, focus-ring, and screen-reader parity remain evidence-driven follow-up work. | `shared/Free.Shared.Shell.Wpf/WpfUserMessageService.cs`; `src/FreeX.App.Host/DialogMessageHelper.cs`; `src/FreeX.App.Host/DialogButtonRowFactory.cs`; `src/FreeX.App.Host/DialogFocus.cs`; `src/FreeX.App.Avalonia/MainWindow.cs`; `docs/planning/macos-accessibility-evidence.md` | `tests/FreeX.App.Services.Tests/AvaloniaShellSourceTests.cs`; WPF dialog/accessibility tests continue to guard Windows; human checklist evidence through `tools/Test-MacOsHumanValidationChecklist.ps1` |
| P1 | Share workbook and reveal in Finder | Windows has a WinRT share adapter using `DataTransferManager` and window interop. | Keep the shared planner and fallback path: saved workbooks can open their containing folder when a native share sheet is unavailable; unsaved, missing, invalid, cloud, or web-link paths route to Save As first with explicit readiness/status messaging. The native AppKit share-sheet adapter is present only in the macOS Avalonia TFM through `FREEX_MACOS_SHARE_SHEET`; hosted CI proves source wiring, macOS-TFM compile inclusion, and the enabled native File > Share Workbook menu marker, while real picker interaction remains human macOS validation. | `src/FreeX.App.Host/WindowsWorkbookShareService.cs`; `src/FreeX.App.Avalonia/WorkbookShareSheetService.cs`; `src/FreeX.App.Avalonia/MacOs/MacOsWorkbookShareSheetService.cs`; `shared/Free.Shared.AppServices/WorkbookShareReadinessPlanner.cs`; `shared/Free.Shared.AppServices/WorkbookShareActionPlanner.cs`; `src/FreeX.App.Avalonia/MainWindow.cs`; `src/FreeX.App.Avalonia/MacOsLaunchSmoke.cs` | `tests/FreeX.App.Services.Tests/WorkbookShareReadinessPlannerTests.cs`; `tests/FreeX.App.Services.Tests/WorkbookShareActionPlannerTests.cs`; `tests/FreeX.App.Services.Tests/AvaloniaShellSourceTests.cs`; `tests/FreeX.App.Services.Tests/MacOsBundleMetadataTests.cs`; `tools/Test-MacOsAppReadiness.ps1`; macOS human evidence before claiming interactive native share-sheet support |
| P1 | Drag and drop open | WPF handles `DragEventArgs` and `DataFormats.FileDrop`, with openability delegated to `WorkbookOpenIngressPlanner`. | Avalonia file-drop wiring is integrated for existing local workbook files and routes through the same shared open-ingress planner with busy/dirty guards. File activation and open panel remain the P0 paths; Finder drag/drop behavior still needs human macOS validation before preview promotion. | `src/FreeX.App.Host/MainWindow.FileDrop.cs`; `src/FreeX.App.Avalonia/MainWindow.cs`; `src/FreeX.App.Services/WorkbookOpenIngressPlanner.cs`; `src/FreeX.App.Services/WorkbookFileAdapterCatalog.cs`; `docs/release/macos-public-preview-checklist.md` | `tests/FreeX.App.Services.Tests/WorkbookOpenIngressPlannerTests.cs`; `tests/FreeX.App.Services.Tests/AvaloniaShellSourceTests.cs`; `tools/Test-MacOsHumanValidationChecklist.ps1` |
| P1 | External/internal links, help, about, and legal notices | WPF launches browser URLs, follows workbook hyperlinks, and shows host dialogs. | Avalonia uses the shared safe-URI policy plus `TopLevel.Launcher` for app help/feedback/legal links and external workbook hyperlinks, compact dialogs for about/legal text, and `WorkbookSession` for `PlaceInThisDocument` navigation. Local workbook-file links pass through the same supported-adapter/open-ingress guard as ordinary file opening. Remaining follow-up is localization and richer help chrome, not hyperlink execution. | `shared/Free.Shared.AppServices/ExternalUriLauncher.cs`; `src/FreeX.App.Avalonia/MainWindow.cs`; `src/FreeX.App.Services/HyperlinkNavigationPlanner.cs`; `src/FreeX.App.Services/WorkbookSession.cs`; `src/FreeX.App.UI/IUserMessageService.cs` | `tests/FreeX.App.Services.Tests/ExternalUriLauncherTests.cs`; `tests/FreeX.App.Services.Tests/AvaloniaShellSourceTests.cs`; `tests/FreeX.App.Services.Tests/HyperlinkNavigationPlannerTests.cs`; `tests/FreeX.App.Services.Tests/WorkbookSessionTests.cs` |
| P1 | Data, what-if, and review command surfaces | WPF has fuller modal dialogs for data validation, goal seek, scenarios, tables, forecast, review tools, and command results. | Use Avalonia compact dialogs backed by shared workbook-session services and planners. Preview can ship with narrower dialog polish if data mutation paths are covered and unsupported states are explicit. | `src/FreeX.App.Host/MainWindow.DataCommands.cs`; `src/FreeX.App.Host/MainWindow.DataFilterCommands.cs`; `src/FreeX.App.Host/MainWindow.ScenarioCommands.cs`; `src/FreeX.App.Host/MainWindow.ReviewCommands.cs`; `src/FreeX.App.Avalonia/MainWindow.cs`; `src/FreeX.App.Services/DataValidationPreviewPlanner.cs`; `src/FreeX.App.Services/GoalSeekRequestParser.cs`; `src/FreeX.App.Services/ScenarioManagerPlanner.cs`; `src/FreeX.App.Services/ReviewWorkflowPlanner.cs` | `tests/FreeX.App.Services.Tests/AvaloniaShellSourceTests.cs`; existing service/planner tests for each command family; WPF dialog tests remain Windows-only parity guards |
| P1 | Multi-window and window management | WPF has workbook window registry, New Window, Switch Windows, Arrange All, Side by Side, and related ribbon flows. | Use the native macOS Window menu currently present in Avalonia for Minimize, Zoom, and Bring All to Front. Defer Excel-like workbook window orchestration unless preview usability testing shows it blocks common workflows. | `src/FreeX.App.Host/WorkbookWindowRegistry.cs`; `src/FreeX.App.Host/MainWindow.MultiWindow.cs`; `src/FreeX.App.Avalonia/MainWindow.cs` | WPF registry/window tests continue for Windows; `tests/FreeX.App.Services.Tests/AvaloniaShellSourceTests.cs` guards current native Window menu markers |
| P1 | Localization and culture | WPF has `UiText`, localization extensions, culture catalog, and localized resources. | `Info.plist` advertises bundled localizations, but the Avalonia preview shell still contains many literal strings. Public preview can be English-only if release notes say so; localized preview UI requires extracting or sharing text resources before claim. | `src/FreeX.App.Host/AppLocalization.cs`; `src/FreeX.App.Host/UiText.cs`; `src/FreeX.App.Host/LocExtension.cs`; `src/FreeX.App.Avalonia/Packaging/macos/Info.plist`; `src/FreeX.App.Avalonia/MainWindow.cs` | WPF localization tests; `tests/FreeX.App.Services.Tests/MacOsBundleMetadataTests.cs`; add Avalonia text-resource guards before promising localized UI |
| P2 | WPF visual chrome, ribbon, backstage, task panes, and grid renderer parity | WPF owns the mature ribbon/backstage/task-pane chrome and many rendering controls. | Keep Avalonia's preview shell focused on workbook access, menus, toolbar actions, and safe data operations. Decide later whether to extract more rendering/chrome abstractions or keep separate host-specific implementations. | `src/FreeX.App.Host/*.xaml`; `src/FreeX.App.UI`; `src/FreeX.App.Avalonia/MainWindow.cs` | `tests/FreeX.App.Services.Tests/AppServicesPortabilityGuardTests.cs`; `tests/FreeX.App.Services.Tests/AvaloniaProjectPortabilityGuardTests.cs`; Windows UI tests remain authoritative for WPF; Avalonia source guards cover preview shell breadth |
| P2 | Crash analytics and remote telemetry | WPF has diagnostics and optional Sentry startup integration. | Keep path planning portable and require local diagnostics evidence for preview artifacts. Remote analytics on macOS should be an explicit product/privacy decision, not an automatic port of WPF startup behavior. | `src/FreeX.App.Host/AppDiagnostics.cs`; `src/FreeX.App.Host/App.xaml.cs`; `src/FreeX.App.Services/AppDiagnosticsPathProvider.cs`; `src/FreeX.App.Services/AppStoragePathPlanner.cs` | `tests/FreeX.App.Host.Tests/AppDiagnosticsStartupTests.cs`; `tests/FreeX.App.Host.Tests/AppCrashAnalyticsTests.cs`; diagnostics artifact checks in `tools/Test-MacOsPublicPreviewReadiness.ps1` |

## Workbook File-Access Identity Contract

The portable workbook access surface stays host-neutral even when the Avalonia
host carries macOS grants:

- The shared identity for an opened, saved, recent, activated, dropped, shared,
  or exported workbook is its normalized absolute local file path plus the
  existing `PlatformPathIdentityComparer` matching rule. Windows keeps
  slash-normalized, case-insensitive matching; Unix/macOS keeps ordinal path
  matching so case-sensitive volumes can distinguish files.
- `FreeX.App.Services` may carry `WorkbookFileAccessIdentity` alongside paths,
  update it after Save or Save As, and pass it through open/session/recent-menu
  planners. It must not depend on Avalonia `IStorageFile`, AppKit `NSUrl`,
  Foundation security-scoped bookmark APIs, LaunchServices document handles, or
  other host-owned grant objects.
- `WorkbookFileAccessService` belongs to the Avalonia host layer. It creates
  bookmark identities from selected `IStorageItem` instances, resolves stored
  bookmarks through the Avalonia `StorageProvider`, maps them back to the same
  absolute local path identity before calling shared services, and clears grants
  when a recent file entry is removed.
- Diagnostics for the grant lifecycle are redacted readiness evidence only.
  The safe events `workbook_file_access_identity` and
  `workbook_file_access_scope` may record the allowlisted properties
  `grantKind` and `payloadRedacted`; they must not record absolute paths,
  filenames, workbook contents, formulas, worksheet data, or bookmark payload
  bytes/strings.
- Hosted GitHub Actions can prove the instrumentation and artifact plumbing are
  present, but it cannot prove that a sandboxed macOS process has real
  security-scoped read/write access to tester-selected files. Keep on-device
  manual validation for picker open, save, Save As, recent reopen,
  Finder/Open-With activation, and any sandboxed security-scope confirmation
  before promoting the claim.
- If live sandboxed macOS validation shows Avalonia bookmarks do not keep
  FreeX's raw-path workbook readers/writers authorized, the next slice should
  add a macOS-only native adapter under `src/FreeX.App.Avalonia/MacOs/` using
  Foundation security-scoped bookmark APIs. `FreeX.App.Services` must still see
  only `WorkbookFileAccessIdentity`.
- `recent.json` remains backward compatible. Path-only entries omit
  `FileAccessIdentity`; the optional field is persisted only when a host supplies
  bookmark/grant metadata. Do not persist bookmark payloads in workbook files,
  diagnostics, export metadata, or app logs.

## Suggested Public-Preview Gates

Run these from Windows before accepting a macOS-preview branch into the release
lane:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-MacOsAppReadiness.ps1
dotnet test FreeX.DefaultTests.slnx --configuration Release --filter 'FullyQualifiedName~FreeX.App.Services.Tests.PortablePdfDocumentExporterTests|FullyQualifiedName~FreeX.App.Services.Tests.PortablePdfExportPlannerTests|FullyQualifiedName~FreeX.App.Services.Tests.PortablePdfPageContentPlannerTests|FullyQualifiedName~FreeX.App.Services.Tests.WorkbookExportPrintPlannerTests|FullyQualifiedName~FreeX.App.Services.Tests.WorkbookShareActionPlannerTests|FullyQualifiedName~FreeX.App.Services.Tests.WorkbookViewportScrollPlannerTests|FullyQualifiedName~FreeX.App.Services.Tests.AppServicesPortabilityGuardTests|FullyQualifiedName~FreeX.App.Services.Tests.AvaloniaProjectPortabilityGuardTests|FullyQualifiedName~FreeX.App.Services.Tests.ApplicationDataPathGuardTests|FullyQualifiedName~FreeX.App.Services.Tests.AvaloniaShellSourceTests|FullyQualifiedName~FreeX.App.Services.Tests.MacOsLaunchSmokeReportKeyDriftGuardTests'
```

For produced macOS artifacts, require the hosted evidence validators already in
the repo:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-MacOsPublicPreviewReadiness.ps1 -ArtifactRoot <artifact-root> -ExpectedRunId <run-id> -ExpectedRunAttempt <attempt> -DistributionCandidate -RequireSeparateDiagnosticsArtifact -RequireReleasePublicationArtifact
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-MacOsHumanValidationChecklist.ps1 -ChecklistPath <completed-checklist>
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-MacOsPublicPreviewPromotion.ps1 -ArtifactRoot <artifact-root> -ChecklistPath <completed-checklist> -ExpectedRunId <run-id> -ExpectedRunAttempt <attempt> -DistributionCandidate -RequireSeparateDiagnosticsArtifact -RequireReleasePublicationArtifact
```

For docs-only changes to this inventory, `git diff --check` is the minimum
sanity check.

## Non-Goals

- Build the WPF application or run WPF UI tests on macOS.
- Replace Windows tester releases, MSIX packaging, or Excel COM fidelity
  evidence.
- Claim public distribution readiness without Developer ID signing,
  notarization, stapling, Gatekeeper, Finder double-click/default-handler,
  VoiceOver, and live keyboard/clipboard evidence from macOS.
- Promise WPF feature parity for XPS export, native print panels, embedded-font
  Unicode PDF, full dialog/access-key parity, the WPF ribbon/backstage/task-pane
  model, full multi-window workbook orchestration, or advanced multi-range
  clipboard behavior.
- Claim native macOS share-sheet support before a host adapter and human
  evidence exist.
- Use this planning document as authorization to refactor `FreeX.App.Host`,
  `FreeX.App.UI`, workflow files, or test infrastructure.
