# Ribbon Wave 88 Popup Focus Parity

## Slice

Collapsed-group popups now consume one shared interaction contract in both ribbon renderers:

- place the popup below its collapsed-group anchor;
- focus the first enabled, focusable command when the popup opens;
- traverse enabled top-level commands with Up/Down and Home/End, wrapping at the edge;
- dismiss on Escape; and
- return focus to the collapsed-group anchor when the popup closes.

The neutral `RibbonPopupInteractionPlanner` owns the focusable-item selection and traversal rules.
WPF maps the contract to `ContextMenu`/`MenuItem`; Avalonia maps it to `MenuFlyout`/`MenuItem`.
Wave 87's shared overflow projection remains unchanged: structural separators and row breaks are still
omitted.

## Proof

- `RibbonCollapsedGroupPresentationPlannerTests.PopupInteractionPlanner_SkipsDisabledAndNonFocusableItemsWithWraparound`
  proves the shared contract, first/last enabled selection, and wraparound traversal.
- `RibbonWpfSplitButtonTests.CollapsedGroupPopup_UsesPlacementAndEscapeDismissalContract`
  proves WPF bottom placement, anchor association, `StaysOpen=false`, disabled-item preservation, and
  Escape dismissal through the rendered `ContextMenu`.
- `AvaloniaRibbonSplitButtonTests.CollapsedGroupPopup_FocusesEnabledItemsTraversesAndRestoresAnchorOnEscape`
  proves Avalonia bottom placement, first-enabled focus, Up/Down traversal, Escape dismissal, and
  focus restoration to the collapsed anchor in the headless window.

Focused verification:

```text
dotnet test tests\Free.Shared.Ribbon.Tests\Free.Shared.Ribbon.Tests.csproj --configuration Release --filter "FullyQualifiedName~RibbonCollapsedGroupPresentationPlannerTests|FullyQualifiedName~AvaloniaRibbonSplitButtonTests.CollapsedGroupPopup_FocusesEnabledItemsTraversesAndRestoresAnchorOnEscape"
6 passed, 0 failed

dotnet test tests\Free.Shared.Ribbon.Wpf.Tests\Free.Shared.Ribbon.Wpf.Tests.csproj --configuration Release --filter "FullyQualifiedName~RibbonWpfSplitButtonTests"
13 passed, 0 failed
```

## Residual Toolkit Differences

WPF `ContextMenu` and Avalonia `MenuFlyout` retain toolkit-native popup chrome, shadow, animation,
screen-edge repositioning, and nested-submenu presentation. The WPF offscreen test harness cannot expose
the separate native popup focus scope reliably, so the WPF test proves the lifecycle and placement
contract while the shared planner and Avalonia headless test provide the focus/traversal proof. A
foreground WPF visual pass is still required for exact native chrome and real OS focus capture.
