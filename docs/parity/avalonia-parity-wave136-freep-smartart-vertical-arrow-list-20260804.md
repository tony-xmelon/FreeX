# FreeP Wave 136 SmartArt import depth

## Selected layout

This slice admits one strict `verticalArrowList` imported-cache grammar from
the deterministic `tools/FreeP.RenderCompare/corpus/15-smartart-grouped-list.pptx`
fixture, slide 10. The package has four flat, distinct data nodes and four
effect-free cached `dsp:sp` shapes, each using `a:prstGeom prst="downArrow"`.

## Exact grammar

The reader promotes the cache only when the four shape texts match the four
data nodes in order, all roles are `AutoShape/DownArrow`, no shape or drawing
effects are present, and the slots exactly match the shared planner's
8,229,600 x 5,744,800 EMU frame: `x=329,184`, `cx=7,571,232`,
`cy=1,251,289`, and y positions `229,792`, `1,574,434`, `2,919,076`, and
`4,263,718`. The shared `SmartArtLayoutEngine` remains the geometry source and
both WPF and Avalonia consume it through `SlideCompositor`.

Any extra role, picture, connector, effect, duplicate or reordered text,
hierarchical connection, malformed shape, or different geometry keeps the
preserved cached drawing authoritative. The guard is limited to imported
drawings; authoring data without a cached drawing retains the existing live
layout path.

## Evidence and limits

The fixture XML test, reader/compositor host tests, presentation planner test,
and paired WPF/Avalonia renderer contracts cover the package grammar and shared
consumption boundary. The FreeP workflow inventory increases from 107 to 108
rows.

This is bounded functional evidence. It does not claim PowerPoint-identical
arrow contours, text fitting, effects, larger imported variants, or an
authoritative PowerPoint raster baseline.
