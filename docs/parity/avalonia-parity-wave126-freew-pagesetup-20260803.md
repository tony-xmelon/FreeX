# FreeW Page Setup visual parity, Wave 126

Date: 2026-08-03

## Scope

This slice covers the six paired Page Setup states: `initial`, `populated`,
`validation-error`, `tab-margins`, `tab-layout`, and `tab-paper`. The authority
is WPF and the comparison uses fresh current-source captures from both hosts at
560 x 600 pixels. The acceptance rule was improvement in the four higher-delta
states without regression in either lower-delta tab state; all six improved.

## Change

The Avalonia Page Setup action row was receiving the shared Windows-style
default-button accent during the shared window-open normalization pass. WPF's
resting OK button uses the neutral action border. The existing shared neutral
button brush is now exposed by `AvaloniaCompactDialogChrome`, and Page Setup
reapplies its shared action style after normalization. This keeps the existing
`IsDefault` and `IsCancel` semantics while removing a route-specific duplicated
color definition.

## Fresh paired evidence

The six-state capture and comparison artifacts are under
`artifacts/wave126-freew-pagesetup-candidate-neutral2/`. The canonical full
dialog report was refreshed from the same paired manifests under
`docs/parity/freew-dialog-harness/`.

| State | Fresh before pixels | Fresh after pixels | Before ratio | After ratio | Before mean | After mean |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Initial | 33935 | 33811 | 10.0997% | 10.0628% | 7.111137 | 7.056970 |
| Populated | 33935 | 33811 | 10.0997% | 10.0628% | 7.111137 | 7.056970 |
| Margins | 33935 | 33811 | 10.0997% | 10.0628% | 7.111137 | 7.056970 |
| Validation error | 34246 | 34122 | 10.1923% | 10.1554% | 7.227727 | 7.173561 |
| Layout | 25120 | 24996 | 7.4762% | 7.4393% | 5.225907 | 5.171740 |
| Paper | 15565 | 15441 | 4.6324% | 4.5955% | 3.341367 | 3.287200 |

Every state improved by 124 changed pixels. All six rows remain classified as
`genuine-visual-mismatch`, and `semanticDifference` is `null` in every row.
Both WPF and Avalonia captured all six states and passed the content gates.

The older canonical route rows (15.25%, 15.35%, 6.72%, and 4.69%) predate the
Wave 121 route-seed evidence. The acceptance comparison above intentionally
uses the fresh current-source baseline, including the current 7.4762% Layout
baseline, so the lower-delta Layout state is evaluated without mixing capture
generations.

## Verification

- Avalonia Page Setup focused tests: 36/36 passed.
- Fresh paired captures: 6/6 WPF and 6/6 Avalonia, all content gates passed.
- `semanticDifference`: null for all six states.
- Canonical report refresh: 478 scenarios, 190 WPF captures, 288 Avalonia captures.
- `git diff --check`: passed.
