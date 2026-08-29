# FreeX Wave198: Home ribbon Font Family persistence

Wave198 adds a bounded production FreeX Avalonia Docker/X11 workflow for the original Linux font-face parity gap. The focused `ribbon-font-family` selector opens a deterministic XLSX fixture, selects `A1`, enters the real Home ribbon through `Alt`, `H`, opens the rendered Font combo, clicks `Arial`, and saves through production `Ctrl+S` with the existing `Shift+F12` fallback.

The probe records automatic combo-close focus separately, then physically reselects `A1` through the worksheet grid and sends `Right` followed by `Ctrl+C`; `B1` must be copied as `Unchanged`, proving subsequent worksheet keyboard routing after the ribbon interaction. It then inspects the saved XLSX package and requires the target cell style to reference a font whose `<name>` value is `Arial`. The runner's `resume-provenance.json` records the exact source commit, published payload fingerprint, and owned Docker image used for the final evidence. Automatic combo-close focus is an unresolved observed gap when the probe records `automatic-focus-after-combo=false`; the explicit worksheet reselect is not evidence of automatic focus parity.

This is a single-cell, single-family, Linux X11/Avalonia workflow. It does not claim broad font coverage, visual text-rendering parity, WPF execution, Wayland behavior, or persistence of arbitrary user-entered font names. The production route is compared with the WPF `FontNameBox_SelectionChanged` handler and the shared `WorkbookSession.SetSelectedRangeFontName` contract.

## Verification

Run from the repository root:

```powershell
pwsh -File tools/Run-FreeXLinuxInteractionValidation.ps1 -PhysicalOnly -PhysicalProbeSelector ribbon-font-family -TimeoutMinutes 8
```

Expected focused evidence is one passed physical row with `automatic-focus-after-combo=false`, `automatic-focus-status=unresolved-observed`, `worksheet-focus-after-reselect=true`, `save-clean=true`, and `style-id=1|font-id=1|font-name=Arial|font-family=true`. Screenshots, the postcondition transcript, physical manifest, interaction report, and provenance are written under `artifacts/linux-interactive/freex/interaction-validation/<timestamp>/`.

The accepted Wave198 run and exact provenance are recorded in [FINAL-EVIDENCE.md](FINAL-EVIDENCE.md).
