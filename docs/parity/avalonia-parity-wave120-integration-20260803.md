# Avalonia/WPF Parity Wave 120 Integration

Date: 2026-08-03

## Accepted Slices

- FreeX Page Setup: separated visual capture from interaction-contract playback,
  aligned the Margins tab with WPF labels and geometry, and promoted fresh WPF
  and Ubuntu 24.04 Docker/Xvfb evidence for all five Page Setup surfaces.
- FreeW Mark Citation: moved both hosts onto shared dialog geometry and rhythm,
  aligned Avalonia's field layout and focus behavior, and refreshed route evidence.
- FreeP Reading Order: moved both hosts onto shared pane geometry, aligned the
  Avalonia action row and scrollbar ownership, and reduced the focused changed-
  pixel ratio from `17.1783%` to `13.2185%`.

## Evidence

- FreeX Page Setup: 5/5 WPF and Linux surfaces, all nonblank and `600x560`;
  focused mean-pixel differences `2.6155%` to `3.9686%`; generated triage scores
  `0.040` to `0.066`.
- FreeW Mark Citation: initial `4.5363%`, populated `4.8527%`, validation
  `4.6497%` changed pixels; all semantic checks passed.
- FreeP Reading Order: focused final changed pixels `13.2185%`, foreground
  changed pixels `22.2642%`, mean difference `11.7795`; geometry, focus,
  enabled-state, and nonblank checks passed.
- Generated FreeX dialog evidence: 94 WPF, 94 Avalonia, 94 paired, 0 missing,
  0 nonblank failures, and 0 expected-size mismatches.

## Focused Verification

- FreeX Presentation Page Setup planner/model/factory tests: 65 passed.
- FreeX WPF Page Setup dialog tests: 33 passed.
- FreeX Avalonia capture/source/interaction tests: 3 passed.
- FreeW Mark Citation planner/Avalonia/WPF tests and three-state captures passed.
- FreeP Reading Order focused tests: 5 passed; both affected projects built cleanly.
- Dialog evidence summary and cross-app dashboard generator checks passed.

## Integration Gates

- Repository preflight: passed after refreshing the FreeP whole-window manifest's
  two expected host source hashes.
- `dotnet build FreeX.slnx --configuration Release`: passed with 0 warnings and
  0 errors.
- Default solution: 36,186 total, 36,050 passed, 134 skipped, and 2 Windows
  clipboard tests failed during parallel project execution.
- The two clipboard tests passed 2/2 when rerun in isolation.
- The complete owning Host Logic assembly then passed serially: 1,498 passed,
  4 skipped, 0 failed. This confirms cross-project clipboard contention rather
  than a Wave120 product regression.
