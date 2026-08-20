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

| Harness | Failures across consecutive runs |
|---|---|
| Shared window (original) | 1, 7, 2 -- never clean |
| + close every leaked popup in teardown | 1, 1, 0 |
| + per-test window, retiring the previous one | 0, 1, 0, 1 / 1, 1, 1, 0 |

Clean runs happen regularly now and never did before, but one test still fails intermittently --
usually `DeclarativeHomeMenuChoices_AreEnabledAcrossFormattingFamilies` or
`PageLayoutSetupMenuKeyTips_UpdatePrintSettings`, both of which open a menu and pass on their own.

## Tried and rejected, with numbers

- **Cancelling the keytip session in teardown** (`KeyTipSession.Cancel()`): 1, 2, 1, 2 against
  1, 1, 0 without. No help.
- **Closing each test's own window in `Dispose`**: 64 failures of 68, identically three runs
  running. WPF's default `OnLastWindowClose` shuts the Application down with the last window. The
  perfect repeatability is what proved shared window state was the variable.
- **Widening the menu-open poll from 5s to 20s**: 0, 1, 0, 1 -- unchanged, so the menu genuinely
  never opens rather than opening late.
- **Hiding the retired window instead of closing it**: 3, 1, 1, 2 -- worse.

## What remains

One or two tests still fail intermittently, most often
`DeclarativeHomeMenuChoices_AreEnabledAcrossFormattingFamilies`, which passes on its own. So some
state still crosses tests -- just much less of it.

**Tried and rejected:** cancelling the keytip session in teardown
(`KeyTipSession.Cancel()`), on the theory that a test ending mid-sequence leaves a nested scope
behind. Four runs with it gave 1, 2, 1, 2 failures against 1, 1, 0 without, so it does not help and
was not kept.

The remaining leak is most likely keyboard focus or selection state on the shared window rather than
a popup.

**Per-test window isolation was tried and confirms the diagnosis, but is not a drop-in change.**
Building a fresh session in `Create` and closing the window in `Dispose` gives **64 failures out of
68, identically on three consecutive runs** -- the nondeterminism disappears completely, which is
the proof that shared window state is what varies. But the tests are written against a window that
persists: they rely on setup and ribbon state established outside their own body, so isolating them
requires rewriting the tests, not just the harness. Reverted.

So the choice is explicit: keep the shared window and accept 1-2 intermittents, or rework the class
to stand alone. The second is the real fix and is a piece of work in its own right.

## Why this matters beyond the tests

`FreeX.App.Host.Tests` is not in `FreeX.DefaultTests.slnx`, so this instability is invisible to the
gate. See `FREEX-HOST-TESTS-OUTSIDE-THE-GATE-2026-08-19.md`.
