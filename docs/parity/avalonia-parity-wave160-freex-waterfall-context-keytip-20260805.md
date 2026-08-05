# Avalonia Parity Wave 160: Waterfall context-menu keytip

Date: 2026-08-05

## Gap proved

WPF production is `MainWindow.WorksheetContextMenu.cs`: `OnWaterfallChartPointContextMenuRequested`
builds the shared waterfall menu, calls `MenuKeyTipAssigner.AssignUniqueKeyTips`, and opens the real
`ContextMenu`. The shared planner supplies `_Set as Total`, so WPF exposes `S` for the enabled item and
routes it through `ToggleWaterfallTotalPoint` and the undoable `SetWaterfallTotalPointCommand`.

Before this slice, Avalonia production was `MainWindow.PivotChartContextMenus.cs` plus
`AvaloniaPivotChartContextMenus.cs`: the point overlay attached a real context menu and dispatched clicks,
but the rendered item had no `InputGesture`. The shared `AvaloniaManagedContextMenu` therefore had no
waterfall keytip route to resolve, even though its generic menu-root keyboard handling already supported
the Pivot field-list slice from Wave159.

## Implemented

Avalonia now carries the planner access mnemonic into the waterfall `MenuItem.InputGesture`. The existing
`AvaloniaManagedContextMenu` resolves `S` only at the open context-menu root, invokes the enabled item,
and closes the menu. Disabled waterfall points do not match or dispatch; Escape still closes the menu; and
a bare `S` raised on the anchor outside an open menu remains unhandled.

## Evidence

- WPF production presence: `WaterfallChartContextMenuPlannerTests.MainWindowWaterfallContextMenu_RoutesThroughUndoableCommand`
  asserts the production event hookup, keytip assigner, and undoable command route.
- Avalonia functional interaction: `AvaloniaCatalogContextMenuTests.WaterfallPoint_KeyTipRoutesAtMenuRootAndHonorsEnablementAndEscape`
  focuses the production menu item, routes `S` through the menu root, checks close/dispatch behavior, checks
  disabled-point behavior, checks Escape, and checks no outside-menu bare-key handling.
- Existing paired planner test: `AvaloniaCatalogContextMenuTests.WaterfallPoint_RendersRegularTotalAndInvalidVariantsAndDispatches`
  confirms checked, enabled, disabled, and click state alongside the new gesture.

## Residuals

Pivot chart field-button menus still have WPF-assigned dynamic keytips but no Avalonia gesture presentation.
That is the next adjacent context-menu slice; this Wave160 change is limited to one waterfall menu-root route.
