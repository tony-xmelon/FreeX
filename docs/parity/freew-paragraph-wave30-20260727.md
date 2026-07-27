# FreeW Paragraph Dialog Wave 30

This slice aligns the common WPF/Avalonia Paragraph dialog chrome while preserving the WPF-authority
geometry: `380x345` for Indents and Spacing, populated, and validation states, and `380x327` for Line
and Page Breaks.

## Implementation

- Paragraph now uses the WPF combo surface (`#F0F0F0`) and the rendered Fluent combo template parts receive
  that surface, including the selected-value field.
- Compact textbox chrome now applies its authority background to the rendered textbox border surface.
  This removes Avalonia's darker disabled-template fill from the Paragraph `By (pt)` field while retaining
  the shared authority border and muted disabled text treatment.
- The existing Paragraph pane margins, tab heights, widths, and action row geometry remain unchanged.
- The visual harness command parser now accepts the conventional `--` separator and infers `inventory` or
  `compare` from its named arguments, allowing the tracked inventory to be regenerated through the tool.

## Fresh Paired Evidence

WPF and Avalonia were captured at the same logical size for all five common states. The fresh route-local
captures are under the ignored `artifacts/freew-paragraph-wave30-*` directories in the task worktree.

| State | Size | Prior canonical changed | Fresh final changed | Prior canonical mean | Fresh final mean | Fresh final p95 |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| `paragraph.initial` | 380x345 | 17.763% | 18.332% | 17.483 | 15.501 | 108 |
| `paragraph.populated` | 380x345 | 17.763% | 18.332% | 17.483 | 15.501 | 108 |
| `paragraph.tab-indents-and-spacing` | 380x345 | 17.763% | 18.332% | 17.483 | 15.501 | 108 |
| `paragraph.tab-line-and-page-breaks` | 380x327 | 8.724% | 9.665% | 9.782 | 9.702 | 83 |
| `paragraph.validation-error` | 380x345 | 18.603% | 19.173% | 18.646 | 16.377 | 108 |

The prior canonical values are the tracked report values and the fresh final values are from the same-size
route-local captures produced in this slice. A direct same-session initial-state probe improved from
`20.700% / 16.590` before the patch to `18.332% / 15.501` after it. The changed-pixel gate remains
framework-sensitive because Avalonia and WPF still rasterize labels, input borders, and combo arrows through
different native templates; the mean channel delta improves across every fresh state.

## Verification

- `ParagraphDialogVisualParityTests`: 4/4 passed.
- Fresh WPF captures: 5/5 captured.
- Fresh Avalonia captures: 5/5 captured.
- Dialog inventory regenerated with `FreeW.DialogVisualHarness`: 158 routes, 466 scenarios.

## Remaining Debt

The combo arrow glyph and fine text rasterization remain visibly different from WPF. Those are native
Avalonia/Fluent rendering details; changing them further would require a custom interactive combo template
and a broader compact-dialog visual pass rather than a Paragraph-only geometry adjustment.
