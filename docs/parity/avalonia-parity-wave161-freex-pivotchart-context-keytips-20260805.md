# Avalonia Parity Wave 161: PivotChart field-button context keytips

Date: 2026-08-05

## Gap proved

WPF production is `MainWindow.PivotChartCommands.cs`: every PivotChart field-button and pivot-header
context menu is built from `PivotChartFieldContextMenuPlanner.BuildCommands`, then the real WPF
`ContextMenu` calls `MenuKeyTipAssigner.AssignUniqueKeyTips` over the emitted `MenuItem`s. The assigner
derives unique typeable keytips from the live headers, including disabled summary and unavailable-action
items, so dynamic filter labels remain routable without hand-authored labels.

Before this slice, Avalonia used the same planner and action dispatch in
`AvaloniaPivotChartContextMenus.cs`, but did not assign `MenuItem.InputGesture` for the PivotChart field
menu. The managed context-menu root therefore could not present or route the WPF-assigned gestures.

## Implemented

Avalonia now derives unique PivotChart field-menu gestures from the planner headers with the shared
`RibbonKeyTipText` assignment algorithm. This applies to filtered, no-filter, value-field-settings, and
the shared pivot-header entry variants. `AvaloniaManagedContextMenu` also ignores key events while closed,
while preserving menu-root dispatch, disabled-item inertness, Escape close, and no key handling on the
anchor outside an open menu.

## Evidence

- `Wave161AvaloniaPivotChartContextMenuKeyTipParityTests.WpfAuthority_BuildsPivotChartMenuFromPlannerAndAssignsUniqueKeyTips`
  pins the WPF planner and dynamic assigner contract.
- `Wave161AvaloniaPivotChartContextMenuKeyTipParityTests.PivotChartFieldMenu_PresentsWpfAssignedGesturesForEveryPlannerVariant`
  compares all applicable planner variants, headers, enablement, and unique derived gestures.
- `Wave161AvaloniaPivotChartContextMenuKeyTipParityTests.PivotChartFieldMenu_RoutesAtOpenMenuRootAndHonorsDisabledEscapeAndScope`
  proves production menu-root routing, disabled-key behavior, Escape, close-state guarding, and no
  outside-menu key leakage.

## Verification

- Focused Wave161 class: **3 passed, 0 failed, 0 skipped**.
- The focused run used the generated Release test assembly with `--no-build --no-restore`.
- The synchronized integration branch reran the strengthened routed-event class from a clean Release
  build: **3 passed, 0 failed, 0 skipped**.
- The Linux Docker production context-menu catalog reported **19/19 PivotChart rows passed** across the
  filtered and no-filter variants, including the family aggregate. The all-context run emitted 13,958
  result rows; its 54 failures belong to the pre-existing Worksheet Show Notes and AutoFilter criteria
  clusters, not PivotChart.
- `git diff --check`: passed.

## Residuals

Native desktop keyboard delivery and pixel-level comparison of Avalonia gesture text remain outside this
slice: the Linux production run dispatches the real menu actions but does not inject the assigned letters
through X11. The underlying WPF and Avalonia menu item order, dynamic headers, enablement, gesture tokens,
routed menu-root handling, and Linux production action routes are covered here.
