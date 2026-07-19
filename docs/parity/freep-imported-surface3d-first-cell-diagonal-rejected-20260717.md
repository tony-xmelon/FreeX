# FreeP imported Surface3D first-cell diagonal rejected - 2026-07-17

## Scope

After the accepted blank-vertex and rear-North registrations, a topology-only
probe changed the first imported Surface3D cell from the committed `0-3` /
`1-3` split to the alternate `0-2` / `0-2` diagonal. All vertex positions and
colors were otherwise unchanged.

## Matched COM evidence

Fresh current-main controls and candidate renders were compared with the
persistent 1280x720 PowerPoint export:

| Backend / ROI | Before | Candidate |
| --- | ---: | ---: |
| WPF whole page | 2.6388% | 2.6802% |
| WPF Surface `(560,90)-(1030,310)` | 5.3761% | 5.7452% |
| WPF tight mesh `(590,105)-(980,300)` | 6.6289% | 7.1308% |
| WPF low-band fold `(595,195)-(770,300)` | 9.6699% | 10.5262% |
| Avalonia whole page | 2.3451% | 2.3872% |
| Avalonia Surface | 5.3243% | 5.6994% |
| Avalonia tight mesh | 6.6215% | 7.1315% |

Stock, scatter, and stacked-chart controls remained stable, proving the probe
was isolated but not beneficial. The alternate diagonal was reverted.

## Verification

- Candidate focused planner compile: 196 passed, 1 expected topology assertion failure.
- Candidate `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Product source restored to the accepted `0-3` / `1-3` topology.
