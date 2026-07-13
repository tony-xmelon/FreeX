# FreeW Drop Cap Layout Parity Slice - 2026-07-13

## Scope

This slice moves Drop Cap beyond "make the first run large" by adding shared, renderer-neutral layout intent and a shared presentation plan consumed by both WPF and Avalonia.

The shared model now retains:

- position: Dropped or In Margin
- line span
- cap glyph size
- distance from adjacent text

The shared presentation plan captures:

- leading glyph run index and glyph text
- cap box
- first-line-span text reservation
- body text inset and effective body text width
- distinct dropped versus in-margin placement intent

## Renderer Evidence

WPF keeps using a FlowDocument `Floater`, but the renderer now asks `DocumentViewLayoutPlanner.BuildDropCapLayoutPlan` for the cap geometry and preserves the shared intent through `ParagraphTag` during commit/readback.

Avalonia records `DocumentDropCapLayoutPlan` values during layout and uses the shared dropped-mode reservation to reduce first-line wrapping width beside the cap. In-margin mode is recorded distinctly and keeps the body text column width unchanged.

Both renderers register dotted and hyphenated command IDs as aliases for dropped, in-margin, and none so existing WPF-style and Avalonia-style command surfaces route to the same behavior.

## Limits

This is not an authoritative Microsoft Word pixel baseline. It does not claim exact Word pagination, exact glyph metrics, or external Word PNG parity. The value of this slice is deterministic shared planning plus focused renderer consumption evidence that prevents a silent fallback to only an enlarged leading run.
