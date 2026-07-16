# FreeP Imported 3-D Column Depth

FreeP now preserves imported `bar3DChart` column charts through the model and
PPTX reader/writer. The shared chart plan projects the imported column bases,
narrows columns for perspective, applies category-dependent depth scaling,
and emits PowerPoint-like top and side faces in both WPF and Avalonia.

Evidence deck: a temporary PowerPoint COM oracle converted the first chart in
`06-charts.pptx` to `xl3DColumnClustered` (`ChartType=54`) and exported all
four slides successfully.

| Renderer | 3-D column slide diff | Four-slide average |
| --- | ---: | ---: |
| WPF vs PowerPoint | 2.8487% | 1.6471% |
| Avalonia vs PowerPoint | 2.8754% | 1.5955% |

The baseline 3-D pie deck remains at 3.3449% for the existing 22-chart
surface-depth corpus slide after this change.
