# Avalonia Parity Wave 142: Shared Dialog Mnemonics

Date: 2026-08-04

## Scope

This slice audits the shared Avalonia and WPF dialog action-button paths used by
FreeX, FreeW, and FreeP. The selected divergence was access-key display and
registration for shared action buttons.

## Finding and fix

The WPF shared dialog resource uses `ContentPresenter RecognizesAccessKey="True"`,
so `_OK`, `_Cancel`, and other mnemonic-bearing strings render without the
underscore and expose an Alt access key. The Avalonia shared factories passed the
same strings directly to Fluent `Button.Content`; Avalonia therefore did not get
the WPF mnemonic presentation contract.

`AvaloniaDialogButtonContent` now adapts mnemonic-bearing strings to
`AccessText`, keeps non-mnemonic content unchanged, preserves the existing
default/cancel flags and action order, and sets Avalonia automation access-key
metadata. Both `AvaloniaDialogButtonRowFactory` and
`AvaloniaCompactDialogChrome.CreateActionButton` use the adapter.

## Evidence

- Shared Avalonia build: `dotnet build shared\\Free.Shared.Shell.Avalonia\\Free.Shared.Shell.Avalonia.csproj --configuration Release --no-restore -v:minimal`
  passed with 0 warnings and 0 errors.
- Focused shared-shell headless behavior suite:
  `dotnet test tests\\Free.Shared.Shell.Avalonia.Tests\\Free.Shared.Shell.Avalonia.Tests.csproj --configuration Release --no-restore --logger "console;verbosity=minimal"`
  passed `1/1`.
- The behavior test verifies runtime `AccessText` content, marker preservation
  for the access-key parser, automation names (`OK`, `Cancel`, `Apply`),
  `Alt+O`/`Alt+C`/`Alt+A` metadata, unchanged default/cancel semantics, and
  the direct shared `ApplyButton` path.
- The shared-shell test project is invoked directly for focused validation and
  is listed only in the shared/default test-solution inventories; no
  FreeX/FreeW/FreeP app file or app-specific test was changed.
- WPF authority is `shared/Free.Shared.Shell.Wpf/DialogResources.xaml` and
  `shared/Free.Shared.Shell.Wpf/DialogButtonRowFactory.cs`.

## Residuals

This fixes the shared Avalonia action-button mnemonic path only. Avalonia native
message dialogs still have framework-specific icon, title-bar, and text-wrapping
metrics compared with WPF `MessageBox`; those require a separate evidence-backed
message-dialog slice. App-owned buttons that bypass the shared factories remain
outside this change.
