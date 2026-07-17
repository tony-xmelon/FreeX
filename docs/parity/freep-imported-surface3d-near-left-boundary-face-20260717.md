# FreeP imported Surface3D near-left boundary face

Date: 2026-07-17

## Finding

PowerPoint's imported Surface3D baseline contains a fifth opaque projected
boundary/material face on the near-left side of the mesh. It is dark orange
(`#D5702C`) and sits above the lower blue boundary face. FreeP previously
rendered that area as part of the top-surface triangles, leaving the left mesh
partition and color registration incomplete.

## Change

The imported boundary-face plan now emits the measured normalized triangle
`(5,122)`, `(82,71)`, `(174,79)` before the existing four boundary faces.
Authored Surface3D charts and the existing top-surface facet policy are
unchanged.

## Evidence

At 1280x720 against a fresh PowerPoint COM export, WPF mean channel diff
improved from `3.0684%` to `3.0333%`. Avalonia measured `0.9709%` against
WPF, and Avalonia versus PowerPoint measured `2.9533%`.

The focused chart and repair-corpus lane passes all `198` tests, and the
Release RenderCompare build completes with 0 warnings and 0 errors.
