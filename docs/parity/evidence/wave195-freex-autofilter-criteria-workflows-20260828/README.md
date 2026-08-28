# Wave195 FreeX AutoFilter Criteria Workflows

This directory is a canonical evidence bundle for two retained production Linux Avalonia Docker/X11 sessions. The sessions were not rerun for packaging.

## Sessions

- `multi-column/`: session `20260828T135519236Z`, selector `autofilter-multi-column-persistence`, runner report `20260828T135447Z`.
- `color-change-clear/`: session `20260828T140101266Z`, selector `autofilter-color-change-clear-persistence`, runner report `20260828T140028Z`.

Each session preserves its complete `x11-validation` directory, including the X11 manifest, calibration/readiness artifacts, rendered menu screenshots, applied/changed/cleared screenshots, reload-witness screenshots, reopen diagnostics, and exact postcondition text. Each `run-report` directory preserves the runner report and resume provenance.

## Claim Boundary

The evidence supports bounded physical Linux X11 input through the production FreeX Avalonia application for the named XLSX fixtures. It supports the rendered filter-menu sequences, visible-row outcomes, serialized package transitions, dirty-state discard, and post-reopen reload witness recorded in the postconditions.

It does not claim exhaustive dashboard coverage, WPF execution, cross-application parity, untested filter types, or behavior outside the named fixtures and retained sessions. The later clipboard-consumer cleanup commit was not part of these captures and is not claimed as physically exercised here.

Hash policy and the complete file inventory are in `manifest.json`. `hash-audit.txt` is the generated verification output for every file hash recorded by that manifest.
