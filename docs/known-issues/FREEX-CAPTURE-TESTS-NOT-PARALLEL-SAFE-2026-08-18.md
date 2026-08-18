# Capture and dialog-contract tests fail only under the parallel gate

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

## Likely cause

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
