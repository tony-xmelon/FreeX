# FreeP SmartArt `hierarchy3` Live Layout - 2026-07-27

## Selected gap

The PowerPoint corpus deck `tools/FreeP.RenderCompare/corpus/14-smartart-live.pptx`
contains a real `layout/hierarchy3` diagram on slide 2. Before this slice,
`PptxPackageReader` classified it as `SmartArtFamily.Hierarchy` but deliberately set
`IsLiveLayoutSupported=false`, leaving the imported diagram on the cached
`dsp:drawing` path even though the shared hierarchy planner already handled the
authoring ID.

## Implementation

`hierarchy3` is now admitted by the shared reader allow-list and routed by
`SmartArtLayoutEngine` through the existing left-to-right hierarchy planner. This
matches the corpus layout definition's `hierChild` algorithm with `linDir=fromL`:
the root/parent column is on the left, child columns progress to the right, and
parent-child connectors are renderer-neutral shared line shapes. WPF and Avalonia
therefore consume the same live plan.

## Evidence

- Layout test proves three-level hierarchy3 boxes and connectors use the left-to-right
  depth columns.
- Editing-planner test proves drawing-cache regeneration emits the same three boxes and
  two connectors for hierarchy3.
- Reader test proves a hierarchy3 package is admitted as live while unrelated unknown
  hierarchy IDs remain cached fallback.
- Host test reads the imported corpus and feeds its parsed hierarchy3 data into the
  shared live layout plan.

No PowerPoint COM, hardware, or external-only evidence was used.

## Residuals

The live plan is renderer-neutral and does not claim exact PowerPoint node sizing,
connector routing, SmartArt effects, or authoritative PNG parity. Other unmodeled
SmartArt layout IDs remain on cached drawing fallback.
