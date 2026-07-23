# Basic Process Full-Bounds Probe Rejected

## Hypothesis

The floating `process1` SmartArt in `drawing-objects-complex.docx` looked inset relative to
the cached Word PNG. `BuildBasicProcessGeometry` had an 8-unit outer margin in a 46-unit-tall
natural canvas, so removing the margin appeared likely to align the nodes to the authored frame.

## Probe

Set only the `process1` geometry margin from 8 to 0, rebuilt the consuming Release
`FreeW.FidelityRender` artifact, and rendered the existing fixture at 816x1056 against the same
cached Word baseline. The probe also changes the grouped `process1` child on the page, so that
neighbor was scored explicitly.

## Result

Raw RGB mean channel deltas (0-255):

| Region | Baseline | Margin 0 candidate | Result |
| --- | ---: | ---: | --- |
| Whole page | 19.6493 | 19.6993 | Regressed |
| Floating process ROI `(130,480)-(450,595)` | 39.7420 | 40.0883 | Regressed |
| Broad drawing ROI `(100,165)-(750,775)` | 31.5582 | 31.6669 | Regressed |
| Group ROI `(455,520)-(755,780)` | 36.5859 | 36.9751 | Regressed |
| Textbox control `(110,180)-(335,305)` | 41.7995 | 41.7995 | Byte-stable |
| Chart control `(365,325)-(665,515)` | 24.5373 | 24.5373 | Byte-stable |

The source and planner tests were restored to the 8-unit margin after the candidate failed every
affected visual gate.

## Conclusion

The apparent visible inset is not a generic `process1` natural-bounds issue. Preserve the shared
geometry until a style- or source-signature-specific SmartArt path is proven; require the target,
grouped-process neighbor, and whole page to improve together.
