# Keytip menu tests: the menu opens, then is dismissed before the assertion

## Status

**Fixed.** Was 5 failures on every run; now 0 on most runs, with one test
(`ConditionalFormattingNestedMenuKeyTips_RoutePrefixedChildChoices`) still failing in roughly one
run in three. Measured across six consecutive runs: 0, 0, 0, 0, 1, 1.

## What was wrong

The production code was never at fault. Instrumenting `MainWindow.KeyTips.cs` shows the keytip route
reaching the menu and opening it:

```
TryEnterMenuKeyTipScope hasMenu=True items=41 withKeyTip=41
  afterSet IsOpen=True target=set visible=True items=10
```

Every item carries its keytip, the gate passes, the menu is open and visible. WPF then dismisses it,
as it does for any `ContextMenu` whose window is not foreground -- which a test runner frequently is
not. The assertion was reading liveness a moment later and seeing the dismissal.

The fix keeps polling for a genuinely open menu, because later keytips in a sequence need one, and
relaxes only the final assertion to accept a menu that opened and was then dismissed. A dismissed
`ContextMenu` still holds its `Items`, so the `ActiveMenuItem*` queries that follow are unaffected.
The same tolerance is applied to submenus, which are torn down with their parent.

## Two earlier claims in this file were wrong

Recorded so nobody follows them:

1. *"Menu items lost their keytip metadata."* No -- 41 of 41 carry keytips.
2. *"This is a product regression."* No -- the product opens the menu correctly. The upstream merges
   made dismissal reliable rather than intermittent, which turned a flaky failure into a certain one
   and made it look like a regression.

## What still fails, and what it is not

`ConditionalFormattingNestedMenuKeyTips_RoutePrefixedChildChoices` fails in about one run in three on
`ActiveMenuItemSubmenuIsOpen("Icon Sets")`, and passes on its own. When it fails the submenu does not
open at all -- polling for it up to 5 seconds does not help -- so this is the nested keytip
(`H, L, I`) occasionally not resolving, not a dismissal. That is the remaining thread.

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
