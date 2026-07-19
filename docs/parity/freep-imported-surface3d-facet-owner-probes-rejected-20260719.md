# FreeP imported Surface3D facet-owner probes rejected

## Scope

The current imported `Surface3D` planner uses a 3-by-3 projected mesh with
render-only triangle splitting for complete cells. Exact-color masks showed
PowerPoint's near-left orange face starting at the same left anchor as the
blue face, while FreeP's orange triangle starts at the interior projected
vertex. Three narrow owner probes tested that observation without changing
the shared point table or other cells:

1. Split only the first complete cell on the alternate `0-2` diagonal.
2. Keep the accepted blue triangle, but give the orange triangle the
   left-anchor geometry `[p00,p11,p10]`.
3. Paint that orange owner first, then paint the blue owner over it.

## Matched current-artifact evidence

Each candidate used a freshly rebuilt Release `FreeP.RenderCompare` artifact
and the persistent 1280x720 PowerPoint reference:

| Backend | Accepted mesh | First-cell alternate | Layered orange | Reversed owner/painter |
| --- | ---: | ---: | ---: | ---: |
| WPF whole slide | `2.6082%` | `2.6469%` | `2.7003%` | `2.7211%` |
| Avalonia whole slide | `2.3183%` | `2.3577%` | `2.4102%` | `2.4312%` |

All three probes were rejected and the accepted `0-3/1-3` split, color
mapping, and painter order were restored. The result rules out a local first
cell diagonal, overlap, or simple painter-order correction as the parity fix.

## Process rule

Exact-color mask geometry is useful for locating ownership, but a local
render-only facet correction is not valid unless both hosts and the whole page
improve. The next Surface3D work should model the imported/generated chart
surface primitive contract or source mesh semantics, not accumulate more
fixture-local triangle patches.
