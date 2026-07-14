# FreeP SmartArt Vertical Process - 2026-07-14

## Scope

This slice admits PowerPoint SmartArt `verticalProcess` into the existing bounded FreeP live-layout path. The PPTX reader classifies the layout as `SmartArtFamily.Process` and marks it live-layout-supported only for the named `verticalProcess` layout id; unsupported process-family siblings continue to use the cached `dsp:drawing` fallback.

## Shared Layout Evidence

- `SmartArtLayoutEngine` emits renderer-neutral top-to-bottom process boxes with centered connector ops through the shared slide shape model.
- `SmartArtLayoutTests.VerticalProcess_ReturnsTopToBottomLiveBoxesAndConnectors` proves one live rounded box per node, one connector between adjacent nodes, stable node text order, and top-to-bottom geometry.
- `SmartArtTests.Compositor_VerticalProcessSmartArt_RendersSharedLiveShapes` proves a PPTX-authored `verticalProcess` diagram is read as live-layout-supported process SmartArt and consumed by the compositor as shared `DrawOp.Shape` instances.
- `PptxPackageReaderSourceTests.SmartArtPictureCaptionList_IsAdmittedOnlyThroughDeterministicNodeImages` guards the bounded live-layout allow-list, including `verticalprocess`, so broader process siblings do not become live layout accidentally.

## Deferred Work

This is not an authoritative PowerPoint geometry match. Exact PowerPoint vertical-process spacing, effects, connector styling, and any richer process-specific artwork remain deferred. SmartArt authoring regeneration is also outside this slice, as are PowerPoint-authored PNG baselines on this machine.
