# Ribbon keytip sequences no longer open menus

## Symptom

Five tests in `MainWindowRibbonKeyTipTests` fail, every run, each the same shape:

```
Expected boolean to be True because the ribbon keytip sequence W,Q should open a menu,
but found False.
```

- `CrossTabMenuKeyTips_RouteThroughStaticRibbonMenus` (W,Q)
- `DeclarativeHomeMenuChoices_AreEnabledAcrossFormattingFamilies` (H,B)
- `PageLayoutSetupMenuKeyTips_UpdatePrintSettings` (P,O,R)
- `FormulasAutoSumAndCalculationOptionKeyTips_InvokeMenuItems` (M,O)
- `LegacyAltEditPasteSpecialKeyTip_ES_RoutesToPasteSpecialAndClosesKeyTips`

## This is a product regression, not test flakiness

Earlier in the day these tests were **intermittent** (0-2 failures per run, varying which). They are
now **deterministic**: 5 failures on five consecutive runs, and each fails when run *on its own*.
Something changed between those measurements, and it was not the test harness.

**Not caused by the local work.** Reverting both production changes made here -- the
`handledEventsToo` Enter subscription in `MainWindow.RibbonDeclarative.cs` and the
`PlanScalePercentCommit` semantics -- and rebuilding still gives 5 failures of 68. The regression
arrived with upstream commits merged in between.

## Where to look

`MainWindow.KeyTips.cs`'s `TryEnterMenuKeyTipScope` declines before opening anything when no menu
item carries a keytip:

```csharp
if (!GetMenuItems(menu).Any(item => !string.IsNullOrWhiteSpace(RibbonTooltip.GetKeyTip(item))))
    return false;
```

So a plausible cause is that menu items stopped carrying their keytip metadata, rather than the
opening itself breaking. Recent upstream work in this area includes the ribbon metadata unification
and the shared ribbon-state publishers (`Share FreeX home format / worksheet view / page layout
scale / sheet options ribbon state`, `refactor(freex): unify ribbon metadata ownership`). Confirm by
checking whether `RibbonTooltip.GetKeyTip` still returns a value for those menu items, before
looking at the popup path.

## Note on the earlier instability

The intermittency this file previously described is documented separately in
`FREEX-HOST-KEYTIP-TEST-INSTABILITY-2026-08-20.md`, along with six rejected fixes and their
numbers. That work stands, but it is now masked: while the menus do not open at all, the residual
flakiness cannot be measured.
