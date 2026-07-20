# FreeP Surface blank-cell span semantics

Date: 2026-07-20
Branch: `codex/freep-parity-surface3d-shading-next-20260716`

## Change

Surface and Surface3D geometry now consumes the chart-level
`DisplayBlanksAs` policy when a surface needs a render-only vertex for a
missing value. The default `Gap` path retains the existing Office low-band
registration for the imported canonical surface. `Span` interpolates the
missing vertex from the valid same-row category neighbors. `Zero` remains
materialized by the existing blank-sensitive value path.

The logical point table remains source-driven: the interpolated vertex is only
added to the render geometry, so a missing package value is not rewritten as
authored data.

## Verification

- Focused presentation tests: `205/205` compiling.
- Same focused tests with `--no-build`: `205/205`.
- `FreeP.RenderCompare` Release build: `0` warnings, `0` errors.
- Fresh PowerPoint export for Surface3D target: `1/1`.
- Canonical `22-chart-baseline-depth`: WPF `2.6082%`, Avalonia `2.3183%`.
- `06-charts` controls: WPF `0.9924%`, Avalonia `0.3898%` average; `4/4`
  PowerPoint slides exported.
- `18-chart-types` controls: WPF `0.7585%`, Avalonia `0.3122%` average; `4/4`
  PowerPoint slides exported.

The canonical imported fixture remains on its default `Gap` path, so its
visual output remains at the accepted baseline while explicit `Span` charts
now preserve their declared blank-cell behavior.
