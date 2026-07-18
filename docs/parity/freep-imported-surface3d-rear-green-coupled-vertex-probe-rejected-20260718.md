# FreeP imported Surface3D rear-green coupled vertex probe rejected - 2026-07-18

## Scope

Fresh current PowerPoint raster masks showed the imported rear-green
`#8BAB74` face was smaller than the FreeP face (`1161` vs `853` exact pixels),
with the target upper-right edge wider and the lower tip four pixels farther
left. A coupled three-vertex probe changed the measured boundary points from
`(201,72),(232,42),(306,33)` to `(197,72),(235,42),(325,33)` in the imported
Surface3D boundary-facet path. The neighboring yellow face and all logical
surface points were left unchanged.

## Matched COM evidence

Fresh current Release renders and a fresh PowerPoint COM export at 1280x720:

| Backend / gate | Accepted | Candidate |
| --- | ---: | ---: |
| WPF whole page | 2.6185% | 2.6198% |
| Avalonia vs PowerPoint whole page | 2.3288% | 2.3300% |

The coupled polygon was rejected because both full-page gates regressed. The
source contract also failed as expected until the probe was reverted, proving
that the accepted measured geometry remained protected. The original points
were restored; no renderer or planner behavior changed.

## Verification

- Candidate focused chart tests: 197 passed, 1 expected geometry-contract failure.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh PowerPoint export: 1/1 slide exported successfully.
