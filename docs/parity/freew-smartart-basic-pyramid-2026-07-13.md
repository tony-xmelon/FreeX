# FreeW SmartArt Basic Pyramid - 2026-07-13

This slice adds the Word-common `pyramid1` / Basic Pyramid layout to the FreeW SmartArt preset catalog and shared visual planner.

## Evidence

- `SmartArtPresetsTests` proves the curated `pyramid1` catalog entry resolves as Basic Pyramid.
- `ChartSmartArtVisualPlannerTests` proves `pyramid1` emits deterministic shared `Pyramid` layout geometry: four centered bands, no connectors, and stable natural dimensions.
- `SmartArtRenderingTests` proves WPF consumes the shared plan for the same widening-band approximation.
- `DocumentViewInlineFO4Tests` proves Avalonia carries the shared `Pyramid` geometry snapshot for inline SmartArt.

## Caveat

This is not MS Word pixel parity and does not implement Word's true trapezoid/polygon pyramid bands. FreeW currently represents Basic Pyramid as centered widening rectangles so WPF and Avalonia share deterministic renderer-neutral geometry. Word-authoritative visual baselines, exact trapezoid band geometry, richer SmartArt editing, and broader pyramid-family layouts remain deferred.
