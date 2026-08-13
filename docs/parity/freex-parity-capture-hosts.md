# FreeX parity capture hosts

FreeX parity capture tooling is owned by dedicated renderer executables:

- WPF: `tools/FreeX.ParityCapture.Wpf/FreeX.ParityCapture.Wpf.csproj`
- Avalonia: `tools/FreeX.ParityCapture.Avalonia/FreeX.ParityCapture.Avalonia.csproj`

The capture hosts preserve the existing command contracts:

```powershell
dotnet run --project tools/FreeX.ParityCapture.Wpf --configuration Release -- --parity-capture <output> --parity-capture-target <surface>
dotnet run --project tools/FreeX.ParityCapture.Avalonia --configuration Release -- --parity-capture <output> --parity-capture-surface <surface>
```

The shipping `FreeX.App.Host` and `FreeX.App.Avalonia` assemblies do not contain capture coordinators, screenshot tours, interaction-validation harnesses, or a reference to `FreeX.ParityCapture.Support`. Capture-host projects compile the renderer source with `FREEX_PARITY_CAPTURE` and add tool-owned capture partials. Production retains only renderer-neutral state and the smallest UI adapter members required by those partials.

`tools/FreeX.ParityCompare`, `tools/Run-LinuxParityCapture.ps1`, and `tools/screenshot_ribbon.ps1` invoke these hosts rather than shipping executables.
