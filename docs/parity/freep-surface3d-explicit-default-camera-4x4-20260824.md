# FreeP Surface3D explicit default-camera 4x4 evidence

Date: 2026-08-24
Corpus fixture: `27-chart-surface3d-4x4.pptx`, slide 01, 1280x720

## Scope

This PowerPoint-authored fixture adds a `Surface3D` chart with four category
columns, four series, no blank cells, and the Office default camera serialized
explicitly as `rotX=15`, `rotY=20`, and `rAngAx=0`. It is a new topology
relative to the existing 3x3 Surface3D corpus fixtures. The matching
`28-chart-surface3d-4x4-compact` control uses the same data and camera in a
compact chart frame, separating topology fidelity from full-slide scaling.

PowerPoint's explicit default camera is semantically equivalent to an omitted
`c:view3D`; it is not an authored camera override. The shared renderer now
normalizes that representation to the imported default-camera projection. Its
elevation also scales with the plot height, preventing full-slide surfaces
from being compressed into the category-axis band.

## Measurements

Mean channel difference against the committed PowerPoint reference:

| Renderer | Before | After | Delta |
| --- | ---: | ---: | ---: |
| WPF | 17.1152% | **12.9559%** | -4.1593 pp |
| Avalonia | 16.9985% | **12.8149%** | -4.1836 pp |

Existing Surface3D controls remain at their established levels after the
change: 22 baseline depth is `2.4221%` WPF / `2.1353%` Avalonia, 25 authored
view is `2.6356%` / `2.5295%`, and 26 tall default frame is `2.5048%` /
`2.2723%`.

The compact 4x4 control measures `5.3093%` WPF and `5.1628%` Avalonia. Its
substantially lower residual than the full-slide fixture confirms the remaining
gap is large-plot projection scaling rather than unsupported 4x4 topology.

The latest correction confines the historic widened front envelope to compact
3x3 grids. Larger Surface3D meshes now keep their category span inside the
drawable width before the shared depth projection is applied. The three 3x3
controls remain byte-stable at the metrics listed above.

The correction is scoped by modeled chart semantics only: chart family,
imported text metrics, and default camera values. It does not inspect a file
name, title, data labels, or fixture-specific geometry.

## Elevation legend follow-up

PowerPoint omits optional `c:varyColors` XML in these saved Surface3D files,
but still renders an elevation-band legend rather than one entry per source
series. The shared planner now recognizes that imported Surface3D behavior
without relying on the optional flag. It produces ordered value intervals and
their Office-style band colors, with the largest elevation shown at the top.

For a compact 4x4 chart, the planner reserves at least 96 units for this
five-item legend; full-size charts preserve their prior imported reservation.
The compact fixture improves from `5.3093%` to `5.2712%` WPF and from
`5.1628%` to `5.1232%` Avalonia. The full fixture improves from `12.9559%` to
`12.9131%` WPF and from `12.8149%` to `12.7843%` Avalonia. Fixtures 22, 25,
and 26 remain unchanged at the measurements above.

## Full-size elevation scale follow-up

The full 4x4 reference resolves nine 5-unit elevation bands (`0-5` through
`40-45`), while its compact control retains five 10-unit bands. The shared
planner now selects the denser automatic range only for a large imported 4x4
or greater grid, only when no value-axis range is authored, and only when the
denser maximum still contains the source data. Both renderers use the sampled
Office swatch colors for all nine bands.

This reduces the full fixture to `12.0660%` WPF and `11.9404%` Avalonia. The
compact control remains at `5.2699%` and `5.1219%`, respectively; its small
improvement is from the exact five-band swatch colors rather than a scale
change.

## Verification

- Focused Surface3D planner test: 1/1 passed.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Both WPF and Avalonia rendered all four Surface3D gate fixtures at 1280x720.
