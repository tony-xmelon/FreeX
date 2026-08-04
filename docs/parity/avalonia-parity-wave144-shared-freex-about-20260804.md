# Avalonia Parity Wave 144: Shared FreeX About

Date: 2026-08-04  
Scope: FreeX About dialog presentation across WPF and Avalonia

## Audit

Before this wave, both hosts already used the shared `AboutDialogPresentation` realization, but
each wrapper assembled its own title, body text, automation IDs, and help text. WPF sourced the
body from `AppInfo.AboutText` and localized its title/help strings; Avalonia rebuilt the body
through `AppHelpInfo.BuildAboutText` and hard-coded the corresponding English chrome.

The host realizations already agreed on the WPF-authority geometry, read-only copyable text box,
focused text box on open, and one `OK` action that is both default and cancel. The existing
Avalonia-specific text metrics and default root margin remain unchanged.

## Change

`FreeXAboutDialogPresentation` now owns FreeX's shared title, automation IDs, help text, version
lookup, and About content selection. Both wrappers are thin factory calls into the existing
shared WPF/Avalonia dialog realizations. WPF continues to pass its localized title/help strings;
the default English values preserve Avalonia's existing surface.

Visible content remains host-faithful:

| Surface | Preserved content |
| --- | --- |
| WPF | `VersionText`, WPF/OxyPlot platform line, and the third-party runtime notice |
| Avalonia | `VersionText`, Avalonia platform line, and the portable legal/privacy/source notices |
| Both | Product description, product/legal text, dialog/text/OK automation IDs, title, and help text |

The WPF runtime notice constant now lives in `AppHelpInfo`, while `AppInfo` retains its existing
public forwarding property. Focus/default/cancel behavior and shared geometry were not changed.

## Verification

- `dotnet restore tests\FreeX.App.Services.Tests\FreeX.App.Services.Tests.csproj; dotnet restore tests\FreeX.App.Avalonia.Tests\FreeX.App.Avalonia.Tests.csproj; dotnet restore src\FreeX.App.Host\FreeX.App.Host.csproj` - passed.
- `dotnet test tests\FreeX.App.Services.Tests\FreeX.App.Services.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~FreeXAboutDialogPresentationTests|FullyQualifiedName~AvaloniaShellSourceTests" --logger "console;verbosity=minimal"` - passed, 78/78.
- `dotnet test tests\FreeX.App.Avalonia.Tests\FreeX.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~AboutDialogParityTests" --logger "console;verbosity=minimal"` - passed, 1/1.
- `dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -clp:Summary -v:minimal` - passed, 0 warnings/errors.
- `dotnet restore tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj; dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~AboutDialogTests" --logger "console;verbosity=minimal"` - passed, 2/2.
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1` - reached all checks through macOS readiness, then failed on the pre-existing guard requiring `AppHelpInfo.BuildAboutText(` in `src\FreeX.App.Avalonia\MainWindow.cs`; this wave keeps About construction in `AboutDialog.cs` and does not alter that unrelated guard.
- `dotnet restore FreeX.slnx` - passed, 101 projects restored or up to date.
- `dotnet build FreeX.slnx --configuration Release` - passed, 0 warnings/errors.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"` - exceeded the 300-second foreground timeout while an Avalonia test host was active; the two processes started by this command were explicitly reaped by PID. Focused affected tests remained green.
