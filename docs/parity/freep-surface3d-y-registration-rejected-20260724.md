# FreeP generic Surface3D Y-registration probe rejected

## Scope

The generic imported 3x3 `Surface3D` scene in
`22-chart-baseline-depth.pptx` was isolated by its no-`view3D`, varying-color,
three-series/three-category signature. The probe moved only the imported mesh
point offset from `-9` to `-6` DIP vertically. The explicit 25/35-degree
Surface3D path and the stock, scatter, and 100%-stacked controls were outside
the candidate branch.

## Evidence

Fresh matching 1280x720 PowerPoint COM comparison:

| Metric | Baseline | Candidate |
| --- | ---: | ---: |
| Whole `22-chart-baseline-depth` slide | 2.5856% | 2.6336% |

The focused planner contracts also moved the established mesh coordinates
(`27/27` baseline tests passed after restoration). The candidate was rejected:
the apparent vertical registration is coupled to the projected camera/facet
model, so a scalar Y translation is not a valid generic correction.

## Verification

- Release RenderCompare build: 0 warnings, 0 errors.
- Fresh PowerPoint COM export: 1/1 slide.
- Restored `ChartBaselineCorpusTests`: 27/27 compiled and no-build.
- Restored source: `ImportedSurfacePointOffsetY = -9.0`.
