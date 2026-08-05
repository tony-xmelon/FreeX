# Wave159: Avalonia Pivot field context-menu keytips

Date: 2026-08-05

## Gap proved

WPF authority is `MainWindow.ContextMenus.cs`: `AddPivotFieldContextMenuItem` applies each
`PivotFieldContextMenuCommand.KeyTip` through `RibbonTooltip.SetKeyTip(menuItem, command.KeyTip)`.
The paired authority test is
`MainWindowXamlKeyTipTests.PivotTableFieldListPane_ExposesFieldDropdownCommands`, which verifies
that the field-list planner exposes keytips for the sort, filter, and value-settings commands.

Before this slice, `AvaloniaPivotChartContextMenus.cs` built the same Pivot field-list commands and
dispatches, but its `AvaloniaPivotFieldContextMenu.BuildItems` initializer had no `InputGesture` or
other keytip presentation. The Avalonia context-menu test covered item counts and click dispatch only.

## Implemented

Avalonia now parses each planner keytip into the `MenuItem.InputGesture` used by the native menu
surface. `AvaloniaManagedContextMenu` resolves the matching bare key at the open context-menu root,
then raises the existing item click route even when another menu item owns focus. Available-fields and
bucket menus therefore expose and execute the same `S`, `O`, `I`, `L`, `F`, `C`, `V`, and bucket-only
`R` gestures as WPF, while retaining the existing click action dispatch. No window or worksheet key
binding is registered, so a bare `S` outside the open menu remains inert. Gesture activation closes the
menu, matching the normal leaf click lifecycle; Escape retains its existing close path.

## Evidence

- WPF authority: `MainWindowXamlKeyTipTests.PivotTableFieldListPane_ExposesFieldDropdownCommands`
- Avalonia pairing: `AvaloniaCatalogContextMenuTests.PivotField_UsesPlannerKeyTipsAsMenuGesturesForAvailableAndBucketItems`
- Avalonia production interaction: `AvaloniaCatalogContextMenuTests.PivotField_KeyTipInvokesPlannerActionOnlyInsideOpenContextMenu`

## Residuals

This slice covers Pivot field-list context-menu gesture presentation and the scoped bare-key route.
Pivot chart and waterfall context menus use separate planners and were not changed.
