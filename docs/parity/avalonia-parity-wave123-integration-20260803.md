# Wave123 Avalonia parity integration

## Integrated slices

- FreeX Text to Columns: shared capture fixture and production dialog geometry,
  with fresh same-size WPF/Avalonia evidence at `1.8922%` differing pixels.
- FreeW Backstage Info: shared labels/statistics, accessible WPF action names,
  no semantic difference, and visual delta reduced to `6.9732%`.
- FreeP OMML limits: document-level `m:intLim` and `m:naryLim` now flow
  through the package model and immutable shared parser context to both hosts.

## Repository evidence

The regenerated dialog evidence summary reports 94 WPF captures, 94 Avalonia
captures, 94 paired surface IDs, no unpaired surfaces, no blank PNGs, and no
expected-size mismatches. The cross-app dashboard regenerated without content
changes.

## Focused verification

- FreeX Text to Columns presentation tests: 128/128 passed.
- FreeX WPF and Avalonia production host Release builds: passed with no
  warnings or errors.
- FreeW presentation, WPF host, and Avalonia Backstage tests: 20/20, 25/25,
  and 40/40 passed; Linux Docker File -> Info smoke passed.
- FreeP focused parser/package/layout tests: 182/182 passed; paired WPF and
  Avalonia tests: 3/3 each; `FreeP.slnx` Release build passed.

## Integration gates

- Repository preflight: passed.
- `FreeX.slnx` Release build: passed with 0 warnings and 0 errors.
- Default non-UI lane: the corrected 2,013-test Avalonia project passed. Two
  unrelated OS-clipboard tests failed only in the parallel solution run and
  each passed immediately when rerun serially in isolation.
- UI lane: timed out after 10 minutes. `FreeX.App.UI.Tests` recorded 1,039
  passes and six unrelated existing source-guard/performance expectation
  failures; the WPF host UI project had not completed. Only the three exact
  Wave123-owned test PIDs left by the timeout were terminated.
