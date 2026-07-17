# FreeP imported Surface3D near-left boundary face

Date: 2026-07-17

## Finding

PowerPoint's imported Surface3D baseline contains two additional opaque
projected boundary/material faces on the near-left and right sides of the
mesh. Both are dark orange (`#D5702C`); FreeP previously rendered those areas
as part of the top-surface triangles, leaving the mesh partition and color
registration incomplete.

## Change

The imported boundary-face plan now emits the measured normalized polygons
`(5,122)`, `(72,71)`, `(132,71)`, `(174,79)` and
`(247,101)`, `(320,119)`, `(312,134)` before the existing four boundary
faces. Authored Surface3D charts and the existing top-surface facet policy are
unchanged.

## Evidence

At 1280x720 against a fresh PowerPoint COM export, WPF mean channel diff
improved from `3.0333%` to `2.9994%`. Avalonia measured `0.9711%` against WPF,
and Avalonia versus PowerPoint measured `2.9192%`.

The focused chart and repair-corpus lane passes all `198` tests, and the
Release RenderCompare build completes with 0 warnings and 0 errors.
