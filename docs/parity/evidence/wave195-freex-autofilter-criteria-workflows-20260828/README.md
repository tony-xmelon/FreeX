# Wave195 FreeX AutoFilter Criteria Workflows

This directory is a canonical evidence bundle for two retained production Linux Avalonia Docker/X11 sessions. The sessions were not rerun for packaging.

The raw runner reports are preserved unchanged. Their `sourceCommit` value, `c8609b78c4a0483e65f55a8eb3da1b61893e86ec`, identifies the app/payload source recorded by the runner. The strengthened reload-witness probe and runner state used for the captures is pinned separately to capture-equivalent commit `686788f0b5c6d8e5eb7c00fade87cdb9666567e0`; the exact probe and runner Git blob IDs are recorded in `manifest.json`. The later clipboard-consumer cleanup commit `9237dec9b1461b2f0cb78c7c631b6121bcd9506a` was after capture and was not physically exercised. `packagingBaseCommit` records the pre-correction evidence commit `af4b6ee52ff5bbda746bf0597c89bd5a7fcf4649`.

## Sessions

- `multi-column/`: session `20260828T135519236Z`, selector `autofilter-multi-column-persistence`, runner report `20260828T135447Z`.
- `color-change-clear/`: session `20260828T140101266Z`, selector `autofilter-color-change-clear-persistence`, runner report `20260828T140028Z`.

Each session preserves its complete `x11-validation` directory, including the X11 manifest, calibration/readiness artifacts, rendered menu screenshots, applied/changed/cleared screenshots, reload-witness screenshots, reopen diagnostics, and exact postcondition text. Each `run-report` directory preserves the runner report and resume provenance.

## Claim Boundary

The evidence supports bounded physical Linux X11 input through the production FreeX Avalonia application for the named XLSX fixtures. It supports the rendered filter-menu sequences, visible-row outcomes, serialized package transitions, dirty-state discard, and post-reopen reload witness recorded in the postconditions.

It does not claim exhaustive dashboard coverage, WPF execution, cross-application parity, untested filter types, or behavior outside the named fixtures and retained sessions. The later clipboard-consumer cleanup commit was not part of these captures and is not claimed as physically exercised here.

Hash policy and the complete file inventory are in `manifest.json`. `hash-audit.txt` is the generated verification output for every file hash recorded by that manifest.
