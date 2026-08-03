# Avalonia parity Wave126 integration

Date: 2026-08-03

## Integrated slices

- FreeX deduplicated the Add Watch dialog contract around the shared planner, including dimensions, spacing, localization keys, automation ids, and the deterministic parity fixture. Fresh WPF and Linux captures now show the same `Sheet1!$B$2` value and visible `Selected range:` label.
- FreeW aligned Page Setup action-button chrome while preserving default and cancel behavior. All six current-source Page Setup states improved by the same 124 changed pixels; the initial-state difference moved from 10.0997% to 10.0628%.
- FreeP implemented renderer-neutral OMML wrapped-paragraph semantics for `m:wrapIndent` and `m:wrapRight`. The final implementation distinguishes wrapped paragraphs from authored equation arrays and correctly suppresses the defaults when `m:dispDef` is disabled or absent.

## Evidence

- Dialog inventory remains 57/57 routes, and visual evidence remains 94/94 paired WPF/Avalonia surface ids with no missing pairs, nonblank failures, scale-aware dimension mismatches, or stale expected-size rows.
- Refreshing the Add Watch pair reduced raw PNG dimension mismatches from 24 to 23. The highest FreeX visual triage score moved from 0.087879 to 0.086872; Add Watch is now 0.035756.
- The fresh Add Watch image difference is 2.1910253268%, down from the corrected 3.3677755991% baseline.
- The integrated Linux Add Watch capture ran in the exact container `freex-wave126-integration-addwatch-20260803` at 360x170 with `app_exit=0` and `capture_validated=true`; the harness removed the container after capture.
- FreeW Page Setup retained null semantic differences across all six paired states. Its current-source initial/populated/margins mean difference moved from 7.111137% to 7.056970%, validation from 7.227727% to 7.173561%, layout from 5.225907% to 5.171740%, and paper from 3.341367% to 3.287200%.

## Focused verification

- FreeX Add Watch shared planner tests: 2 passed; WPF Watch Window dialog tests: 15 passed.
- FreeW Page Setup Avalonia visual tests: 6 passed; WPF host tests: 4 passed; shared planner tests: 10 passed.
- FreeP wrapped-paragraph parsing/layout tests: 17 passed; WPF renderer test: 1 passed; Avalonia renderer test: 1 passed.
- Dialog visual summary and cross-app parity dashboard checks passed.

## Residuals

- `dialog.FormatCells.Alignment` is the next highest FreeX visual triage candidate at 0.086872.
- The visual manifest schema still lacks per-surface source provenance or content hashes, so current-source freshness remains a capture-process contract rather than a manifest-native assertion.
- FreeW Page Setup still has measurable platform typography and rasterization differences despite the accepted action-chrome improvement.
- FreeP wrapped-equation layout still needs PowerPoint-authoritative visual baselines for Office typography and spacing calibration.
