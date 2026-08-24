# FreeP Surface3D explicit default-camera 4x4 evidence

Date: 2026-08-24
Corpus fixture: `27-chart-surface3d-4x4.pptx`, slide 01, 1280x720

## Scope

This PowerPoint-authored fixture adds a `Surface3D` chart with four category
columns, four series, no blank cells, `varyColors=1`, and the Office default
camera serialized explicitly as `rotX=15`, `rotY=20`, and `rAngAx=0`. It is a
new topology relative to the existing 3x3 Surface3D corpus fixtures.

PowerPoint's explicit default camera is semantically equivalent to an omitted
`c:view3D`; it is not an authored camera override. The shared renderer now
normalizes that representation to the imported default-camera projection. Its
elevation also scales with the plot height, preventing full-slide surfaces
from being compressed into the category-axis band.

## Measurements

Mean channel difference against the committed PowerPoint reference:

| Renderer | Before | After | Delta |
| --- | ---: | ---: | ---: |
| WPF | 17.1152% | **13.6306%** | -3.4846 pp |
| Avalonia | 16.9985% | **13.4906%** | -3.5079 pp |

Existing Surface3D controls remain at their established levels after the
change: 22 baseline depth is `2.4221%` WPF / `2.1353%` Avalonia, 25 authored
view is `2.6356%` / `2.5295%`, and 26 tall default frame is `2.5048%` /
`2.2723%`.

The correction is scoped by modeled chart semantics only: chart family,
imported text metrics, and default camera values. It does not inspect a file
name, title, data labels, or fixture-specific geometry.

## Verification

- `ChartRenderPlannerTests`: 248/248 passed.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Both WPF and Avalonia rendered all four Surface3D gate fixtures at 1280x720.
