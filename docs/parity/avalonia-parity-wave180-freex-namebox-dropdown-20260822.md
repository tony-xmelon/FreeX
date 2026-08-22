# Avalonia Parity Wave180: FreeX Name Box Dropdown

Date: 2026-08-22  
Application: FreeX Avalonia Application host  
Display: 1280x820 at 96 DPI  
Slice branch: `codex/wave180-freex-chart-interaction-20260822`

## Selected Gap and Root Cause

The highest-impact actionable FreeX residual selected from the current parity
inventory was the Name Box dropdown workflow. The Linux popup opened, but its
navigation rows were blank in the physical X11 capture, preventing keyboard,
mouse, defined-name, table, and drawing-object selection. The existing Avalonia
implementation supplied prebuilt `ListBoxItem` containers through `ItemsSource`.
Avalonia then treated those containers as data and did not render the WPF-shaped
row content reliably inside the popup.

## Bounded Change

The popup now uses the Avalonia-native model-backed `FuncDataTemplate`, an
explicit fixed viewport, and a non-virtualizing `StackPanel` items panel. The
existing planner, selection handlers, row labels, font, padding, and automation
descriptions remain unchanged. A focused test exercises the production popup
population path and verifies the five physical-fixture navigation labels.

Changed files:

- `src/FreeX.App.Avalonia/MainWindow.cs`
- `tools/FreeX.ParityCapture.Avalonia/TestSupport/MainWindow.TestAccess.cs`
- `tests/FreeX.App.Avalonia.Tests/AvaloniaMainWindowNameBoxStage2Tests.cs`

## Evidence

Managed regression evidence:

```text
dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj -c Release --no-restore --filter FullyQualifiedName~AvaloniaMainWindowNameBoxStage2Tests
Passed: 16, Failed: 0, Skipped: 0
```

Before, the bounded physical selector at 1280x820/96 DPI recorded `0/8` and
captured a blank popup in
`artifacts/linux-interactive/freex/sessions/20260822T141407509Z/x11-validation/`.
The same selector was rerun after the change at sessions
`20260822T142057685Z`, `20260822T142423853Z`, and `20260822T143015611Z`.

## Honest Physical Residual

The physical runner still exits nonzero because the application capture remains
blank and the probe cannot write the required
`name-box-dropdown-object-state.jsonl`; the final bounded run reports the same
missing artifact for Chart, Picture, Shape, and TextBox rows. No physical pass
is claimed from the managed test. This remaining X11 residual needs a follow-up
with live visual-tree inspection or a custom popup renderer; it is outside this
bounded checkpoint slice.
