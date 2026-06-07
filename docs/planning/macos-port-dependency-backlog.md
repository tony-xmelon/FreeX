# macOS Port Dependency Backlog

**Last updated:** 2026-06-07

This inventory tracks the Windows/WPF-only surfaces that block or shape the Avalonia/macOS port. It is intentionally practical: keep portable workbook behavior shared, replace user-facing platform services in Avalonia/native macOS, guard Windows evidence lanes, and defer deep parity where the preview does not need it yet.

## Strategy Labels

- **Keep core/shared:** keep or move logic into `Core.*` or `FreeX.App.Services` with no Windows/WPF references.
- **Replace with Avalonia/native macOS:** implement the user-facing route in `FreeX.App.Avalonia` or macOS workflow assets.
- **Guard Windows-only:** keep the Windows implementation and tests, but prevent it from entering portable projects or macOS lanes.
- **Defer:** acknowledge the dependency and leave it out of the current preview scope.

## Inventory

| Area | Current Windows/WPF owner | Port strategy | Practical backlog item |
| --- | --- | --- | --- |
| Workbook model, formulas, commands, calc, IO | `src/FreeX.Core.*` | Keep core/shared | Keep these projects plain `net10.0`; continue source guards against `System.Windows`, `Microsoft.Win32`, WinRT, COM, WPF packages, and app-project references. |
| Shared workbook session and command orchestration | `src/FreeX.App.Services` | Keep core/shared | Keep session, open/save services, clipboard serializers, compact dialog planners, find/replace, sheet, formatting, and viewport orchestration portable. New macOS features should enter here when they are not UI-specific. |
| WPF host shell, ribbon, backstage, task panes, and custom grid/chart rendering | `src/FreeX.App.Host`, `src/FreeX.App.UI` | Replace with Avalonia/native macOS | Do not port WPF XAML directly. Recreate required shell/menu/toolbar/grid/chart surfaces in `src/FreeX.App.Avalonia`, backed by shared session/core services. Keep WPF as the Windows app. |
| File dialogs and import pickers | `MainWindow.Backstage.cs`, `MainWindow.DataCommands.cs`, `MainWindow.Drawing.cs`, `MainWindow.PageLayout.cs`, `HeaderFooterDialog.Pictures.cs`, `OptionsDialog.xaml.cs` using `Microsoft.Win32.OpenFileDialog`/`SaveFileDialog` | Replace with Avalonia/native macOS | Reuse `FileDialogFilterBuilder`, file adapters, and save/open writers; keep Avalonia `StorageProvider` as the macOS path. Add new picker routes only in Avalonia or a platform-service abstraction. |
| Clipboard, paste, image paste, drag/drop | WPF clipboard/file-drop handlers in `MainWindow.ClipboardCommands.cs` and `MainWindow.FileDrop.cs`; Avalonia already uses platform clipboard for preview routes | Replace with Avalonia/native macOS | Keep payload semantics in `WorkbookSession` and `Core.Commands`; implement platform transfer details in Avalonia. Defer remaining WPF clipboard parity such as multi-range and full Paste Special dialog/access-key parity. |
| Printing, print preview, PDF, and XPS export | `PrintRenderer*`, `PrintPreviewDialog*`, `MainWindow.PrintExport.cs`, `PdfDocumentExporter.cs`, `PDFsharp-WPF`, ReachFramework/XPS, `System.Windows.Documents` | Defer / guard Windows-only | Treat current WPF fixed-document/XPS path as Windows-only. For macOS, define a future Avalonia/native print/PDF renderer backed by shared print layout models; keep XPS out of macOS scope. |
| Windows Share | `ShareWorkbookPlanner.cs`, `WindowsWorkbookShareService.cs`, `MainWindow.ReviewCommands.cs` with WinRT `DataTransferManager`, `StorageFile`, COM interop, and `WindowInteropHelper` | Keep planner shared; replace adapter / defer | Keep save-before-share planning reusable. Replace the WinRT share adapter with a macOS Finder/share-sheet/open-containing-folder decision when sharing enters macOS scope; until then hide or defer Share in Avalonia. |
| WPF modal/modeless dialogs | Many `*Dialog.xaml`, `*Dialog.xaml.cs`, and code-built dialogs under `src/FreeX.App.Host` | Replace with Avalonia/native macOS | Port dialog behavior by priority, not file-for-file. Reuse existing input parsers/planners and compact shared planners; keep WPF dialog tests as Windows coverage. |
| User messages and shell launching | `WpfUserMessageService`, WPF `MessageBox`, `ExternalUrlLauncher`, `ProcessStartInfo.UseShellExecute` export opener | Replace with Avalonia/native macOS | Use Avalonia dialogs/window ownership and `TopLevel.Launcher` where available. Keep shell-open behavior best-effort and platform-scoped. |
| UI automation and live UI tests | `FreeX.UiTests.slnx`, WPF UIA peers/tests, `tests/FreeX.App.Host.Tests`, Windows STA/UIA assumptions | Guard Windows-only; replace evidence lane | Keep WPF UIA and UI lanes on Windows. For macOS, grow hosted LaunchServices smoke, source/readiness guards, and eventual Avalonia accessibility checks instead of trying to run WPF UIA. |
| Excel COM and Windows fidelity tools | Excel desktop COM/open-save-reopen and chart/fidelity tooling; Windows clipboard facts | Guard Windows-only | Keep as Windows evidence lanes. macOS portable validation should use `FreeX.DefaultTests.slnx`, corpus tests, hosted macOS app smoke, and future manual Office-for-Mac evidence only if explicitly scoped. |
| Windows tester packaging and MSIX | `tools/Publish-UserTestBuild.ps1`, Windows SDK `makeappx.exe`/`signtool.exe`, `.github` tester release workflow | Guard Windows-only | Keep Windows tester release flow separate from macOS. Do not make MSIX assumptions in Avalonia/macOS packaging. |
| macOS app bundle, signing, notarization, LaunchServices | `.github/workflows/macos-app.yml`, `src/FreeX.App.Avalonia/Packaging/macos`, `docs/release/macos-signing-notarization.md` | Replace with Avalonia/native macOS | Continue hosted `osx-arm64`/`osx-x64` bundle evidence, ad-hoc signing for preview, optional Developer ID signing/notarization, checksum, LaunchServices, and smoke logs. Public distribution remains blocked until Developer ID/notarization/stapling and human macOS validation are recorded. |
| Source/readiness guards | `tools/Test-MacOsAppReadiness.ps1`, `MacOsAppReadinessPreflightTests`, repository preflight | Keep core/shared guard; guard Windows-only | Keep portable-source hygiene focused on `FreeX.App.Avalonia` and `FreeX.App.Services`. Extend guards when new macOS-owned services are added; do not require WPF host parity in the static readiness gate. |

## Immediate Port Priorities

1. Keep `FreeX.App.Services` and `FreeX.App.Avalonia` clean of WPF/WinRT/COM and Windows target frameworks.
2. Route any new macOS user-facing feature through shared session/core logic first, then an Avalonia platform adapter.
3. Leave print/export, Windows Share, full WPF dialog parity, WPF UIA, Excel COM, and Windows packaging as separate guarded or deferred lanes until the preview shell needs them.
4. Treat macOS public-distribution readiness as packaging/signing/notarization plus live macOS validation, not just a successful Windows preflight.
