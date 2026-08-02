# FreeW Page Setup visual parity, Wave 114

Date: 2026-08-02

## Scope

Aligned the WPF-authoritative Page Setup family across the WPF and Avalonia
hosts through `PageSetupDialogPlanner.PresentationMetrics`. The shared
presentation contract now owns dialog width, tab/content/action margins, row
insets, label-to-field geometry, field widths, checkbox and launcher spacing,
tab names, labels, and the validation policy consumed by both hosts.

The planner remains the single state and validation authority. No controls were
added solely for visual evidence, and both hosts consume the planner labels.
The shared custom-height label is `Height (pt):`, preserving the WPF authority
text rather than propagating Avalonia's former leading-space quirk.

## Paired evidence

Fresh WPF and Avalonia captures covered all six canonical states:
`page-setup.initial`, `page-setup.populated`, `page-setup.tab-margins`,
`page-setup.tab-paper`, `page-setup.tab-layout`, and
`page-setup.validation-error`. The canonical comparison is:

`docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.html`

| State family | Before changed pixels | After changed pixels | Before ratio | After ratio | After mean channel delta |
| --- | ---: | ---: | ---: | ---: | ---: |
| Initial / populated / Margins | 52,635 | 51,228 | 15.665% | 15.246% | 8.794 |
| Layout | 23,810 | 22,585 | 7.086% | 6.722% | 4.962 |
| Paper | 16,247 | 15,765 | 4.835% | 4.692% | 3.387 |
| Validation error | 53,035 | 51,560 | 15.784% | 15.345% | 8.929 |

All six pairs pass the content gate and have no semantic differences. The
non-Page-Setup rows retain the same semantic row hash before and after this
refresh (`856c56f050b05e81383c43da9e4dfe4ff06e674864e1996ee499cc89cceb63b2`).

This follow-up recaptured the full six-state Page Setup set after correcting
`CustomHeightLabel`; only the Paper row changed from the original Wave114
refresh.

The production Avalonia host was also published and exercised in the owned
Linux Docker/Xvfb desktop at 1280x820, 96 DPI. Visible Margins, Paper, and
Layout Page Setup states are retained under:

`artifacts/linux-interactive-wave114/freew/`

## Residual analysis

The post-change heatmaps and paired crops show the remaining painted delta
around text glyph edges, textbox and combobox borders, tab chrome, checkbox
glyphs, and action-button focus/raster edges. The content bounds and major
field/action geometry now agree; only small 1-3 px offsets remain where WPF
and Avalonia measure native templates differently. These are host renderer and
native-control rasterization residuals, not planner/state or missing-control
differences. Further reduction would require host-specific template or font
emulation rather than an honest shared metric.

## Verification

- Planner Page Setup tests: **8/8 passed**.
- WPF Page Setup tests: **4/4 passed**.
- Avalonia Page Setup visual parity tests: **4/4 passed**.
- Fresh paired WPF captures: **6/6 captured**.
- Fresh paired Avalonia captures: **6/6 captured**.
- Production Linux Docker/Xvfb Avalonia states: **3 captured**.
- `Generate-FreeWPageLayoutDialogParityEvidence.ps1`: completed.
- `git diff --check`: passed.
- `origin/main` fetched and merged cleanly at `a165a6e4c7` (including
  `d2c1953278`); no conflict.
