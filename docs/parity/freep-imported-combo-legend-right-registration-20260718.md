# FreeP imported combo legend right registration parity

This slice corrects the imported `19-chart-labels.pptx` combo chart's right
legend registration. PowerPoint places the legend about 10 pixels left of the
previous WPF/Avalonia result; the imported combo planner's dedicated
`ImportedComboLegendRightCompensation` was the owning offset.

## Change

- Removed the imported combo-only `8 DIP` right-edge compensation.
- Kept the change inside the imported combo path with a secondary axis; other
  chart types and legend paths are unchanged.

## Fresh matched COM evidence

The candidate and baseline used the same current Release renderer artifact,
PowerPoint COM export, `1280x720` output, and `composite/wpf-composite-renderer`
provenance.

| Metric | Before | After | Delta |
| --- | ---: | ---: | ---: |
| WPF slide 3 whole page | 1.9669% | 1.9516% | -0.0153 pp |
| WPF slide 3 legend ROI `(1030,290)-(1280,500)` | 5.8099% | 5.5413% | -0.2686 pp |
| WPF slide 3 plot ROI `(140,85)-(1030,640)` | 1.9461% | 1.9461% | 0.0000 pp |
| WPF slide 3 title ROI `(0,0)-(1280,75)` | 1.8733% | 1.8733% | 0.0000 pp |
| WPF slide 3 category-label ROI `(100,620)-(1000,710)` | 1.5637% | 1.5637% | 0.0000 pp |

Slides 1 and 2 were byte-identical to the pre-probe WPF render. Fresh
PowerPoint export completed 3/3 slides without a repair prompt. The fresh
Avalonia render also completed 3/3 slides; its slide-3 WPF-independent score
against the same COM export was `1.7742%`.

## Verification

- `ChartBaselineCorpusTests`: 24 passed, 0 failed.
- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release`: 0 warnings, 0 errors.
- Fresh `--avalonia-compare` export: WPF/Avalonia/PowerPoint renders completed
  for all 3 slides.
