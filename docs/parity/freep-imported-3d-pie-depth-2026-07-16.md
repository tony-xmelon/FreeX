# FreeP Imported 3-D Pie Depth

FreeP now models the imported PowerPoint 3-D pie path separately from the
classic authored 3-D pie path. Imported charts use a wide, shallow top face,
an explicit front-half sidewall geometry, PowerPoint-like top-face shading,
and angle-dependent sidewall lighting in both WPF and Avalonia renderers.

Evidence deck: the existing `06-charts.pptx` pie slide was copied to a
temporary oracle and its chart part was changed from `pieChart` to
`pie3DChart`. PowerPoint COM opened and exported all four slides successfully.

| Renderer | 3-D pie slide diff | Four-slide average |
| --- | ---: | ---: |
| WPF vs PowerPoint | 4.1445% | 2.0585% |
| Avalonia vs PowerPoint | 4.1836% | 2.0085% |

The prior FreeP 3-D pie path measured about 17% on the isolated slide because
it drew a small ordinary pie plus a complete offset duplicate instead of
visible front sidewalls.
