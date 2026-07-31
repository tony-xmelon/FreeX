# Avalonia parity wave 82 integration - 2026-07-31

## Integrated slices

- FreeX row and column header selection expands through merged cells using the shared `MergedSelectionRangePlanner` in both hosts.
- FreeW Notes pane toggling uses the shared `FreeWStatefulToggleCommand`; WPF and Avalonia expose the same live checked state.
- FreeP Edit Points mode uses shared planning and remains active across WPF editing-session rebinds, matching Avalonia.
- Shared WPF ribbon split buttons separate primary execution from dropdown opening and preserve primary commands in collapsed groups.
- The shared WPF ribbon tests live in the focused ribbon UI lane, not the default non-UI lane.
- The FreeP Linux Animation Pane probe follows the current rendered command position and again proves open, row selection, close, and reopen behavior.

## Verification

- Repository preflight passed across 124 projects, 89 main-solution entries, and 20 default-test entries.
- `dotnet build FreeX.slnx --configuration Release` passed with 0 warnings and 0 errors.
- Focused slice tests passed 60/60 before the final upstream sync.
- The final ribbon UI lane passed 27/27, including 2 shared WPF split-button tests.
- Linux physical interaction evidence passed: FreeX 24/24, FreeW 37/37, and FreeP 24/24.
- The final default lane reported 34,540 passed, 29 failed, and 133 skipped. The failures are the existing current-host WPF off-screen bitmap cluster: 26 FreeX print/render assertions and 3 FreeP host-rendering assertions. Avalonia and non-renderer projects passed.

## Residual status

Wave 82 closes these bounded parity slices. The overall Avalonia-to-WPF parity goal remains active; subsequent waves should continue selecting verified residual functional gaps from the generated cross-app evidence rather than treating this integration wave as overall completion.
