# FreeP run baseline token retention

Date: 2026-07-21

## Scope

Imported DrawingML run properties now preserve `a:rPr/@baseline` through the FreeP model, PPTX read/write, presentation cloning, text-edit run splitting/merging, auto-fit/column clones, and resolved WPF/Avalonia run state. Positive values raise a run and negative values lower it; values use DrawingML `ST_Percentage` units (one thousandth of a percent).

The edit planners compare the token when coalescing adjacent runs, so a superscript/subscript boundary cannot be erased by a later text edit. Plain-text paragraphs with baseline tokens now use a host-local shared-line-baseline route in both WPF and Avalonia; the signed token is converted to a percentage of the resolved run font size.

## Evidence

`RunBaselineRoundTripTests` writes positive and negative baseline tokens, checks the serialized `slide1.xml`, reloads the package, and verifies both values. The focused test is the acceptance gate for this semantic/package slice.

## Deliberate limitation

The host route is deliberately bounded to plain, non-wrapping runs. Tabs, OMML math, and text-effect paragraphs retain their existing renderer owners; a baseline-bearing paragraph that would wrap falls back to the existing paragraph renderer until fragment-level baseline layout is measured. No PowerPoint-authoritative raster score is claimed for baseline placement yet; a dedicated COM fixture is still needed to validate exact glyph geometry and downstream line-height behavior.
