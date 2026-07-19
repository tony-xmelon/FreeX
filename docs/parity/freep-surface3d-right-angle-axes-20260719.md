# FreeP Surface3D right-angle axes

Date: 2026-07-19
Branch: `codex/freep-parity-surface3d-shading-next-20260716`

## Change

Authored `c:view3D/c:rAngAx=1` now suppresses the perspective lift in the
shared Surface3D projection. The authored elevation, azimuth, height, and
depth remain active; only the perspective component is disabled. Imported
Surface3D charts without `c:view3D` continue using their existing Office
default approximation.

This follows the OOXML definition of `rAngAx` as right-angle axes rather than
perspective axes. It is scoped to explicit camera metadata and does not alter
the current imported 3x3 corpus path.

## Verification

- `ChartBaselineCorpusTests|ChartRenderPlannerTests`: compile-first **202/202**
- Same focused tests with `--no-build`: **202/202**
- Existing WPF imported Surface3D artifact remained unchanged; no fresh
  PowerPoint COM score was claimed because the desktop automation instance
  did not complete the bounded export.
