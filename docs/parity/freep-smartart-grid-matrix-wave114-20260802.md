# FreeP Wave 114: SmartArt Grid Matrix

Grid Matrix now has a dedicated shared live layout plan in
`SmartArtLayoutEngine`. It renders the first four Level 1 components in
stable row-major TopLeft, TopRight, BottomLeft, and BottomRight quadrants,
using a centered square envelope and deterministic shape names. Later text
remains available in the SmartArt data model but does not expand admission or
render as extra grid rows, matching PowerPoint's four-idea Grid Matrix
semantics.

The plan intentionally emits no connectors: Grid Matrix places concepts along
two axes and does not describe a flow relationship. WPF and Avalonia consume
the same shared render plan, while authoring and drawing-cache regeneration
continue through the existing shared SmartArt planners and native diagram
parts. The focused package test covers native layout authoring, cache shape
names, save/reload, and schema-shaped `dsp:drawing` output.

PowerPoint-authoritative cell metrics, effects, and visual baselines remain
deferred. Basic Matrix, Titled Matrix, and other unmodeled matrix layouts keep
their existing generic or cached fallback behavior.
