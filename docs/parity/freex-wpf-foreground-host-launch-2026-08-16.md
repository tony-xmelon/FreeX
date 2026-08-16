# FreeX WPF foreground host launch repair — 2026-08-16

## Finding

The guarded WPF foreground ribbon harness originally launched the generated
`FreeX.ParityCapture.Wpf.exe` apphost directly. On this machine that apphost
showed the generic **You must install or update .NET** modal instead of the
FreeX workbook window, despite Microsoft.WindowsDesktop.App 10.0.9 and 10.0.11
being installed. Host tracing identified the cause: the inherited
`DOTNET_ROOT=C:\Users\ali\.dotnet` redirected the apphost to a user-local
10.0.0 runtime, which cannot satisfy the 10.0.9 framework request. UI
Automation therefore found the runtime modal rather than the `Home` tab and
correctly rejected the capture.

Launching the matching managed assembly through the installed `dotnet` host is
valid and starts the same capture-host assembly without the modal:

```powershell
dotnet tools/FreeX.ParityCapture.Wpf/bin/Release/net10.0-windows10.0.19041.0/FreeX.ParityCapture.Wpf.dll
```

The probe exposed `Book1 - FreeX` and all nine expected visible UI-Automation
`TabItem` nodes: Home, Insert, Draw, Page Layout, Formulas, Data, Review, View,
and Help. The probe process was closed and retained no screenshot evidence.

## Harness behavior

The capture project now configures its direct apphost with
`AppHostDotNetSearch=Global`, including the normal build output (the SDK applies
this setting to publish output by default, so the project adds the equivalent
build target). The apphost therefore selects the registered
`C:\Program Files\dotnet` Windows Desktop runtime before the stale user-local
root. A published direct EXE using that configuration reached `Book1 - FreeX`
under the poisoned `DOTNET_ROOT` environment.

`tools/screenshot_ribbon.ps1` also retains a compatibility route: it discovers
or accepts the capture-host executable, resolves its sibling DLL, and launches
that assembly through `dotnet`. Its existing process/title foreground guards,
full 36-state matrix guard, and screen-copy policy are unchanged. A missing
sibling DLL or `dotnet` host fails before capture; a partial or unfocused
capture is discarded.

The capture-ready command remains:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/screenshot_ribbon.ps1 -Widths max,1100,900,750
```

Run it only while FreeX owns the unlocked interactive desktop. It creates no
synthetic fallback and must retain all 36 tab/width states before the WPF
app-chrome matrix is considered refreshed.
