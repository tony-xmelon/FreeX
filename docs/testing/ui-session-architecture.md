# UI Session Architecture

WPF host tests use one of two ownership models. The choice is based on what the test proves, not on the app that owns it.

## Reusable Offscreen Window

Deterministic command, rendering, ribbon, and editor-state tests borrow one offscreen `MainWindow` for the test assembly. The shared infrastructure lives in `tests/SharedTestInfrastructure/ReusableWpfWindowSession.cs`; each app supplies a reset adapter:

- FreeX creates a clean workbook and closes the backstage surface.
- FreeW exits read, multiple-pages, side-to-side, and split modes, then creates a clean document.
- FreeP creates a clean presentation.

The adapter resets both before and after each test and serializes borrowers on its dedicated STA dispatcher. A test using this model must leave assertions and mutations inside the session callback. It must not close, activate, move, or change ownership of the suite window.

Use this model for state-local UI behavior: rendered controls, command routing, menus, deterministic editor mutations, and layout modes that have an explicit reset path. It eliminates repeated `MainWindow` construction and visible shell churn while preserving an actual rendered WPF control tree.

## Fresh Window

Keep a fresh window whenever window lifetime is part of the assertion: startup and recovery, save/open/new flows, native dialogs, real focus or activation, clipboard ownership, DPI or monitor behavior, shutdown, and multi-window coordination. These tests must construct and close their own window.

## Avalonia

The Avalonia headless suites already share their headless dispatcher/session. FreeX deliberately retains per-test app isolation, which is verified by its isolation tests. Do not weaken that boundary merely to reduce window construction; migrate only after an app-level reset contract is explicit and tested.

## Validation

Run focused WPF suites serially when rebuilding locally because the three app projects share intermediate project outputs:

```powershell
dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --configuration Release -m:1
dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release -m:1
dotnet test freep/FreeP.App.Host.Tests/FreeP.App.Host.Tests.csproj --configuration Release -m:1
```

The release UI lane remains `FreeX.UiTests.slnx`. Run it after the targeted suites for WPF host or UI-session changes.
