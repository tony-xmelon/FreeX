# FreeP visual-evidence host ownership

FreeP's dialog-pane and whole-window capture runners are non-shipping tools. The WPF and Avalonia
applications retain only narrow native access adapters so the capture tools can prepare and inspect
the real application frame without placing capture orchestration or evidence contracts in product
assemblies.

The existing `FreeP.RenderCompare` commands are unchanged:

```powershell
dotnet run --project tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release -- --dialog-pane-visual-evidence <output-directory>
dotnet run --project tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release -- --whole-window-visual-evidence <output-directory>
```

Their default capture executables are now:

- `freep/TestSupport/VisualEvidence.Wpf/FreeP.VisualEvidence.Wpf.csproj`
- `freep/TestSupport/VisualEvidence.Avalonia/FreeP.VisualEvidence.Avalonia.csproj`

`--wpf-exe` and `--avalonia-exe` remain available for explicit tool paths. Shipping `FreeP.App.Host`
and `FreeP.App.Avalonia` no longer parse visual-evidence arguments and no longer reference
`FreeP.VisualEvidence`.
