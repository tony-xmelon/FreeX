# FreeX Wave197: Home ribbon number-format persistence

Wave197 adds a production Docker/X11 workflow for a non-default Home ribbon number format. The focused `ribbon-number-format` selector opens a deterministic XLSX fixture, selects `A1`, enters the Home ribbon through `Alt`, `H`, `N`, clicks `Number (0.00)` in the rendered Avalonia popup, saves through production `Ctrl+S` with the existing `Shift+F12` fallback, and reopens the saved XLSX ZIP to inspect `sheet1.xml` and `styles.xml`. The postcondition requires the target cell style to reference built-in `numFmtId=2`.

The route is compared with the WPF `NumberFormatBox_SelectionChanged` handler and the shared Avalonia ribbon composition. Avalonia already dispatches the canonical combo value through `ValueRibbonCommand` to `MainWindow.ApplyRibbonNumberFormat`, which calls `WorkbookSession.SetSelectedRangeNumberFormat`; the physical probe verifies that this production route persists the resulting style.

## Verification

Run from the repository root:

```powershell
pwsh -File tools/Run-FreeXLinuxInteractionValidation.ps1 -PhysicalOnly -PhysicalProbeSelector ribbon-number-format -TimeoutMinutes 8
```

Expected focused evidence is one passed physical row with `save-clean=true` and `style-id=1|numFmtId=2|number-format=true`. Generated screenshots, postcondition text, and the interaction manifest are written under `artifacts/linux-interactive/freex/interaction-validation/<timestamp>/`.
