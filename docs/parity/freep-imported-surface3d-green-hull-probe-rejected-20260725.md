# FreeP imported Surface3D green hull probe rejected - 2026-07-25

The canonical imported 3-by-3 Surface3D in
`22-chart-baseline-depth.pptx` still has two PowerPoint `#97BD80` regions:

- dominant right region: `3664 px`, bbox `(796,177)-(934,221)`;
- small upper region: `198 px`, bbox `(737,177)-(787,183)`.

A WPF-only probe replaced both corresponding painter slots with polygons
derived from the exact-color mask hulls. The shared mesh, Avalonia renderer,
and generic projection remained unchanged. The focused chart corpus passed
`31/31` and the consuming RenderCompare Release build completed with `0`
warnings and `0` errors.

Fresh WPF scoring rejected the candidate:

- whole slide: `2.4862% -> 2.5440%`;
- candidate dominant green: `3486 px`, bbox `(799,177)-(932,220)`;
- candidate small green: `138 px`, bbox `(741,177)-(783,181)`.

The exact-color masks moved closer, but whole-slide parity regressed. This
confirms that the remaining error is shared projected-edge and painter
ownership, not an independently calibratable green hull. No product code from
the probe remains.

A follow-up broadened the same WPF-only approach to the adjacent imported
Surface3D brown and pale/light-green faces, using their PowerPoint exact-color
mask hulls while preserving each original painter slot. The focused chart
corpus still passed `31/31` and the consuming Release build remained clean,
but fresh scoring moved the whole-slide delta from `2.4862%` to `2.4958%`.
This broader result is also rejected. Exact-color face masks are diagnostic
evidence only; accepting a correction requires the projected mesh and all
neighboring face ownership to improve together.
