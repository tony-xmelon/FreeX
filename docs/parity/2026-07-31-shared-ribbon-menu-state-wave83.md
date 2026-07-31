# Shared ribbon dropdown menu state parity: Wave 83

## Divergence

The WPF ribbon renderer preserved `RibbonMenuItem.IsEnabled` and nullable `IsChecked` when it
created split/dropdown menu items. The Avalonia ribbon renderer did not: authored-disabled submenu
parents were left enabled, and checkable menu items were rendered as ordinary unchecked items. This
made keyboard key-tip navigation able to enter a disabled submenu on Avalonia and lost menu toggle
state relative to WPF.

## Fix

`AvaloniaRibbonRenderer.BuildMenuItem` now carries authored enablement and check state into the
native `MenuItem`. Registry command state remains an additional enablement gate for invokable leaf
items, while an authored-disabled item cannot be re-enabled by registry presence. The same path is
used by expanded dropdowns, split-button menus, and collapsed-group overflow menus.

## Evidence

- `tests/Free.Shared.Ribbon.Tests/AvaloniaRibbonMenuStateTests.cs` verifies that a disabled parent
  rejects the `HM` then `HMD` keyboard route and that a checked item remains checkable and checked.
- `tests/Free.Shared.Ribbon.Wpf.Tests/RibbonWpfSplitButtonTests.cs` verifies the matching WPF
  disabled-parent and checked-item state.
- `dotnet test tests/Free.Shared.Ribbon.Tests/Free.Shared.Ribbon.Tests.csproj --configuration
  Release --filter FullyQualifiedName~AvaloniaRibbonMenuStateTests` passed: 1 test.
- `dotnet test tests/Free.Shared.Ribbon.Wpf.Tests/Free.Shared.Ribbon.Wpf.Tests.csproj
  --configuration Release --filter FullyQualifiedName~RibbonWpfSplitButtonTests` passed: 3 tests.

## Remaining nearby gaps

Native visual comparison of WPF context-menu dismissal and Avalonia menu-flyout focus restoration
remains in the broader ribbon UI lane. This slice addresses authored menu state and keyboard
reachability only.
