# Capture and dialog-contract tests fail only under the parallel gate

## Status

**RESOLVED.** `dotnet test FreeX.DefaultTests.slnx` is green: 31 assemblies, 41,373 tests,
0 failures, 0 aborted runs.

Six distinct causes, none of them the tests being "flaky":

1. **Lease starvation.** `AvaloniaCaptureProcessLease` allows 3 concurrent capture processes
   but waited only 75s, while a lease is held for a whole assembly run. All seven capture
   projects start together, so later ones queued behind two full runs and timed out, failing
   every test in ~50ms. Raised to 10 minutes.
2. **Session ceiling vs queueing.** `CaptureTests.runsettings` capped a test *session* at 90s,
   and that clock includes lease queueing. Assemblies were aborted mid-flight. Raised to 300s
   with the trade-off recorded in the file.
3. **Missing Skia.** The base `FreeX.App.Avalonia.CaptureTests` project was the only capture
   project without `Avalonia.Skia`, so its PNG-asserting test wrote nothing and the run hit
   the ceiling and aborted after 3 of 5 tests.
4. **Focus fallback too eager.** The harness focuses the first focusable control in any owned
   dialog with no focus yet. It ran on the first check, beating dialogs that pick a specific
   control, fail their first attempt and retry. Now skipped for one pass.
5. **Fixed probe budgets.** A 5s PowerShell probe, an 8s dialog-open wait and a 20s hang guard
   were each ample alone and too tight under load. All widened; each only bounds a pathological
   case, so none of them weakens what it guards.
6. **Tests that had never run.** Because of (2) and (3), Batch4 and the base project were
   aborted after one test. Fixing the aborts exposed two genuine defects that had never
   executed -- a Format Cells tab cycle and a drifted contract cohort list.

## Guidance that still holds

- A green main-assembly count says nothing about these tests: `FreeX.App.Avalonia.Tests.csproj`
  carries a `VSTestTestCaseFilter` excluding 34 capture/contract tests, which run only via the
  Batch projects. All 34 are selected by some batch filter, so coverage is complete.
- If one of these fails again, re-run the single test against its own project before believing
  it -- but the parallel-run failures documented below are now fixed, not merely characterised.

## Original investigation

## Symptom

`dotnet test FreeX.DefaultTests.slnx` reports a handful of failures that **cannot be
reproduced individually**. Every one of them passes when run with `--filter` against its own
project.

## Evidence it is parallelism, not the tests

Two consecutive gate runs on the same commit produced *different* failure sets:

| Test | Run 1 | Run 2 |
|---|---|---|
| `FreeP … SlideShowWindow_presenter_session_summary…` | fail | fail |
| `CaptureParitySurfaces_CapturesChartStyleCatalogDialog` | fail | fail |
| `TextToColumnsDialogContract_PassesInitialFocusTabCycleAndEscape` | fail | fail |
| `WatchWindowDialog_MatchesWpfFocusTabAndEscapeLifecycle` | fail | fail |
| `R51_MergedCellSelectionNavTests.ArrowKey_OnTallMergedCell_MovesPastFarEdge` | fail | **pass** |
| `TargetedGoalSeekStatusCapture_WritesNonBlank380x190Png` | **pass** | fail |

A set that changes between identical runs is scheduling, not logic.

Checked on `origin/main` (worktree, no local commits): `WatchWindowDialog`,
`TextToColumnsDialogContract` and `CaptureParitySurfaces_CapturesChartStyleCatalogDialog`
all pass individually there too, so this predates the 2026-08-18 capture work.

## Actual cause (found, fixed in `47b7247747`)

`AvaloniaCaptureProcessLease` allows **3** concurrent capture processes via file locks, but
waited only **75 seconds** to acquire one. A lease is held for an entire assembly run, and a
capture assembly can take well over a minute. The gate starts every
`CaptureTests.Batch*` assembly at once, so the later ones queue behind two full runs and
time out:

```
System.TimeoutException : Could not acquire one of 3 Avalonia capture process slots
within 75 seconds.
```

Timed-out assemblies fail every test in ~50ms, which is what produced a scatter of
apparently-unrelated capture and dialog-contract failures. Raised to 10 minutes.

Separately, `FreeX.App.Avalonia.CaptureTests` (the base project) was the only capture
project without `Avalonia.Skia`, so its PNG-asserting test wrote nothing, the run hit the
90s ceiling in `CaptureTests.runsettings` and **aborted after 3 of 5 tests**. With Skia it
completes all five in 26s.

Gate failures went from 23 to 4.

## Original hypothesis

Each `FreeX.App.Avalonia.CaptureTests.Batch*` assembly stands up its own Avalonia headless
session, and the gate runs assemblies in parallel. These tests drive real windows, focus and
render targets, which are process- and timing-sensitive. Several also write PNGs under
`%TEMP%`.

## Practical guidance

- A gate failure in one of these tests is not by itself evidence of a defect. Re-run the
  single test against its own project before believing it.
- Conversely, a green gate does not prove they passed — see the `VSTestTestCaseFilter` in
  `FreeX.App.Avalonia.Tests.csproj`, which excludes 35 capture/contract tests from the main
  assembly entirely; they run only via the Batch projects.

## Worth fixing properly

Either serialise the capture assemblies in the gate (an xunit assembly-level parallelism
setting, or a test-run ordering constraint), or give each assembly its own isolated
temp root. Until then the gate has a persistent false-failure rate on these few tests.
