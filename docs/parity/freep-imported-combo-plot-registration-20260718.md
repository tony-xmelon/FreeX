# FreeP imported combo plot registration - 2026-07-18

## Scope

The imported `ColumnClustered` plus secondary `Line` chart in
`19-chart-labels.pptx` had category columns drifting right across the plot:
the first WPF bar began at x196 versus PowerPoint x194, and the last began at
x816 versus x813. The imported-combo plot path now uses a 2 DIP left inset and
9 DIP right reduction, moving the plot origin left and tightening its width by
one DIP. Other chart families and authored plot layouts are unchanged.

## Matched COM evidence

Fresh 1280x720 PowerPoint exports and rebuilt Release artifacts were used:

| Metric | Baseline | Candidate |
| --- | ---: | ---: |
| WPF slide 3 whole page | 1.9488% | 1.6685% |
| Avalonia vs PowerPoint slide 3 | 1.7742% | 1.4505% |
| WPF vs Avalonia slide 3 | 0.8043% | 0.8040% |
| WPF slide 1 control | 1.5195% | 1.5195% |
| WPF slide 2 control | 0.6895% | 0.6895% |

The WPF and Avalonia PNGs for all slides in `06-charts` and
`18-chart-types` were byte-identical to their same-main controls. PowerPoint
exported all three target slides successfully.

## Verification

- Focused `ChartBaselineCorpusTests|ChartRenderPlannerTests`: 198/198.
- Presentation focused Release build: 0 warnings, 0 errors.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.

Process rule: when category positions drift progressively across an imported
combo plot, calibrate the owning plot rectangle rather than the secondary-axis
stroke or labels; require target-page improvement and byte-stable chart-family
controls on both hosts.
