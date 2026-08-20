# Keytip menu tests: the menu opens, then is dismissed before the assertion

## Symptom

Five tests in `MainWindowRibbonKeyTipTests` fail, deterministically (5 of 68 on every run), each:

```
Expected boolean to be True because the ribbon keytip sequence W,Q should open a menu,
but found False.
```

`CrossTabMenuKeyTips_RouteThroughStaticRibbonMenus` (W,Q) ·
`DeclarativeHomeMenuChoices_AreEnabledAcrossFormattingFamilies` (H,B) ·
`PageLayoutSetupMenuKeyTips_UpdatePrintSettings` (P,O,R) ·
`FormulasAutoSumAndCalculationOptionKeyTips_InvokeMenuItems` (M,O) ·
`LegacyAltEditPasteSpecialKeyTip_ES_RoutesToPasteSpecialAndClosesKeyTips`

## What is proven

**The product code works.** Instrumenting `MainWindow.KeyTips.cs` shows the keytip route reaching
the menu and opening it:

```
TryEnterMenuKeyTipScope hasMenu=True items=41 withKeyTip=41
  afterSet IsOpen=True target=set visible=True items=10
```

Every menu item carries its keytip, the gate passes, and the menu is open and visible. The failure
is that it is **dismissed again before the assertion reads it** -- a WPF ContextMenu is dismissed
when its window stops being foreground, which a test runner frequently is not.

**Not caused by the local work.** Reverting both production changes made here -- the
`handledEventsToo` Enter subscription and the `PlanScalePercentCommit` semantics -- and rebuilding
still gives 5 of 68.

## Two earlier claims in this file were wrong

Recorded so nobody follows them:

1. *"Menu items lost their keytip metadata."* No -- 41 of 41 carry keytips.
2. *"This is a product regression."* No -- the product opens the menu correctly. What changed with
   the upstream merges is that dismissal went from intermittent to reliable, which made the tests
   fail every time instead of sometimes.

## Tried and rejected, with numbers

Baseline is 5 failures per run.

- **Asserting the menu *opened* (class handler on `ContextMenu.OpenedEvent`) instead of that it is
  still open.** 10, 11, 11, 10, 11 -- far worse, because sibling tests assert a menu is *closed*
  after Escape and that reading now returns true. The assertion cannot simply be relaxed.
- **`Topmost` on the window before the sequence.** Exactly unchanged.
- **Releasing `PlacementTarget` when closing menus in teardown.** Fixes the failing pair but breaks
  five other menus: 5 per run either way.
- See `FREEX-HOST-KEYTIP-TEST-INSTABILITY-2026-08-20.md` for four more, with numbers.

## What would actually fix it

The assertion needs to distinguish "this sequence opened this menu" from "a menu is open right now"
*without* breaking the Escape-closes-the-menu tests that share the harness -- for example by
recording which menu was opened by the sequence and asserting on that identity, rather than a global
"was any menu opened" flag or a live `IsOpen` read.

Alternatively, keep the window foreground for the duration of a sequence so the popup is not
dismissed. `Topmost` alone does not achieve that.
