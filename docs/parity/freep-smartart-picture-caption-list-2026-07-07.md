# FreeP SmartArt Picture Caption List - 2026-07-07

## Scope

This slice admits PowerPoint `pictureCaptionList` diagrams into FreeP's bounded
SmartArt live-layout path only when the reader can import actual node-level
image bytes from the cached diagram drawing.

The implementation does not add a generic SmartArt picture schema. It adds a
minimal `SmartArtNode.Picture` payload and maps cached `dsp:pic` or
`dsp:sp` blip references to parsed data nodes only when the ordered node count
and ordered image count match one-to-one. Missing or ambiguous image mapping
keeps `IsLiveLayoutSupported` disabled and preserves cached drawing fallback.

## Shared-First Behavior

- `PptxPackageReader` resolves SmartArt diagram drawing image relationships
  from `drawingN.xml.rels` and attaches node pictures only for
  `pictureCaptionList` when the mapping is deterministic.
- `SmartArtLayoutEngine` emits ordinary shared `SlideShapeKind.Picture` shapes
  plus caption text shapes for image-bearing nodes.
- `SlideCompositor` turns those shared shapes into existing `DrawOp.Picture`
  and `DrawOp.Shape` operations, so WPF and Avalonia stay thin consumers with
  no renderer-local SmartArt policy.

## Evidence

- `SmartArtLayoutTests` proves image-bearing `pictureCaptionList` data emits
  shared picture and caption shapes, composes to shared picture/text draw ops,
  and returns null for missing node images so cached fallback remains in
  control.
- `SmartArtTests` uses a no-COM PPTX fixture with `ppt/media/image1.png`,
  `drawing1.xml.rels`, and `dsp:pic` to prove the reader imports node pictures.
  A non-image `pictureCaptionList` fixture proves live layout stays disabled.

## Residual Limitations

This is not PowerPoint-authoritative visual parity. The geometry is a bounded
renderer-neutral picture-plus-caption list, and the fixture is synthetic rather
than PowerPoint-authored. Broader SmartArt picture layouts, ambiguous cached
drawing to data-node mapping, PowerPoint-authored visual baselines, and
richer picture-payload authoring remains deferred.
