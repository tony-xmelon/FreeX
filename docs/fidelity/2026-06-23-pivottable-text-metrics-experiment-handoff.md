# PivotTable text metrics experiment handoff - 2026-06-23

Scope: Windows-only local PivotTable parity against desktop Microsoft Excel. External connections, Data Model, and OLAP remain explicitly out of scope.

This note records the pause point after the outline parent-row style slice. No product code from the text-metrics/border experiments in this follow-up slice was landed; both candidate fixes were reverted because the visual evidence did not improve.

## Integrated baseline before this pause

- `origin/main` already includes `cfb6f2fb9` (`Merge PivotTable outline parent style fidelity`).
- The latest full PivotTable visual evidence root is:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-outline-parent-style-20260623\full
```

- All 16 native PivotTable corpus cases had exact Excel-vs-FreeX image dimensions.
- The highest remaining exact visual gaps in that run were concentrated in loaded native layout/style and text rendering cases:

| Case | Diff | Exact dimensions | Exact pixel metrics |
| --- | ---: | --- | --- |
| `date_grouping_003` | 6.9% | 371x218 | mean 9.440%, changed>8 20.31% |
| `layout_options_002` | 6.6% | 713x314 | mean 12.128%, changed>8 73.89% |

## Reverted experiment: Medium6 compact child style

Target: `date_grouping_003`.

Candidate change:

- Added a loaded native compact child-row style path for `PivotStyleMedium6` based on imported row-label indent.
- Added a focused `PivotTableRefreshServiceTests.Styles` assertion for loaded compact child rows.

Focused unit result: 155 passed, 1 skipped.

Visual result:

| Run | Diff | Exact pixel metrics |
| --- | ---: | --- |
| Baseline | 6.9% | mean 9.440%, changed>8 20.31% |
| Candidate | 7.1% | mean 9.742%, changed>8 22.67% |

Evidence root:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-medium6-compact-child-style-20260623\date_grouping_003
```

Reason reverted: the change made the focused visual case worse. The dominant gap appears to be compact row-label text positioning/metrics rather than a simple materialized style flag.

Workbook facts preserved for resume:

- Workbook:

```text
C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-gaps-20260623b\generated-excel-pivots\Excel_native_pivot_date_grouping_003.xlsx
```

- `pivotTableStyleInfo@name` is `PivotStyleMedium6`.
- `rowFields` contains two fields for Years and Months.
- Pivot location is `A3:B9`, with `firstHeaderRow="1"`, `firstDataRow="1"`, and `firstDataCol="1"`.
- Loaded worksheet styles put `A5:A8` on a left-aligned style with `indent="1"`, while values use the number-format style in `B5:B8`.
- The remaining visual mismatch is that Excel renders month labels and values heavier/condensed and visibly farther into the compact label gutter than FreeX.

## Reverted experiment: Medium13 body borders

Target: `layout_options_002`.

Candidate change:

- Added loaded native `PivotStyleMedium13` body/stripe/header/total border rules, first with the palette border color and then with a stronger magenta style color.
- Extended the existing Medium13 style test to assert the loaded body border behavior.

Focused unit result after fixture correction: 154 passed, 1 skipped.

Visual result:

| Run | Diff | Exact pixel metrics |
| --- | ---: | --- |
| Baseline | 6.6% | mean 12.128%, changed>8 73.89% |
| Pale border candidate | 6.6% | mean 12.218%, changed>8 73.60% |
| Strong border candidate | 6.6% | mean 12.164%, changed>8 73.93% |

Evidence roots:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-medium13-body-borders-20260623\layout_options_002
C:\Users\ali\freex-xlsx-verify\visual\pivot-medium13-body-borders-20260623\layout_options_002-strong-border
```

Reason reverted: border-only materialization did not improve the exact visual metrics. The previous committed Medium13 body-fill pass remains the better baseline.

Workbook facts preserved for resume:

- Workbook:

```text
C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-gaps-20260623b\generated-excel-pivots\Excel_native_pivot_layout_options_002.xlsx
```

- `pivotTableStyleInfo@name` is `PivotStyleMedium13`.
- Style flags: row headers, column headers, row stripes, column stripes, and last column are enabled.
- Layout flags: `showHeaders="0"`, `compact="0"`, `compactData="0"`, `rowGrandTotals="0"`.
- Pivot location is `A3:F13`, with `firstHeaderRow="1"`, `firstDataRow="2"`, and `firstDataCol="2"`.
- Sampled Excel pixels include magenta internal style colors around `(216,109,205)` and header color around `(160,43,147)`; FreeX remains too pale and text-light across much of the body.

## Current resume targets

1. Compact PivotTable text placement for loaded native `PivotStyleMedium6` date grouping. Start with `PivotRowLabelAdornmentPlanner`, `GridView.Rendering`, and `GridView.Rendering.AutoFilter` rather than only `PivotTableRefreshService.Styles`.
2. Loaded native body/text rendering for `PivotStyleMedium13` layout options. Treat borders, body fills, and text ink together; isolated border color did not help.
3. Add a machine-readable visual metrics artifact to `FreeX.SheetGridImageCompare` so future agents can compare exact metrics without parsing human text reports.
4. Keep the 16-case native PivotTable corpus as the broad gate, but require a focused visual improvement before rerunning the full set.

## Pause status

- The implementation worktree was clean before this documentation-only handoff.
- No partially applied code changes remain from the reverted experiments.
- This note is intended as the durable restart point for the next PivotTable parity session.
