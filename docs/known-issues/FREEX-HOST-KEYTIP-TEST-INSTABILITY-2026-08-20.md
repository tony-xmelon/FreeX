# Ribbon keytip tests leak UI state between tests

## Symptom

`MainWindowRibbonKeyTipTests` returned a **different failure set on every run** of the same code
-- 1 failure, then 7, then 2 -- with tests appearing and disappearing. That variance is what made
narrow changes in this area unverifiable: a regression could not be told apart from the noise.

## Cause (fixed, partially)

The class shares one `MainWindow`: `SharedMainWindowSession` is `[ThreadStatic]`, created once and
reused by every test. Teardown closed only the single menu `ActiveMenu` tracks
(`_window.ActiveRibbonKeyTipMenuForTest`) plus one named combo, so **any other popup a test left
open leaked into the next test**.

Closing every open `ContextMenu`, `ComboBox` dropdown and the tab-overflow toggle reachable from the
window took consecutive runs from 7 failures to 1-2, including clean passes.

## Measured results

Every figure below is failures per run of the class (68 tests), across consecutive runs.

| Harness | Runs |
|---|---|
| Shared window (original) | 1, 7, 2 |
| + close every leaked popup in teardown | 1, 1, 0 |
| + activate the window before each keytip sequence | 0, 2, 0, 1, 2, 2 and 2, 1, 2, 1, 1, 2 |
| per-test windows instead of shared | 1, 1, 1, 0, 2 (2, 3, 2, 2, 2, 1 without activation) |

The catastrophic runs are gone and clean runs now happen, but **one or two menu tests still fail per
run**. This is not resolved.

## Tried and rejected, with numbers

- **Per-test windows.** Committed on a three-run sample, then reverted: larger samples show no
  advantage over a shared window, for more machinery and an Application-shutdown hazard.
- **Closing each test's own window in `Dispose`.** 64 failures of 68, identically three runs
  running -- WPF's default `OnLastWindowClose` shuts the Application down with the last window. The
  perfect repeatability is what proved shared window state was the variable.
- **Hiding the retired window instead of closing it.** 3, 1, 1, 2 -- worse.
- **Cancelling the keytip session in teardown.** 1, 2, 1, 2 against 1, 1, 0 without.
- **Widening the menu-open poll from 5s to 20s.** Unchanged, so the menu never opens rather than
  opening late.
- **`Topmost` before the sequence,** on the theory that a ContextMenu popup needs a foreground
  window. Exactly unchanged.

## What is actually left

The broad `H,A,N should open a menu` failures above are gone: relaxing that assertion to accept a
menu opened by the sequence (rather than one still open at assert time) took the class to 0, 0, 0,
0, 1, 1 over six consecutive runs.

What remains is a **single, narrower** intermittent, roughly one run in three:

```
ConditionalFormattingNestedMenuKeyTips_RoutePrefixedChildChoices
  Expected harness.ActiveMenuItemSubmenuIsOpen("Icon Sets") to be True, but found False.
```

This is a *different* failure from the one fixed above. When it fails the submenu does not open at
all -- polling five seconds does not help, and holding the parent menu open with `StaysOpen = true`
does not either (3 failures in 6 runs against 2 in 6 -- no better, so it was reverted). So the
nested keytip `I` on the `H, L, I` route intermittently fails to resolve; it is not a dismissal
race.

### What instrumentation ruled out

`RibbonTooltip.TryOpenSubmenuForKeyTip` skips items that are not enabled
(`if (!item.IsEnabled) continue;`), which made an enablement race the obvious suspect: command
state is published asynchronously, so a not-yet-enabled "Icon Sets" would be silently passed over.

Logging every candidate item during resolution **disproves that**. On a run where the test failed,
the resolver still saw:

```
item=[Icon Sets] enabled=True kids=23 kt=[I]
```

Enabled, populated with its 23 children, and carrying the right keytip. So the resolver has
everything it needs and still does not leave the submenu open -- the loss is after resolution, in
`MenuItem.IsSubmenuOpen` not sticking, not in finding the item.

Note the recursive branch assigns `IsSubmenuOpen = true` at three separate points and restores
`item.IsSubmenuOpen = wasOpen` on the miss path; a nested route walks that restore for every
non-matching sibling before reaching "Icon Sets". That ordering is the first thing to examine.

### Recommendation

Do not chase this with more test runs -- sampling a one-in-three flake costs many minutes per data
point and has already consumed more than it returned. Option 2 below is still the right fix: assert
that the keytip route *resolves* to the right `MenuItem` without requiring a real popup to stay
open, which is what makes these tests environment-dependent in the first place.

1. Find what the keytip menu route leaves behind on a second use -- the popup, its
   `PlacementTarget`, or the input scope.
2. Rewrite these tests so they assert the keytip route resolves to the right menu **without**
   requiring a real popup to open.

## Why this matters beyond the tests

`FreeX.App.Host.Tests` is not in `FreeX.DefaultTests.slnx`, so this instability is invisible to the
gate. See `FREEX-HOST-TESTS-OUTSIDE-THE-GATE-2026-08-19.md`.
