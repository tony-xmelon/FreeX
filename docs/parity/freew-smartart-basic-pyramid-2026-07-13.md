# FreeW SmartArt Basic Pyramid - 2026-07-13

This slice upgrades the Word-common `pyramid1` / Basic Pyramid layout from centered rectangle-band semantics to shared renderer-neutral polygon band geometry.

The shared `SmartArtLayoutGeometryPlan` now keeps usable text/layout bounds for every pyramid node while also exposing deterministic trapezoid/polygon points for the pyramid band fill/stroke. WPF and Avalonia consume those same shared points instead of inventing renderer-local pyramid shape math.

## Evidence

- `SmartArtPresetsTests` proves the curated `pyramid1` catalog entry resolves as Basic Pyramid.
- `ChartSmartArtVisualPlannerTests` proves `pyramid1` emits deterministic shared `Pyramid` layout geometry: four centered text bounds, no connectors, stable natural dimensions, and polygon points for every pyramid band.
- `SmartArtRenderingTests` proves WPF consumes the shared polygon points by rendering WPF `Polygon` bands while preserving clean text placement.
- `DocumentViewInlineFO4Tests` proves Avalonia carries enough shared `Pyramid` polygon geometry evidence for inline SmartArt to prevent silent regression.

## Caveat

This improves FreeW's shared Basic Pyramid shape geometry, but it does not claim authoritative MS Word pixel parity or external Word PNG baselines. Word-authoritative visual baselines, richer SmartArt editing, and broader pyramid-family layouts remain deferred.
