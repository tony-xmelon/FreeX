# FreeX Options General parity, Wave23

Surface: `dialog.Options.General` (the default `dialog.Options` capture is the same General client frame).

## Authority and implementation

- WPF authority: `src/FreeX.App.Host/OptionsDialog.xaml` and `OptionsDialog.xaml.cs`.
- Avalonia implementation: `src/FreeX.App.Avalonia/MainWindow.Options.cs`.
- Shared layout and projection contract: `src/FreeX.App.Services/OptionsDialogPlanner.cs`.
- Focused tests: `tests/FreeX.App.Services.Tests/OptionsDialogPlannerTests.cs` and `tests/FreeX.App.Avalonia.Tests/OptionsDialogGeneralParitySourceTests.cs`.

The General page now uses the WPF 230 px label column, 200/80 px field widths, zero row gap, WPF section and field margins, 18 px checkbox rows, the exact ScreenTips label, an editable font-size picker, a full-width username field, and a fixed 220 px category column. The Collapse Ribbon checkbox now mirrors WPF state and persists through the shared planner while legacy planner callers continue to carry the existing value.

## Evidence

- WPF: `docs/parity/dialog-visual-assets/wpf-capture/dialog.Options.General.png`
- Avalonia: `docs/parity/dialog-visual-assets/avalonia-capture/dialog.Options.General.png`
- Fresh run: `artifacts/options-general-wave23-capture-corrected/freex/sessions/20260727T071328665Z/general-capture/manifest.json`
- Generated report: `docs/parity/dialog-visual-evidence-summary.md` and `.json`

The fresh Ubuntu 24.04 Docker/Xvfb capture is 744x521 at 96 DPI. The paired triage score improved from `0.111494` to the exact `0.032147`; the refreshed report has zero scale-aware dimension mismatches. The Linux fixture resolves the default persisted user name as `root`, while the WPF authority screenshot contains `anton`; this remaining text-content difference is fixture state, not General geometry.
