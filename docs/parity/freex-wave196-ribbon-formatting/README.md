# FreeX Wave196: Home ribbon formatting

Wave196 adds the first production FreeX Avalonia Docker/X11 probe for a ribbon command that mutates workbook state.

The focused `ribbon-formatting` selector opens a deterministic XLSX fixture, selects `A1`, enters the Home ribbon through the real key-tip sequence `Alt`, `H`, `1`, and saves through the production application. The probe reads the saved XLSX package and requires the target cell's style to reference a font containing `<b/>`. Screenshots capture the before, key-tip, and after states alongside `ribbon-home-bold-keytip-postcondition.txt`.

The route is intentionally checked against the WPF handler and the shared `WorkbookFormatRibbonCommands.Bold` implementation. This keeps the evidence about actual Avalonia input and persistence while preserving the existing shared command contract.

Run from the repository root:

```powershell
pwsh -File tools/Run-FreeXLinuxInteractionValidation.ps1 -PhysicalOnly -PhysicalProbeSelector ribbon-formatting -TimeoutMinutes 8
```

The runner owns and removes only its `freex-linux-interactive-frex-6082` container. The generated evidence is written under `artifacts/linux-interactive/freex/interaction-validation/<timestamp>/`.
