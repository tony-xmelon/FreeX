# FreeP Funnel Chart Authoring

Date: 2026-08-02

## Scope

PowerPoint Funnel charts were previously admitted only as an unknown chart family. This slice adds the shared functional path:

- `ChartType.Funnel` is preserved in the model and DOCX-like package chart XML as `c:funnelChart`.
- Insert Chart creates an editable Value series with four funnel stages.
- Edit Chart Data exposes Funnel as a chart-type option and keeps the single-series value grid.
- The shared planner creates centered, descending trapezoid stages with point colors.
- WPF and Avalonia paint the same renderer-neutral funnel primitives.

This is a function-first slice. It does not claim PowerPoint raster parity for every Funnel style, label mode, 3-D effect, or imported layout variant.

## Verification

- Presentation focused chart/editor tests: `303/303`
- WPF ChartTests: `103/103`
- Avalonia focused chart insertion tests: `18/18`
- Avalonia Release application build: `0 warnings, 0 errors`
- Funnel package round-trip: native `c:funnelChart`, categories, and values preserved

## Deferred

Imported Funnel-specific labels, connector/outline styling, and advanced PowerPoint chart formatting remain part of the broader chart semantics backlog.
