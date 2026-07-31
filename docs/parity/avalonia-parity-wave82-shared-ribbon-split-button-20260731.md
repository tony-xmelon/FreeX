# Avalonia/WPF shared Ribbon split-button parity: Wave 82

## Scope

The shared WPF ribbon renderer now preserves the two interaction targets of a `RibbonSplitButton`:

- the primary surface executes the control command;
- the dropdown surface opens the menu and keeps menu-item execution separate;
- collapsed groups expose the primary command as a leaf and omit a duplicate primary menu entry.

This matches Avalonia's shared `BuildLargeSplitControl` behavior. The implementation keeps command
metadata, key-tip ownership, state-store binding, and host-managed WPF dropdown-zone metadata on the
corresponding rendered child controls.

## Authority

This deliberately fixes a WPF functional defect against Excel split-button semantics already
implemented by the shared Avalonia renderer. Avalonia is the authoritative existing implementation
for this interaction; the change does not redefine Avalonia to match WPF's former menu-only behavior.

## Evidence

- `tests/Free.Shared.Ribbon.Wpf.Tests/RibbonWpfSplitButtonTests.cs` verifies expanded primary/menu
  routing and collapsed-menu flattening.
- `dotnet test tests/Free.Shared.Ribbon.Wpf.Tests/Free.Shared.Ribbon.Wpf.Tests.csproj --configuration
  Release --logger "trx;LogFileName=shared-wpf-ribbon-wave82-rerun.trx"` passed: 2 tests.

## Residual

Cross-platform visual comparison of split-button chrome remains part of the broader ribbon visual lane.
