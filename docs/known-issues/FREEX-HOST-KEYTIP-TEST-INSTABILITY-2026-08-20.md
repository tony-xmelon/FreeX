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

The failures are always the same shape -- `sequence H,A,N should open a menu, but found False` --
and always on menu-opening tests: `DeclarativeHomeMenuChoices_AreEnabledAcrossFormattingFamilies`,
`PageLayoutSetupMenuKeyTips_UpdatePrintSettings`, `CrossTabMenuKeyTips_RouteThroughStaticRibbonMenus`.

Each passes alone. Run as a **pair**, both fail. So it is not "the previous test breaks the next
one", and it is not window count or foreground -- a shared window with forced activation behaves the
same. Something about opening a ribbon menu through the keytip route does not survive being done
more than once per process.

Two ways forward, neither a harness tweak:

1. Find what the keytip menu route leaves behind on a second use -- the popup, its
   `PlacementTarget`, or the input scope.
2. Rewrite these tests so they assert the keytip route resolves to the right menu **without**
   requiring a real popup to open, which is what makes them environment-dependent.

## Why this matters beyond the tests

`FreeX.App.Host.Tests` is not in `FreeX.DefaultTests.slnx`, so this instability is invisible to the
gate. See `FREEX-HOST-TESTS-OUTSIDE-THE-GATE-2026-08-19.md`.
