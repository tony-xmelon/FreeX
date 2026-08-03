# Avalonia parity Wave124 integration

Date: 2026-08-03

## Integrated slices

- FreeX refreshed `dialog.TextToColumns` canonical WPF and Avalonia evidence from current source at 560x560. This removes the stale 500x430 promoted evidence from the dashboard.
- FreeX moved Goal Seek Status geometry into `GoalSeekStatusDialogPlanner` and aligned Avalonia spacing, line rhythm, and compact neutral button chrome with the WPF authority.
- FreeW moved Restrict Editing presentation details into one shared plan consumed by both hosts. All three captured states now have matching action/default semantics and a 4 px content-height difference instead of 198 px.
- FreeP added document-level OMML `m:dispDef` propagation. Absent/off disables document `m:defJc`; val-less/on enables it; paragraph-local `m:jc` remains authoritative.

## Evidence

- Dialog inventory: 57/57 routes have WPF capture evidence, Avalonia capture evidence, an Avalonia harness route, and shared/presentation backing.
- Visual evidence: 94/94 surface ids are paired; there are no missing pairs, nonblank failures, expected-size mismatches, or stale promoted expected-size artifacts.
- Text to Columns: both canonical captures are 560x560 at approximately 96 DPI; current-source triage score is 0.031756.
- Restrict Editing: changed-pixel ratios are 5.88%-5.92%; semantic differences are none; Avalonia/WPF content heights differ by 4 px.
- Highest remaining dialog triage score is 0.088677, below the 0.4 review-prioritization threshold.

## Verification

- FreeP OMML presentation tests: 230 passed.
- FreeP WPF OMML parity tests: 4 passed.
- FreeP Avalonia OMML parity tests: 4 passed.
- FreeX Goal Seek planner/source/WPF focused tests: 81 passed in the worker branch; Avalonia Release build passed with zero warnings/errors.
- FreeW Restrict Editing planner/source focused tests: 24 passed in the worker branch; WPF host Release build passed with zero warnings/errors.
- Canonical dialog visual summary regenerated successfully: 94 paired surfaces, zero stale promoted evidence.
- Cross-app parity dashboard regenerated successfully.
- Repository preflight passed, including generated-document freshness, project/solution integrity, Linux packaging, and conflict-marker checks.
- `dotnet build FreeX.slnx --configuration Release` passed with 0 warnings and 0 errors.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"` passed across every project. Reported skips are the repository's intentional benchmark/corpus skips.

## Residuals

- The Linux targeted Goal Seek capture command twice exited the app without producing evidence and left only `xvfb-run`/Xvfb waiting. The exact named container was removed each time; no empty or synthetic capture was promoted. Existing canonical 380x190 evidence remains the visual baseline until the targeted harness route is repaired.
- FreeP OMML document margins and wrapping defaults remain separate future slices.
