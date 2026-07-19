# FreeP imported Surface3D first-cell diagonal probe rejected

## Scope

The imported 3-by-3 `Surface3D` fixture's first complete cell was temporarily
split on the alternate `0-2` diagonal while all other cells retained the
accepted `0-3/1-3` split. The probe targeted the PowerPoint orange face, whose
exact-color mask reaches the chart's left edge while the current orange
triangle does not.

## Matched current-artifact evidence

The Release `FreeP.RenderCompare` artifact was rebuilt before both renders and
compared with the persistent 1280x720 PowerPoint PNG:

| Backend | Accepted split | First-cell alternate |
| --- | ---: | ---: |
| WPF whole slide | `2.6082%` | `2.6469%` |
| Avalonia whole slide | `2.3183%` | `2.3577%` |

The candidate was rejected and the source restored. The left-reaching orange
mask is therefore not evidence that the first cell alone owns the alternate
diagonal; changing its triangle ownership worsens both hosts.

## Process rule

For generated Surface3D facets, a local color-mask improvement must survive
both-host whole-page gates. When a narrow diagonal probe fails, continue with
facet painter ownership or source mesh semantics rather than adding another
render-local vertex correction.
