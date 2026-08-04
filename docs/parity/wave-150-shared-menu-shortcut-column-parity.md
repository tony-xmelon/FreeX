# Wave 150: Shared Menu Shortcut Column Parity

## Gap

`RibbonMenuItem.InputGesture` was shown by the WPF ribbon context-menu renderer, but the shared
Avalonia context-menu adapter discarded it. Worksheet, document, and dialog context menus could
therefore expose the same command without exposing its keyboard shortcut in Avalonia.

## Behavior

`RibbonMenuItemPresentationPlanner` now resolves the neutral header, shortcut text, and key tip.
The WPF renderer assigns the planned shortcut text to `MenuItem.InputGestureText`. The Avalonia
context-menu adapter and ribbon flyout renderer parse the same planned text into Avalonia's native
`KeyGesture`. Invalid or empty gesture text remains non-fatal and produces no native gesture.

This change covers shortcut presentation and parsing only. Native popup focus traversal, key-tip
activation, and platform-specific shortcut execution remain owned by WPF and Avalonia controls.

## Verification

- `dotnet test tests/Free.Shared.Ribbon.Tests/Free.Shared.Ribbon.Tests.csproj --configuration Release --filter FullyQualifiedName~RibbonMenuItemPresentationPlannerTests`: 3 passed.
- `dotnet test tests/Free.Shared.Ribbon.Wpf.Tests/Free.Shared.Ribbon.Wpf.Tests.csproj --configuration Release --filter FullyQualifiedName~DropdownMenu_RendersNeutralInputGestureInShortcutColumn`: 1 passed.
- Full `Free.Shared.Ribbon.Tests`: 735 passed.
- Full `Free.Shared.Ribbon.Wpf.Tests`: 17 passed, with one unrelated focus assertion failing in `DropdownPopup_NestedMenuUsesSharedChromeAndRightLeftNavigation` (`parent.IsKeyboardFocusWithin` false at line 304); the focused new WPF test passed. Re-running with that test excluded produced 17/17 passes.
