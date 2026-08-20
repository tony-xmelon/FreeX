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

## What remains

One or two tests still fail intermittently, most often
`DeclarativeHomeMenuChoices_AreEnabledAcrossFormattingFamilies`, which passes on its own. So some
state still crosses tests -- just much less of it.

**Tried and rejected:** cancelling the keytip session in teardown
(`KeyTipSession.Cancel()`), on the theory that a test ending mid-sequence leaves a nested scope
behind. Four runs with it gave 1, 2, 1, 2 failures against 1, 1, 0 without, so it does not help and
was not kept.

The remaining leak is most likely keyboard focus or selection state on the shared window rather than
a popup. The decisive next step is to give each test its own `MainWindow` instead of sharing one --
slower, but it removes the whole class of problem rather than chasing individual leaks.

## Why this matters beyond the tests

`FreeX.App.Host.Tests` is not in `FreeX.DefaultTests.slnx`, so this instability is invisible to the
gate. See `FREEX-HOST-TESTS-OUTSIDE-THE-GATE-2026-08-19.md`.
